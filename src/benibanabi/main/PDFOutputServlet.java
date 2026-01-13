package benibanabi.main;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.graphics.image.LosslessFactory;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionGoTo;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotationLink;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDBorderStyleDictionary;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageXYZDestination;

import com.google.gson.Gson;

@WebServlet("/PDFOutput")
public class PDFOutputServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class RoutePoint {
        public String name;
        public double lat;
        public double lng;
        public String type;      // start/normal/meal/goal
        public Integer stayTime; // 分
        public String memo;
        public String transport; // 徒歩/車/電車
        public String photoUrl;
        public String mapImage;  // 互換のため残す
    }

    public static class PdfRoutePayload {
        public String courseTitle;
        public int tripDays;
        public String startPoint;
        public String startAddress;
        public String startTime;
        public List<List<RoutePoint>> routes;

        // ★地点ページごとの地図画像：[day][i]（iは地点index）
        public List<List<String>> segmentMapImages;

        // 互換用
        public List<String> dayMapImages;
    }

    private double calcDistanceKm(double lat1, double lng1, double lat2, double lng2) {
        final double R = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(Math.toRadians(lat1)) *
            Math.cos(Math.toRadians(lat2)) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    private double getSpeedKmh(String transport) {
        if ("車".equals(transport)) return 40.0;
        if ("電車".equals(transport)) return 60.0;
        return 5.0;
    }

    private LocalTime parseStartTime(String s) {
        if (s == null || s.isEmpty()) return LocalTime.of(9, 0);
        try { return LocalTime.parse(s); } catch (Exception e) { return LocalTime.of(9, 0); }
    }

    private String formatTime(LocalTime t) {
        if (t == null) return "";
        return t.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    private String safeShort(String s, int maxLen) {
        if (s == null) return "";
        if (s.length() <= maxLen) return s;
        return s.substring(0, maxLen - 1) + "…";
    }

    private PDImageXObject loadImageFromBase64(PDDocument doc, String base64) {
        try {
            if (base64 == null || base64.trim().isEmpty()) return null;
            String b64 = base64.trim();
            int comma = b64.indexOf(',');
            if (comma >= 0) b64 = b64.substring(comma + 1);
            byte[] bytes = Base64.getDecoder().decode(b64);
            return PDImageXObject.createFromByteArray(doc, bytes, "image-b64");
        } catch (Exception e) {
            return null;
        }
    }

    private PDImageXObject loadPhotoImage(PDDocument doc, HttpServletRequest req, RoutePoint rp) {
        try {
            if (rp == null) return null;

            String urlStr = (rp.photoUrl != null) ? rp.photoUrl.trim() : "";

            // photoUrl が空なら type で defaults
            if (urlStr.isEmpty()) {
                String type = (rp.type != null) ? rp.type : "normal";
                if ("start".equals(type)) urlStr = "/images/defaults/start.jpg";
                else if ("goal".equals(type)) urlStr = "/images/defaults/goal.jpg";
                else if ("meal".equals(type)) urlStr = "/images/defaults/meal.jpg";
                else return null;
            }

            String p = urlStr.trim();

            // 1) dataURL
            if (p.startsWith("data:image/")) {
                PDImageXObject x = loadImageFromBase64(doc, p);
                if (x != null) return x;
            }

            // 2) http/https
            if (p.startsWith("http://") || p.startsWith("https://")) {
                try (InputStream in = new URL(p).openStream()) {
                    BufferedImage image = ImageIO.read(in);
                    if (image == null) return null;
                    return LosslessFactory.createFromImage(doc, image);
                }
            }

            // 3) contextPath 除去
            String ctx = (req != null) ? req.getContextPath() : "";
            if (ctx != null && !ctx.isEmpty() && p.startsWith(ctx + "/")) {
                p = p.substring(ctx.length());
            }

            // 4) Webアプリ内パス
            if (!p.startsWith("/")) p = "/" + p;

            // 4-A) getResourceAsStream
            try (InputStream in = getServletContext().getResourceAsStream(p)) {
                if (in != null) {
                    BufferedImage image = ImageIO.read(in);
                    if (image != null) return LosslessFactory.createFromImage(doc, image);
                }
            } catch (Exception ignore) {}

            // 4-B) getRealPath
            String realPath = getServletContext().getRealPath(p);
            if (realPath != null) {
                File f = new File(realPath);
                if (f.exists()) {
                    BufferedImage image = ImageIO.read(f);
                    if (image != null) return LosslessFactory.createFromImage(doc, image);
                }
            }

            return null;
        } catch (Exception e) {
            return null;
        }
    }

    // [day][i]
    private String getSegmentMapB64(PdfRoutePayload payload, int day, int i) {
        if (payload == null) return null;

        if (payload.segmentMapImages != null
                && day >= 0 && day < payload.segmentMapImages.size()) {

            List<String> dayArr = payload.segmentMapImages.get(day);
            if (dayArr != null && i >= 0 && i < dayArr.size()) {
                return dayArr.get(i);
            }
        }

        // 互換
        if (payload.dayMapImages != null && day >= 0 && day < payload.dayMapImages.size()) {
            return payload.dayMapImages.get(day);
        }

        return null;
    }

    // ===== レイアウト用ヘルパ =====

    private void drawFilledRoundRect(PDPageContentStream cs, float x, float y, float w, float h,
                                     int r, int g, int b) throws IOException {
        cs.setNonStrokingColor(r, g, b);
        cs.addRect(x, y, w, h);
        cs.fill();
    }

    private void drawBorderRect(PDPageContentStream cs, float x, float y, float w, float h,
                                int r, int g, int b, float lineW) throws IOException {
        cs.setStrokingColor(r, g, b);
        cs.setLineWidth(lineW);
        cs.addRect(x, y, w, h);
        cs.stroke();
    }

    private void drawText(PDPageContentStream cs, PDType0Font font, float size,
                          float x, float y, String text,
                          int r, int g, int b) throws IOException {
        cs.setNonStrokingColor(r, g, b);
        cs.beginText();
        cs.setFont(font, size);
        cs.newLineAtOffset(x, y);
        cs.showText(text);
        cs.endText();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String json = req.getParameter("json");

        if (json == null || json.isEmpty()) {
            res.setContentType("text/plain; charset=UTF-8");
            try (PrintWriter out = res.getWriter()) {
                out.println("ルート情報が送信されていません（jsonパラメータなし）");
            }
            return;
        }

        Gson gson = new Gson();
        PdfRoutePayload payload;
        try {
            payload = gson.fromJson(json, PdfRoutePayload.class);
        } catch (Exception e) {
            res.setContentType("text/plain; charset=UTF-8");
            try (PrintWriter out = res.getWriter()) {
                out.println("JSON解析エラー: " + e.getMessage());
            }
            return;
        }

        try (PDDocument doc = new PDDocument()) {

            PDType0Font font;
            try (InputStream fontStream =
                     getServletContext().getResourceAsStream("/WEB-INF/fonts/NotoSansJP-Regular.ttf")) {
                if (fontStream == null) {
                    res.setContentType("text/plain; charset=UTF-8");
                    try (PrintWriter out = res.getWriter()) {
                        out.println("日本語フォントが読み込めませんでした。WEB-INF/fonts に配置してください。");
                    }
                    return;
                }
                font = PDType0Font.load(doc, fontStream, true);
            } catch (Exception ex) {
                res.setContentType("text/plain; charset=UTF-8");
                try (PrintWriter out = res.getWriter()) {
                    out.println("日本語フォントが読み込めませんでした。: " + ex.getMessage());
                }
                return;
            }

            // ====== 表紙 ======
            PDPage coverPage = new PDPage(PDRectangle.A4);
            doc.addPage(coverPage);

            try (PDPageContentStream cs = new PDPageContentStream(doc, coverPage)) {
                PDRectangle mb = coverPage.getMediaBox();
                float w = mb.getWidth();
                float h = mb.getHeight();

                // 背景を少し華やかに（薄いグラデっぽく2段）
                drawFilledRoundRect(cs, 0, 0, w, h, 255, 250, 245);
                drawFilledRoundRect(cs, 0, h - 230, w, 230, 255, 236, 215);

                // タイトル帯
                drawFilledRoundRect(cs, 60, h - 190, w - 120, 90, 255, 255, 255);
                drawBorderRect(cs, 60, h - 190, w - 120, 90, 230, 126, 34, 2f);

                String mainTitle = "旅行しおり";
                float titleFontSize = 32f;
                float titleWidth = font.getStringWidth(mainTitle) / 1000f * titleFontSize;
                float titleX = (w - titleWidth) / 2f;
                float titleY = h - 145;

                drawText(cs, font, titleFontSize, titleX, titleY, mainTitle, 40, 40, 40);

                // 情報カード
                float cardX = 70;
                float cardY = h - 380;
                float cardW = w - 140;
                float cardH = 170;

                drawFilledRoundRect(cs, cardX, cardY, cardW, cardH, 255, 255, 255);
                drawBorderRect(cs, cardX, cardY, cardW, cardH, 230, 126, 34, 1.5f);

                String title = (payload.courseTitle != null && !payload.courseTitle.isEmpty())
                        ? payload.courseTitle : "タイトル未設定";
                String startPoint = payload.startPoint != null ? payload.startPoint : "";
                String startAddr  = payload.startAddress != null ? payload.startAddress : "";
                String startTime  = payload.startTime != null ? payload.startTime : "";

                float tx = cardX + 18;
                float ty = cardY + cardH - 35;

                drawText(cs, font, 16, tx, ty, "コースタイトル： " + title, 20, 20, 20); ty -= 28;
                drawText(cs, font, 14, tx, ty, "旅行日数： " + payload.tripDays + " 日", 20, 20, 20); ty -= 24;
                drawText(cs, font, 14, tx, ty, "開始地点： " + startPoint + " " + startAddr, 20, 20, 20); ty -= 24;
                drawText(cs, font, 14, tx, ty, "開始時間： " + startTime, 20, 20, 20); ty -= 24;

                String nowStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm"));
                drawText(cs, font, 11, tx, cardY + 16, "作成日時： " + nowStr, 80, 80, 80);

                // 下部コピー
                drawText(cs, font, 10, 60, 40, "Generated by Benibanabi Route Maker", 120, 120, 120);
            }

            // ====== Dayページ作成 ======
            List<PDPage> overviewPages = new ArrayList<>();
            List<List<PDPage>> detailPagesByDay = new ArrayList<>();

            int dayCount = (payload.routes != null) ? payload.routes.size() : 0;

            for (int day = 0; day < dayCount; day++) {
                PDPage overview = new PDPage(PDRectangle.A4);
                doc.addPage(overview);
                overviewPages.add(overview);
            }

            for (int day = 0; day < dayCount; day++) {
                List<RoutePoint> dayRoute = payload.routes.get(day);
                List<PDPage> detailPages = new ArrayList<>();
                if (dayRoute != null) {
                    for (int i = 0; i < dayRoute.size(); i++) {
                        PDPage detail = new PDPage(PDRectangle.A4);
                        doc.addPage(detail);
                        detailPages.add(detail);
                    }
                }
                detailPagesByDay.add(detailPages);
            }

            // ====== 中身描画 ======
            LocalTime baseStartTime = parseStartTime(payload.startTime);

            for (int day = 0; day < dayCount; day++) {
                List<RoutePoint> dayRoute = payload.routes.get(day);
                PDPage overview = overviewPages.get(day);
                List<PDPage> detailPages = detailPagesByDay.get(day);

                if (dayRoute == null || dayRoute.isEmpty()) continue;

                // arriveTimes / departTimes を作る
                LocalTime current = baseStartTime;
                LocalTime[] arriveTimes = new LocalTime[dayRoute.size()];
                LocalTime[] departTimes = new LocalTime[dayRoute.size()];

                for (int i = 0; i < dayRoute.size(); i++) {
                    RoutePoint rp = dayRoute.get(i);
                    if (i == 0) {
                        arriveTimes[i] = current;
                    } else {
                        RoutePoint prev = dayRoute.get(i - 1);
                        double dist = calcDistanceKm(prev.lat, prev.lng, rp.lat, rp.lng);
                        double speed = getSpeedKmh(rp.transport != null ? rp.transport : "徒歩");
                        long moveMin = Math.round(dist / speed * 60.0);
                        current = current.plusMinutes(moveMin);
                        arriveTimes[i] = current;
                    }
                    int stay = (rp.stayTime != null) ? rp.stayTime : 0;
                    current = current.plusMinutes(stay);
                    departTimes[i] = current;
                }

                // ---- Day概要 ----
                try (PDPageContentStream cs = new PDPageContentStream(doc, overview)) {
                    PDRectangle mb = overview.getMediaBox();
                    float margin = 50;
                    float y = mb.getHeight() - margin;

                    // 背景
                    drawFilledRoundRect(cs, 0, 0, mb.getWidth(), mb.getHeight(), 255, 252, 248);

                    float headerHeight = 52;
                    float headerWidth = mb.getWidth() - margin * 2;

                    drawFilledRoundRect(cs, margin, y - headerHeight, headerWidth, headerHeight, 230, 126, 34);
                    drawText(cs, font, 22, margin + 14, y - 36, "Day " + (day + 1) + " スケジュール", 255, 255, 255);

                    y -= (headerHeight + 26);

                    // 見出し行
                    drawText(cs, font, 13, margin, y, "時刻", 30, 30, 30);
                    drawText(cs, font, 13, margin + 80, y, "スポット名（クリックで詳細へ）", 30, 30, 30);
                    y -= 12;
                    cs.setStrokingColor(230, 126, 34);
                    cs.setLineWidth(1.2f);
                    cs.moveTo(margin, y);
                    cs.lineTo(margin + headerWidth, y);
                    cs.stroke();
                    y -= 18;

                    float timeFontSize = 13f;
                    for (int i = 0; i < dayRoute.size(); i++) {
                        RoutePoint rp = dayRoute.get(i);
                        String timeStr = formatTime(arriveTimes[i]);
                        String nameStr = rp.name != null ? rp.name : "";

                        // 行カード
                        float rowH = 26;
                        drawFilledRoundRect(cs, margin, y - 6, headerWidth, rowH, 255, 255, 255);
                        drawBorderRect(cs, margin, y - 6, headerWidth, rowH, 245, 220, 200, 1f);

                        drawText(cs, font, timeFontSize, margin + 8, y + 6, timeStr, 20, 20, 20);

                        float linkX = margin + 90;
                        drawText(cs, font, timeFontSize, linkX, y + 6, nameStr, 0, 102, 204);

                        // リンク
                        PDPage targetPage = detailPages.get(i);
                        PDPageXYZDestination dest = new PDPageXYZDestination();
                        dest.setPage(targetPage);
                        dest.setTop((int) (targetPage.getMediaBox().getHeight() - margin));

                        PDActionGoTo action = new PDActionGoTo();
                        action.setDestination(dest);

                        PDAnnotationLink link = new PDAnnotationLink();
                        link.setAction(action);
                        PDBorderStyleDictionary border = new PDBorderStyleDictionary();
                        border.setWidth(0);
                        link.setBorderStyle(border);

                        float nameWidth = font.getStringWidth(nameStr) / 1000f * timeFontSize;
                        PDRectangle rect = new PDRectangle(linkX, y + 3, nameWidth + 2, timeFontSize + 10);
                        link.setRectangle(rect);
                        overview.getAnnotations().add(link);

                        y -= 30;
                        if (y < margin + 50) break;
                    }
                }

                // ---- 詳細 ----
                for (int i = 0; i < dayRoute.size(); i++) {
                    RoutePoint rp = dayRoute.get(i);
                    PDPage page = detailPages.get(i);
                    PDRectangle mb = page.getMediaBox();
                    float margin = 50;

                    // prev
                    RoutePoint prev = (i > 0) ? dayRoute.get(i - 1) : null;
                    double dist = 0.0;
                    double moveMin = 0.0;
                    String transport = (rp.transport != null) ? rp.transport : "徒歩";

                    if (prev != null) {
                        dist = calcDistanceKm(prev.lat, prev.lng, rp.lat, rp.lng);
                        double speed = getSpeedKmh(transport);
                        moveMin = (dist / speed) * 60.0;
                    }

                    // 画像
                    PDImageXObject photoImage = loadPhotoImage(doc, req, rp);
                    String segMapB64 = getSegmentMapB64(payload, day, i);
                    PDImageXObject mapImage = loadImageFromBase64(doc, segMapB64);

                    // ★滞在時間
                    int stayMin = (rp.stayTime != null) ? rp.stayTime : 0;
                    String arriveStr = formatTime(arriveTimes[i]);
                    String departStr = formatTime(departTimes[i]);

                    try (PDPageContentStream cs = new PDPageContentStream(doc, page)) {

                        // 背景
                        drawFilledRoundRect(cs, 0, 0, mb.getWidth(), mb.getHeight(), 255, 252, 248);

                        float y = mb.getHeight() - margin;

                        // タイトル帯
                        String title;
                        if (prev != null) {
                            title = String.format("Day %d 地点%d: %s → %s",
                                    day + 1, i + 1,
                                    safeShort(prev.name, 12),
                                    safeShort(rp.name, 12));
                        } else {
                            title = String.format("Day %d 地点%d: %s",
                                    day + 1, i + 1,
                                    safeShort(rp.name, 20));
                        }

                        float titleH = 44;
                        float titleW = mb.getWidth() - margin * 2;
                        drawFilledRoundRect(cs, margin, y - titleH, titleW, titleH, 255, 236, 215);
                        drawBorderRect(cs, margin, y - titleH, titleW, titleH, 230, 126, 34, 1.4f);
                        drawText(cs, font, 16, margin + 12, y - 28, title, 30, 30, 30);

                        y -= (titleH + 22);

                        // 画像枠
                        float imgH = 210;
                        float imgW = 210;
                        float imgY = y - imgH;

                        // 左：写真
                        drawFilledRoundRect(cs, margin, imgY, imgW, imgH, 255, 255, 255);
                        drawBorderRect(cs, margin, imgY, imgW, imgH, 245, 220, 200, 1.2f);
                        if (photoImage != null) {
                            cs.drawImage(photoImage, margin + 6, imgY + 6, imgW - 12, imgH - 12);
                        } else {
                            drawText(cs, font, 12, margin + 16, imgY + imgH / 2, "写真なし", 120, 120, 120);
                        }

                        // 右：地図
                        float mapX = margin + imgW + 22;
                        float mapW = mb.getWidth() - margin - mapX;
                        float mapH = imgH;

                        drawFilledRoundRect(cs, mapX, imgY, mapW, mapH, 255, 255, 255);
                        drawBorderRect(cs, mapX, imgY, mapW, mapH, 245, 220, 200, 1.2f);
                        if (mapImage != null) {
                            cs.drawImage(mapImage, mapX + 6, imgY + 6, mapW - 12, mapH - 12);
                        } else {
                            drawText(cs, font, 12, mapX + 16, imgY + mapH / 2, "MAP", 120, 120, 120);
                        }

                        y = imgY - 18;

                        // 情報カード（下半分が寂しくならない対策）
                        float infoW = mb.getWidth() - margin * 2;
                        float infoH = 150;
                        float infoY = y - infoH;

                        drawFilledRoundRect(cs, margin, infoY, infoW, infoH, 255, 255, 255);
                        drawBorderRect(cs, margin, infoY, infoW, infoH, 245, 220, 200, 1.2f);

                        float tx = margin + 14;
                        float ty = infoY + infoH - 26;

                        // ★滞在時間表示（到着→滞在→出発）
                        drawText(cs, font, 14, tx, ty, "到着： " + arriveStr + "　滞在： " + stayMin + " 分　出発： " + departStr, 30, 30, 30);
                        ty -= 24;

                        drawText(cs, font, 13, tx, ty, "移動手段： " + transport, 30, 30, 30);
                        ty -= 22;

                        if (prev != null) {
                            drawText(cs, font, 13, tx, ty, String.format("概算移動時間： %.0f 分", moveMin), 30, 30, 30);
                            ty -= 22;
                            drawText(cs, font, 13, tx, ty, String.format("移動距離： %.1f km", dist), 30, 30, 30);
                            ty -= 22;
                        } else {
                            drawText(cs, font, 13, tx, ty, "移動時間・距離： （スタート地点）", 100, 100, 100);
                            ty -= 22;
                        }

                        // メモ枠（大きめ）
                        float memoBoxY = infoY - 170;
                        float memoBoxH = 160;
                        drawFilledRoundRect(cs, margin, memoBoxY, infoW, memoBoxH, 255, 255, 255);
                        drawBorderRect(cs, margin, memoBoxY, infoW, memoBoxH, 245, 220, 200, 1.2f);

                        drawText(cs, font, 13, margin + 14, memoBoxY + memoBoxH - 24, "メモ", 30, 30, 30);

                        // 罫線（書き込める感じ）
                        cs.setStrokingColor(235, 235, 235);
                        cs.setLineWidth(1f);
                        float lineY = memoBoxY + memoBoxH - 44;
                        for (int ln = 0; ln < 6; ln++) {
                            cs.moveTo(margin + 12, lineY);
                            cs.lineTo(margin + infoW - 12, lineY);
                            cs.stroke();
                            lineY -= 20;
                        }

                        String memo = (rp.memo != null) ? rp.memo : "";
                        // 1行だけ軽く表示（長文は溢れるので控えめ）
                        drawText(cs, font, 11, margin + 14, memoBoxY + memoBoxH - 62, safeShort(memo, 90), 80, 80, 80);
                    }
                }
            }

            res.setContentType("application/pdf");
            String fileName = "route_" +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) +
                    ".pdf";
            res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            doc.save(res.getOutputStream());

        } catch (Exception e) {
            res.setContentType("text/plain; charset=UTF-8");
            try (PrintWriter out = res.getWriter()) {
                out.println("PDF生成中にエラーが発生しました: " + e.getMessage());
            }
        }
    }
}
