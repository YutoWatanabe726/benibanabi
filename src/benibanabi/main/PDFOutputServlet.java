package benibanabi.main;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

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
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionGoTo;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotationLink;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDBorderStyleDictionary;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageXYZDestination;

import com.google.gson.Gson;

/**
 * PDFOutputServlet
 * ルート情報(JSON)を受け取り、旅行しおりPDFを生成する。
 *
 * URL: /PDFOutput
 */
@WebServlet("/PDFOutput")
public class PDFOutputServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // JSON 受け取り用の内部クラス ---------------------------
    public static class RoutePoint {
        public String name;
        public double lat;
        public double lng;
        public String type;      // start/normal/meal/goal
        public Integer stayTime; // 分
        public String memo;
        public String transport; // 徒歩/車/電車
        public String photoUrl;  // /images/xxx.jpg
        public String mapImage;  // Base64 (今は未使用でもOK)
    }

    public static class PdfRoutePayload {
        public String courseTitle;
        public int tripDays;
        public String startPoint;
        public String startAddress;
        public String startTime;
        public List<List<RoutePoint>> routes;
    }

    // 距離計算用（km）
    private double calcDistanceKm(double lat1, double lng1, double lat2, double lng2) {
        final double R = 6371.0; // 地球の半径 km
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

    // 速度 km/h
    private double getSpeedKmh(String transport) {
        if ("車".equals(transport)) return 40.0;
        if ("電車".equals(transport)) return 60.0;
        // デフォルト徒歩
        return 5.0;
    }

    private LocalTime parseStartTime(String s) {
        if (s == null || s.isEmpty()) {
            return LocalTime.of(9, 0);
        }
        try {
            return LocalTime.parse(s);
        } catch (Exception e) {
            return LocalTime.of(9, 0);
        }
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

    // 画像読み込み（/images/xxx.jpg → PDF画像）
    private PDImageXObject loadImageFromWebPath(PDDocument doc, String webPath) {
        try {
            if (webPath == null || webPath.isEmpty()) return null;
            String realPath = getServletContext().getRealPath(webPath);
            if (realPath == null) return null;
            File f = new File(realPath);
            if (!f.exists()) return null;
            return PDImageXObject.createFromFileByContent(f, doc);
        } catch (Exception e) {
            return null;
        }
    }

    // Base64（地図）→ PDF画像（※今は mapImage が空でもOK）
    private PDImageXObject loadImageFromBase64(PDDocument doc, String base64) {
        try {
            if (base64 == null || base64.isEmpty()) return null;
            byte[] bytes = Base64.getDecoder().decode(base64);
            return PDImageXObject.createFromByteArray(doc, bytes, "map-image");
        } catch (Exception e) {
            return null;
        }
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

        // JSON → Javaオブジェクト
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

        // PDF生成
        try (PDDocument doc = new PDDocument()) {

            // 日本語フォント読み込み（WEB-INF/fonts/NotoSansJP-Regular.ttf）
            PDType0Font font;
            try (InputStream fontStream =
                     getServletContext().getResourceAsStream("/WEB-INF/fonts/NotoSansJP-Regular.ttf")) {
                if (fontStream == null) {
                    res.setContentType("text/plain; charset=UTF-8");
                    try (PrintWriter out = res.getWriter()) {
                        out.println("日本語フォントが読み込めませんでした。WEB-INF/fonts にフォントを配置してください。: null");
                    }
                    return;
                }
                font = PDType0Font.load(doc, fontStream, true);
            } catch (Exception ex) {
                res.setContentType("text/plain; charset=UTF-8");
                try (PrintWriter out = res.getWriter()) {
                    out.println("日本語フォントが読み込めませんでした。WEB-INF/fonts にフォントを配置してください。: " + ex.getMessage());
                }
                return;
            }

            // ====== 1. 表紙ページ ======
            PDPage coverPage = new PDPage(PDRectangle.A4);
            doc.addPage(coverPage);
            float coverMargin = 60;

            try (PDPageContentStream cs = new PDPageContentStream(doc, coverPage)) {
                PDRectangle mb = coverPage.getMediaBox();
                float w = mb.getWidth();
                float h = mb.getHeight();

                // 背景の薄いオレンジ帯
                cs.setNonStrokingColor(255, 242, 230);
                cs.addRect(0, h - 200, w, 200);
                cs.fill();

                // タイトル
                cs.setNonStrokingColor(0, 0, 0);
                String mainTitle = "旅行しおり";
                float titleFontSize = 30f;
                float titleWidth = font.getStringWidth(mainTitle) / 1000f * titleFontSize;
                float titleX = (w - titleWidth) / 2f;
                float titleY = h - coverMargin - 40;

                cs.beginText();
                cs.setFont(font, titleFontSize);
                cs.newLineAtOffset(titleX, titleY);
                cs.showText(mainTitle);
                cs.endText();

                // コースタイトル
                cs.beginText();
                cs.setFont(font, 20);
                cs.newLineAtOffset(coverMargin, h - coverMargin - 120);
                String title = (payload.courseTitle != null && !payload.courseTitle.isEmpty())
                        ? payload.courseTitle
                        : "タイトル未設定";
                cs.showText("コースタイトル： " + title);
                cs.endText();

                // 日数
                cs.beginText();
                cs.setFont(font, 16);
                cs.newLineAtOffset(coverMargin, h - coverMargin - 160);
                cs.showText("旅行日数： " + payload.tripDays + " 日");
                cs.endText();

                // 開始地点・時間
                String startPoint = payload.startPoint != null ? payload.startPoint : "";
                String startAddr  = payload.startAddress != null ? payload.startAddress : "";
                String startTime  = payload.startTime != null ? payload.startTime : "";

                cs.beginText();
                cs.setFont(font, 16);
                cs.newLineAtOffset(coverMargin, h - coverMargin - 200);
                cs.showText("開始地点： " + startPoint + " " + startAddr);
                cs.endText();

                cs.beginText();
                cs.setFont(font, 16);
                cs.newLineAtOffset(coverMargin, h - coverMargin - 230);
                cs.showText("開始時間： " + startTime);
                cs.endText();

                // 作成日時
                cs.beginText();
                cs.setFont(font, 12);
                cs.newLineAtOffset(coverMargin, h - coverMargin - 270);
                String nowStr = LocalDateTime.now()
                        .format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm"));
                cs.showText("作成日時： " + nowStr);
                cs.endText();

                // フッター
                cs.beginText();
                cs.setFont(font, 12);
                cs.newLineAtOffset(coverMargin, coverMargin + 30);
                cs.showText("Generated by Benibanabi Route Maker");
                cs.endText();
            }

            // ====== 2. Dayごとのページ構成 ======
            List<PDPage> overviewPages = new ArrayList<>();
            List<List<PDPage>> detailPagesByDay = new ArrayList<>();

            int dayCount = (payload.routes != null) ? payload.routes.size() : 0;

            // 2-1. 先に「Dayスケジュール」ページをすべて作成
            for (int day = 0; day < dayCount; day++) {
                PDPage overview = new PDPage(PDRectangle.A4);
                doc.addPage(overview);
                overviewPages.add(overview);
            }

            // 2-2. そのあとにスポット詳細ページをすべて作成
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

            // ====== 3. 中身の描画（Day概要・スポット詳細） ======
            LocalTime baseStartTime = parseStartTime(payload.startTime);

            for (int day = 0; day < dayCount; day++) {
                List<RoutePoint> dayRoute = payload.routes.get(day);
                PDPage overview = overviewPages.get(day);
                List<PDPage> detailPages = detailPagesByDay.get(day);

                if (dayRoute == null || dayRoute.isEmpty()) {
                    continue;
                }

                // ---- 3-1. この日の到着時刻を計算 ----
                LocalTime current = baseStartTime;
                LocalTime[] arriveTimes = new LocalTime[dayRoute.size()];

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
                    int stay = rp.stayTime != null ? rp.stayTime : 0;
                    current = current.plusMinutes(stay);
                }

                // ---- 3-2. Day概要ページ（タイムライン＋スポットリンク） ----
                try (PDPageContentStream cs = new PDPageContentStream(doc, overview)) {
                    PDRectangle mb = overview.getMediaBox();
                    float margin = 50;
                    float y = mb.getHeight() - margin;

                    // 見出し用オレンジ帯
                    float headerHeight = 50;
                    float headerWidth = mb.getWidth() - margin * 2;

                    cs.setNonStrokingColor(230, 126, 34); // オレンジ
                    cs.addRect(margin, y - headerHeight, headerWidth, headerHeight);
                    cs.fill();

                    // 見出しテキスト（白文字・中央）
                    String headerTitle = "Day " + (day + 1) + " スケジュール";
                    float headerFontSize = 22f;
                    float headerTextWidth = font.getStringWidth(headerTitle) / 1000f * headerFontSize;
                    float headerTextX = margin + (headerWidth - headerTextWidth) / 2f;
                    float headerTextY = y - headerHeight / 2f - headerFontSize / 2f + 8;

                    cs.setNonStrokingColor(255, 255, 255);
                    cs.beginText();
                    cs.setFont(font, headerFontSize);
                    cs.newLineAtOffset(headerTextX, headerTextY);
                    cs.showText(headerTitle);
                    cs.endText();

                    y -= (headerHeight + 40);

                    // ヘッダ行
                    cs.setNonStrokingColor(0, 0, 0);
                    cs.beginText();
                    cs.setFont(font, 14);
                    cs.newLineAtOffset(margin, y);
                    cs.showText("時刻        | スポット名（クリックで詳細へ）");
                    cs.endText();
                    y -= 25;

                    // 下線
                    cs.setNonStrokingColor(230, 126, 34);
                    cs.setLineWidth(1.5f);
                    cs.moveTo(margin, y);
                    cs.lineTo(margin + headerWidth, y);
                    cs.stroke();
                    y -= 20;

                    // 各行：時刻＋スポット名（リンク付き）
                    float timeFontSize = 14f;
                    String sampleTime = "00:00";
                    float timeWidth = font.getStringWidth(sampleTime) / 1000f * timeFontSize;

                    for (int i = 0; i < dayRoute.size(); i++) {
                        RoutePoint rp = dayRoute.get(i);
                        LocalTime at = arriveTimes[i];
                        String timeStr = formatTime(at);
                        String nameStr = rp.name != null ? rp.name : "";

                        float textX = margin;
                        float textY = y;

                        // 時刻（黒）
                        cs.setNonStrokingColor(0, 0, 0);
                        cs.beginText();
                        cs.setFont(font, timeFontSize);
                        cs.newLineAtOffset(textX, textY);
                        cs.showText(timeStr);
                        cs.endText();

                        // 区切り "  |  "
                        String delim = "   |  ";
                        float delimWidth = font.getStringWidth(delim) / 1000f * timeFontSize;
                        float delimX = textX + timeWidth + 8;

                        cs.beginText();
                        cs.setFont(font, timeFontSize);
                        cs.newLineAtOffset(delimX, textY);
                        cs.showText(delim);
                        cs.endText();

                        // スポット名（青色＆リンク）
                        float linkX = delimX + delimWidth;
                        cs.setNonStrokingColor(0, 102, 204); // 青
                        cs.beginText();
                        cs.setFont(font, timeFontSize);
                        cs.newLineAtOffset(linkX, textY);
                        cs.showText(nameStr);
                        cs.endText();
                        cs.setNonStrokingColor(0, 0, 0); // 色を戻す

                        // リンク先（詳細ページ）設定
                        PDPage targetPage = detailPages.get(i);  // 同じインデックスの詳細ページへ
                        PDPageXYZDestination dest = new PDPageXYZDestination();
                        dest.setPage(targetPage);
                        dest.setTop((int) (targetPage.getMediaBox().getHeight() - margin));

                        PDActionGoTo action = new PDActionGoTo();
                        action.setDestination(dest);

                        PDAnnotationLink link = new PDAnnotationLink();
                        link.setAction(action);
                        PDBorderStyleDictionary border = new PDBorderStyleDictionary();
                        border.setWidth(0); // 枠線なし
                        link.setBorderStyle(border);

                        float nameWidth = font.getStringWidth(nameStr) / 1000f * timeFontSize;
                        PDRectangle rect = new PDRectangle(linkX,
                                textY - 2,
                                nameWidth + 2,
                                timeFontSize + 4);
                        link.setRectangle(rect);

                        overview.getAnnotations().add(link);

                        y -= 25;
                        if (y < margin + 60) {
                            // 1ページに収まらないケースは今回は想定しない
                            break;
                        }
                    }
                }

                // ---- 3-3. スポット詳細ページ ----
                for (int i = 0; i < dayRoute.size(); i++) {
                    RoutePoint rp = dayRoute.get(i);
                    PDPage page = detailPages.get(i);
                    PDRectangle mb = page.getMediaBox();
                    float margin = 50;
                    float y = mb.getHeight() - margin;

                    RoutePoint prev = (i > 0) ? dayRoute.get(i - 1) : null;
                    double dist = 0.0;
                    double moveMin = 0.0;
                    String transport = (rp.transport != null) ? rp.transport : "徒歩";

                    if (prev != null) {
                        dist = calcDistanceKm(prev.lat, prev.lng, rp.lat, rp.lng);
                        double speed = getSpeedKmh(transport);
                        moveMin = (dist / speed) * 60.0;
                    }

                    PDImageXObject photoImage = loadImageFromWebPath(doc, rp.photoUrl);
                    PDImageXObject mapImage = loadImageFromBase64(doc, rp.mapImage);

                    try (PDPageContentStream cs = new PDPageContentStream(doc, page)) {

                        // タイトル：地点名 or 「前の地点 → この地点」
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

                        // タイトル帯
                        float titleHeight = 40;
                        float titleWidth = mb.getWidth() - margin * 2;

                        cs.setNonStrokingColor(255, 229, 204);
                        cs.addRect(margin, y - titleHeight, titleWidth, titleHeight);
                        cs.fill();

                        cs.setNonStrokingColor(0, 0, 0);
                        cs.beginText();
                        cs.setFont(font, 18);
                        cs.newLineAtOffset(margin + 10, y - titleHeight + 12);
                        cs.showText(title);
                        cs.endText();

                        y -= (titleHeight + 40);

                        // 写真（左）
                        float imgHeight = 200;
                        float imgWidth = 200;
                        float imgY = y - imgHeight;

                        if (photoImage != null) {
                            cs.drawImage(photoImage, margin, imgY, imgWidth, imgHeight);
                        } else {
                            cs.setNonStrokingColor(200, 200, 200);
                            cs.addRect(margin, imgY, imgWidth, imgHeight);
                            cs.stroke();
                            cs.beginText();
                            cs.setFont(font, 12);
                            cs.setNonStrokingColor(0, 0, 0);
                            cs.newLineAtOffset(margin + 10, imgY + imgHeight / 2);
                            cs.showText("写真なし");
                            cs.endText();
                        }

                        // 地図（右側）
                        float mapX = margin + imgWidth + 30;
                        float mapWidth = mb.getWidth() - margin - mapX;
                        float mapHeight = imgHeight;

                        if (mapImage != null) {
                            cs.drawImage(mapImage, mapX, imgY, mapWidth, mapHeight);
                        } else {
                            cs.setNonStrokingColor(200, 200, 200);
                            cs.addRect(mapX, imgY, mapWidth, mapHeight);
                            cs.stroke();
                            cs.beginText();
                            cs.setFont(font, 12);
                            cs.setNonStrokingColor(0, 0, 0);
                            cs.newLineAtOffset(mapX + 10, imgY + mapHeight / 2);
                            cs.showText("MAP");
                            cs.endText();
                        }

                        y = imgY - 40;

                        // 移動手段・距離・時間
                        cs.setNonStrokingColor(0, 0, 0);
                        cs.beginText();
                        cs.setFont(font, 14);
                        cs.newLineAtOffset(margin, y);
                        cs.showText("移動手段： " + transport);
                        cs.endText();
                        y -= 22;

                        if (prev != null) {
                            cs.beginText();
                            cs.setFont(font, 14);
                            cs.newLineAtOffset(margin, y);
                            cs.showText(String.format("概算移動時間（分）： %.0f 分", moveMin));
                            cs.endText();
                            y -= 22;

                            cs.beginText();
                            cs.setFont(font, 14);
                            cs.newLineAtOffset(margin, y);
                            cs.showText(String.format("移動距離（km）： %.1f km", dist));
                            cs.endText();
                            y -= 30;
                        }

                        // メモ
                        String memo = (rp.memo != null) ? rp.memo : "";
                        cs.beginText();
                        cs.setFont(font, 14);
                        cs.newLineAtOffset(margin, y);
                        cs.showText("メモ： " + safeShort(memo, 80));
                        cs.endText();
                    }
                }
            }

            // ====== 4. レスポンスとしてPDFを返却 ======
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
