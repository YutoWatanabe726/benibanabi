package benibanabi.main;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
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
import java.util.Random;

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
import org.apache.pdfbox.pdmodel.font.PDType1Font;
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

    private static final String[] START_DEFAULTS = {
        "/images/defaults/start.jpg",
        "/images/defaults/start2.jpg"
    };
    private static final String[] GOAL_DEFAULTS = {
        "/images/defaults/goal.jpg",
        "/images/defaults/goal2.jpg",
        "/images/defaults/goal3.jpg"
    };
    private static final String[] MEAL_DEFAULTS = {
        "/images/defaults/meal.jpg",
        "/images/defaults/meal2.jpg",
        "/images/defaults/meal3.jpg",
        "/images/defaults/meal4.jpg"
    };

    private String formatDurationMinutes(int minutes) {
        int m = Math.max(0, minutes);
        int h = m / 60;
        int r = m % 60;
        if (h <= 0) return r + "分";
        if (r == 0) return h + "時間";
        return h + "時間" + r + "分";
    }

    private String formatDurationMinutesDouble(double minutes) {
    	if (Double.isNaN(minutes) || Double.isInfinite(minutes) || minutes < 0) {
            return "―";
        }
    	int m = (int) Math.round(minutes);
        return formatDurationMinutes(m);
    }

    private String pickRandom(String[] arr, Random rnd) {
        if (arr == null || arr.length == 0) return "";
        return arr[rnd.nextInt(arr.length)];
    }

    private double calcDistanceKm(double lat1, double lng1, double lat2, double lng2) {
    	if (Double.isNaN(lat1) || Double.isNaN(lng1) || Double.isNaN(lat2) || Double.isNaN(lng2)) {
            return 0.0; // 異常値なら距離0とする
        }
        // 同じ地点なら0
        if (lat1 == lat2 && lng1 == lng2) {
            return 0.0;
        }
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
        if (transport == null || transport.trim().isEmpty()) return 5.0;
        String t = transport.trim();
        if ("車".equals(t) || "自動車".equals(t)) return 40.0;
        if ("電車".equals(t) || "train".equalsIgnoreCase(t)) return 60.0;
        return 5.0; // 徒歩、他
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

            BufferedImage original = ImageIO.read(new ByteArrayInputStream(bytes));
            if (original == null) {
                System.err.println("Base64画像読み込み失敗: null");
                return null;
            }

            // ★ 常にリサイズ（幅800px以下に強制）
            int maxWidth = 800;
            int width = original.getWidth();
            int height = original.getHeight();

            if (width > maxWidth) {
                double ratio = (double) maxWidth / width;
                int newHeight = (int) (height * ratio);
                BufferedImage resized = new BufferedImage(maxWidth, newHeight, BufferedImage.TYPE_INT_RGB);
                Graphics2D g2d = resized.createGraphics();
                g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);  // 高品質リサイズ
                g2d.drawImage(original.getScaledInstance(maxWidth, newHeight, Image.SCALE_SMOOTH), 0, 0, null);
                g2d.dispose();
                original = resized;
            }

            // ★ JPEGとして圧縮して保存（品質0.75）
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(original, "jpeg", baos);
            byte[] compressedBytes = baos.toByteArray();

            return PDImageXObject.createFromByteArray(doc, compressedBytes, "compressed-jpeg");

        } catch (Exception e) {
            System.err.println("Base64画像処理エラー: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private PDImageXObject loadImageAny(PDDocument doc, HttpServletRequest req, String urlOrPath) {
        try {
            if (urlOrPath == null || urlOrPath.trim().isEmpty()) return null;
            String p = urlOrPath.trim();

            if (p.startsWith("data:image/")) {
                PDImageXObject x = loadImageFromBase64(doc, p);
                if (x != null) return x;
            }

            if (p.startsWith("http://") || p.startsWith("https://")) {
                try (InputStream in = new URL(p).openStream()) {
                    BufferedImage image = ImageIO.read(in);
                    if (image == null) return null;
                    return LosslessFactory.createFromImage(doc, image);
                }
            }

            String ctx = (req != null) ? req.getContextPath() : "";
            if (ctx != null && !ctx.isEmpty() && p.startsWith(ctx + "/")) {
                p = p.substring(ctx.length());
            }

            if (!p.startsWith("/")) p = "/" + p;

            try (InputStream in = getServletContext().getResourceAsStream(p)) {
                if (in != null) {
                    BufferedImage image = ImageIO.read(in);
                    if (image != null) return LosslessFactory.createFromImage(doc, image);
                }
            } catch (Exception ignore) {}

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

    private PDImageXObject loadPhotoImage(PDDocument doc, HttpServletRequest req, RoutePoint rp) {
        try {
            if (rp == null) return null;
            String urlStr = (rp.photoUrl != null) ? rp.photoUrl.trim() : "";
            if (urlStr.isEmpty()) return null;
            return loadImageAny(doc, req, urlStr);
        } catch (Exception e) {
            return null;
        }
    }

    private String getSegmentMapB64(PdfRoutePayload payload, int day, int i) {
        if (payload == null) return null;

        if (payload.segmentMapImages != null
                && day >= 0 && day < payload.segmentMapImages.size()) {

            List<String> dayArr = payload.segmentMapImages.get(day);
            if (dayArr != null && i >= 0 && i < dayArr.size()) {
                return dayArr.get(i);
            }
        }

        if (payload.dayMapImages != null && day >= 0 && day < payload.dayMapImages.size()) {
            return payload.dayMapImages.get(day);
        }

        return null;
    }

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

    /**
     * PDPageContentStream に塗りつぶし円を描画するヘルパー
     * @param cs PDPageContentStream
     * @param cx 中心X
     * @param cy 中心Y
     * @param radius 半径
     * @throws IOException
     */
    private static void fillCircle(PDPageContentStream cs, float cx, float cy, float radius) throws IOException {
        final float kappa = 0.552284749831f;  // ベジェで円を近似する定数（ほぼ標準値）

        cs.moveTo(cx - radius, cy);

        // 右上 → 上
        cs.curveTo(cx - radius, cy + kappa * radius,
                   cx - kappa * radius, cy + radius,
                   cx, cy + radius);

        // 上 → 右
        cs.curveTo(cx + kappa * radius, cy + radius,
                   cx + radius, cy + kappa * radius,
                   cx + radius, cy);

        // 右 → 下
        cs.curveTo(cx + radius, cy - kappa * radius,
                   cx + kappa * radius, cy - radius,
                   cx, cy - radius);

        // 下 → 左
        cs.curveTo(cx - kappa * radius, cy - radius,
                   cx - radius, cy - kappa * radius,
                   cx - radius, cy);

        cs.closePath();
        cs.fill();  // 塗りつぶし
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

        	PDType0Font font = null;
        	String regularPath = "/WEB-INF/fonts/NotoSansJP-Regular.ttf";
        	InputStream regularStream = getServletContext().getResourceAsStream(regularPath);
        	if (regularStream != null) {
        	    try {
        	        font = PDType0Font.load(doc, regularStream, true);
        	    } catch (Exception e) {
        	        e.printStackTrace();
        	    } finally {
        	        try { regularStream.close(); } catch (Exception ignore) {}
        	    }
        	} else {
        	    System.err.println("NotoSansJP-Regular not found - using Helvetica fallback");
        	}

        	PDType0Font elegantFont = font;
        	String elegantPath = "/WEB-INF/fonts/ZenOldMincho-Regular.ttf";
        	InputStream elegantStream = getServletContext().getResourceAsStream(elegantPath);
        	if (elegantStream != null) {
        	    try {
        	        elegantFont = PDType0Font.load(doc, elegantStream, true);
        	    } catch (Exception e) {
        	        e.printStackTrace();
        	    } finally {
        	        try { elegantStream.close(); } catch (Exception ignore) {}
        	    }
        	} else {
        	    System.err.println("ZenOldMincho-Regular not found - using Helvetica fallback");
        	}

        	if (font == null && elegantFont == null) {
        	    System.err.println("All fonts failed - proceeding with Helvetica");
        	}

            Random rnd = new Random(System.nanoTime());

            String pickedStartPath = pickRandom(START_DEFAULTS, rnd);
            String pickedGoalPath  = pickRandom(GOAL_DEFAULTS, rnd);

            PDPage coverPage = new PDPage(PDRectangle.A4);
            doc.addPage(coverPage);

            try (PDPageContentStream cs = new PDPageContentStream(doc, coverPage)) {
                PDRectangle mb = coverPage.getMediaBox();
                float w = mb.getWidth();
                float h = mb.getHeight();

                // 背景
                PDImageXObject bgImage = loadImageAny(doc, req, "/images/defaults/ginzan.jpg");
                if (bgImage != null) {
                    cs.drawImage(bgImage, 0, 0, w, h);
                } else {
                    cs.setNonStrokingColor(240, 240, 245);
                    cs.addRect(0, 0, w, h);
                    cs.fill();
                }

                // 変数宣言
                String mainTitle = (payload.courseTitle != null && !payload.courseTitle.isEmpty())
                        ? payload.courseTitle
                        : "Yamagata Journey";

                String subText = payload.tripDays + "-Day Yamagata Itinerary / " + payload.tripDays + "日の旅行";

                float titleSize = 54f;
                float subSize = 22f;
                float titleX = w / 2;
                float titleY = h - 180;
                float subY = titleY - 60;
                float titleWidth = 0;
                float subX = w / 2;
                float subWidth = 0;

                int[] shadowOffsets = {0, 1, 2, 3, 4};

                // タイトル描画
                PDType0Font safeTitleFont = (elegantFont != null) ? elegantFont : font;
                if (safeTitleFont != null) {
                    titleWidth = safeTitleFont.getStringWidth(mainTitle) / 1000f * titleSize;
                    titleX = (w / 2) - (titleWidth / 2);

                    for (int offset : shadowOffsets) {
                        drawText(cs, safeTitleFont, titleSize, titleX + offset, titleY - offset, mainTitle, 0, 0, 0);
                        drawText(cs, safeTitleFont, titleSize, titleX - offset, titleY + offset, mainTitle, 0, 0, 0);
                    }
                    drawText(cs, safeTitleFont, titleSize, titleX, titleY, mainTitle, 255, 255, 255);
                } else {
                    cs.beginText();
                    cs.setFont(PDType1Font.HELVETICA_BOLD, titleSize);
                    cs.newLineAtOffset(titleX - 150, titleY);
                    cs.showText(mainTitle);
                    cs.endText();  // endText() を追加
                }

                // サブタイトル描画
                if (safeTitleFont != null) {
                    subWidth = safeTitleFont.getStringWidth(subText) / 1000f * subSize;
                    subX = (w / 2) - (subWidth / 2);

                    for (int offset : shadowOffsets) {
                        drawText(cs, safeTitleFont, subSize, subX + offset, subY - offset, subText, 0, 0, 0);
                        drawText(cs, safeTitleFont, subSize, subX - offset, subY + offset, subText, 0, 0, 0);
                    }
                    drawText(cs, safeTitleFont, subSize, subX, subY, subText, 255, 255, 255);
                } else {
                    cs.beginText();
                    cs.setFont(PDType1Font.HELVETICA, subSize);
                    cs.newLineAtOffset(subX - 150, subY);
                    cs.showText(subText);
                    cs.endText();  // endText() を追加
                }

                // フッター描画
                String footerText = "© べにばナビ All Rights Reserved.";  // 日本語を英語に置き換え
                float footerSize = 10f;
                float footerX = w - 300;
                float footerY = 40;

                PDType0Font safeFont = font;
                if (safeFont != null) {
                    float footerWidth = safeFont.getStringWidth(footerText) / 1000f * footerSize;
                    footerX = w - footerWidth - 40;
                    drawText(cs, safeFont, footerSize, footerX, footerY, footerText, 255, 255, 255);
                } else {
                    cs.beginText();
                    cs.setFont(PDType1Font.HELVETICA, footerSize);
                    cs.newLineAtOffset(footerX, footerY);
                    cs.showText(footerText);
                    cs.endText();  // endText() を追加
                }
            }


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

            LocalTime baseStartTime = parseStartTime(payload.startTime);

            for (int day = 0; day < dayCount; day++) {
                List<RoutePoint> dayRoute = payload.routes.get(day);
                PDPage overview = overviewPages.get(day);
                List<PDPage> detailPages = detailPagesByDay.get(day);

                if (dayRoute == null || dayRoute.isEmpty()) continue;

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

                        if (Double.isNaN(dist) || Double.isInfinite(dist) || dist <= 0.0001) {
                            dist = 0.0;
                        }
                        double speed = getSpeedKmh(rp.transport);
                        double minutes = 0.0;
                        if (speed > 0 && dist > 0) {
                            minutes = (dist / speed) * 60.0;
                            if (Double.isNaN(minutes) || Double.isInfinite(minutes) || minutes < 0) {
                                minutes = 0.0;
                            }
                        }

                        long moveMin = (long) Math.max(0, Math.round(minutes));
                        current = current.plusMinutes(moveMin);
                        arriveTimes[i] = current;
                    }
                    int stay = (rp.stayTime != null) ? rp.stayTime : 0;
                    current = current.plusMinutes(stay);
                    departTimes[i] = current;
                }

                try (PDPageContentStream cs = new PDPageContentStream(doc, overview)) {
                    PDRectangle mb = overview.getMediaBox();
                    float margin = 50;
                    float y = mb.getHeight() - margin;

                    drawFilledRoundRect(cs, 0, 0, mb.getWidth(), mb.getHeight(), 255, 252, 248);

                    float headerHeight = 52;
                    float headerWidth = mb.getWidth() - margin * 2;

                    drawFilledRoundRect(cs, margin, y - headerHeight, headerWidth, headerHeight, 230, 126, 34);
                    drawText(cs, font, 22, margin + 14, y - 36, "Day " + (day + 1) + " スケジュール", 255, 255, 255);

                    y -= (headerHeight + 26);

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

                        float rowH = 26;
                        drawFilledRoundRect(cs, margin, y - 6, headerWidth, rowH, 255, 255, 255);
                        drawBorderRect(cs, margin, y - 6, headerWidth, rowH, 245, 220, 200, 1f);

                        drawText(cs, font, timeFontSize, margin + 8, y + 6, timeStr, 20, 20, 20);

                        float linkX = margin + 90;
                        drawText(cs, font, timeFontSize, linkX, y + 6, nameStr, 0, 102, 204);

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

                for (int i = 0; i < dayRoute.size(); i++) {
                    RoutePoint rp = dayRoute.get(i);
                    PDPage page = detailPages.get(i);
                    PDRectangle mb = page.getMediaBox();
                    float margin = 50;

                    RoutePoint prev = (i > 0) ? dayRoute.get(i - 1) : null;
                    double dist = 0.0;
                    double minutes = 0.0;
                    String transport = (rp.transport != null) ? rp.transport.trim() : "徒歩";

                    if (prev != null) {
                        dist = calcDistanceKm(prev.lat, prev.lng, rp.lat, rp.lng);

                        // dist が異常値・極小なら強制0
                        if (Double.isNaN(dist) || Double.isInfinite(dist) || dist <= 0.0001) {
                            dist = 0.0;
                        }

                        double speed = getSpeedKmh(transport);
                        if (speed > 0 && dist > 0) {
                            minutes = (dist / speed) * 60.0;
                            // minutes が異常値なら0に
                            if (Double.isNaN(minutes) || Double.isInfinite(minutes) || minutes < 0) {
                                minutes = 0.0;
                            }
                        }
                    }

                    int moveMin = (int) Math.max(0, Math.round(minutes));

                    PDImageXObject photoImage = loadPhotoImage(doc, req, rp);
                    if (photoImage == null) {
                        String type = (rp.type != null) ? rp.type : "normal";
                        String fallbackPath = "";

                        if ("start".equals(type)) {
                            fallbackPath = pickedStartPath;
                        } else if ("goal".equals(type)) {
                            fallbackPath = pickedGoalPath;
                        } else if ("meal".equals(type)) {
                            fallbackPath = pickRandom(MEAL_DEFAULTS, rnd);
                        } else {
                            fallbackPath = "";
                        }

                        if (!fallbackPath.isEmpty()) {
                            photoImage = loadImageAny(doc, req, fallbackPath);
                        }
                    }

                    String segMapB64 = getSegmentMapB64(payload, day, i);
                    PDImageXObject mapImage = loadImageFromBase64(doc, segMapB64);

                    int stayMin = (rp.stayTime != null) ? rp.stayTime : 0;
                    String arriveStr = formatTime(arriveTimes[i]);
                    String departStr = formatTime(departTimes[i]);

                    try (PDPageContentStream cs = new PDPageContentStream(doc, page)) {

                        drawFilledRoundRect(cs, 0, 0, mb.getWidth(), mb.getHeight(), 255, 252, 248);

                        float y = mb.getHeight() - margin;

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

                        float imgH = 210;
                        float imgW = 210;
                        float imgY = y - imgH;

                        drawFilledRoundRect(cs, margin, imgY, imgW, imgH, 255, 255, 255);
                        drawBorderRect(cs, margin, imgY, imgW, imgH, 245, 220, 200, 1.2f);
                        if (photoImage != null) {
                            cs.drawImage(photoImage, margin + 6, imgY + 6, imgW - 12, imgH - 12);
                        } else {
                            drawText(cs, font, 12, margin + 16, imgY + imgH / 2, "写真なし", 120, 120, 120);
                        }

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

                        float infoW = mb.getWidth() - margin * 2;
                        float infoH = 150;
                        float infoY = y - infoH;

                        drawFilledRoundRect(cs, margin, infoY, infoW, infoH, 255, 255, 255);
                        drawBorderRect(cs, margin, infoY, infoW, infoH, 245, 220, 200, 1.2f);

                        float tx = margin + 14;
                        float ty = infoY + infoH - 26;

                        drawText(cs, font, 14, tx, ty,
                                "到着： " + arriveStr + "　滞在： " + formatDurationMinutes(stayMin) + "　出発： " + departStr,
                                30, 30, 30);
                        ty -= 24;

                        drawText(cs, font, 13, tx, ty, "移動手段： " + transport, 30, 30, 30);
                        ty -= 22;

                        if (prev != null) {
                            String moveTimeStr = formatDurationMinutes(moveMin);
                            drawText(cs, font, 13, tx, ty, "概算移動時間： " + moveTimeStr, 30, 30, 30);
                            ty -= 22;

                            String distStr = (dist <= 0.0001 || Double.isNaN(dist) || Double.isInfinite(dist))
                                    ? "―"
                                    : String.format("%.1f km", dist);
                            drawText(cs, font, 13, tx, ty, "移動距離： " + distStr, 30, 30, 30);
                            ty -= 22;
                        } else {
                            drawText(cs, font, 13, tx, ty, "移動時間・距離： （スタート地点）", 100, 100, 100);
                            ty -= 22;
                        }

                        float memoBoxY = infoY - 170;
                        float memoBoxH = 160;
                        drawFilledRoundRect(cs, margin, memoBoxY, infoW, memoBoxH, 255, 255, 255);
                        drawBorderRect(cs, margin, memoBoxY, infoW, memoBoxH, 245, 220, 200, 1.2f);

                        drawText(cs, font, 13, margin + 14, memoBoxY + memoBoxH - 24, "メモ", 30, 30, 30);

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
                        drawText(cs, font, 11, margin + 14, memoBoxY + memoBoxH - 62, safeShort(memo, 90), 80, 80, 80);
                    }
                }
            }

         // ==========================
         // 裏表紙（インフォメーションページ）
         // ==========================
         PDPage backPage = new PDPage(PDRectangle.A4);
         doc.addPage(backPage);

         try (PDPageContentStream cs = new PDPageContentStream(doc, backPage)) {
             PDRectangle mb = backPage.getMediaBox();
             float w = mb.getWidth();
             float h = mb.getHeight();

             // 背景
             drawFilledRoundRect(cs, 0, 0, w, h, 245, 240, 232);

             // 中央カード
             float m = 60;
             drawFilledRoundRect(cs, m, m, w - m * 2, h - m * 2, 255, 255, 255);
             drawBorderRect(cs, m, m, w - m * 2, h - m * 2, 200, 190, 170, 1.2f);

          // タイトル（日本語）
             drawText(cs, font, 24, m + 40, h - 130,
                     "旅行中の緊急連絡先", 40, 40, 40);

             // サブタイトル（英語）
             drawText(cs, font, 16, m + 40, h - 165,
                     "Emergency contact information while traveling", 90, 90, 90);


             float tx = m + 40;
             float ty = h - 220;
             float lh = 26;


             drawText(cs, font, 14, tx, ty, "警察 (Police) : 110", 30, 30, 30); ty -= lh;
             drawText(cs, font, 14, tx, ty, "火事・救急車 (Fire ・ Ambulance) : 119", 30, 30, 30); ty -= lh;
             drawText(cs, font, 14, tx, ty, "海上の事故 (Accident at sea) : 118", 30, 30, 30); ty -= lh * 1.2f;

             drawText(cs, font, 14, tx, ty, "JNTO（観光案内・災害相談）", 30, 30, 30); ty -= lh;
             drawText(cs, font, 14, tx + 20, ty,
            		    "Tourist information・ ",
            		    30, 30, 30);
            		ty -= 22;

            		drawText(cs, font, 14, tx + 20, ty,
            		    "Disaster consultation",
            		    30, 30, 30);
            		ty -= 26;

             drawText(cs, font, 14, tx + 20, ty, "TEL : 050-3816-2787", 30, 30, 30);

             float textAreaWidth = 360;


             PDImageXObject map = loadImageAny(doc, req, "/images/defaults/yamagata.jpg");
             if (map != null) {

                 float maxW = 180;   // ← 裏表紙ではこれ以上大きくしない
                 float maxH = 260;

                 float iw = map.getWidth();
                 float ih = map.getHeight();

                 float scale = Math.min(maxW / iw, maxH / ih);

                 float dw = iw * scale;
                 float dh = ih * scale;

                 // ★ 右上固定（安全）
                 float x = w - m - dw - 20;
                 float y = h - m - dh - 120;

                 cs.drawImage(map, x, y, dw, dh);
             }

          // 下部イラスト（中央）
             PDImageXObject illust = loadImageAny(doc, req, "/images/defaults/benichan.png");
             if (illust != null) {
                 float iw = illust.getWidth();
                 float ih = illust.getHeight();

                 // 表示サイズ（ここ調整OK）
                 float targetW = 180f;
                 float scale = targetW / iw;

                 float dw = iw * scale;
                 float dh = ih * scale;

                 // 中央寄せ + 下部
                 float x = (w - dw) / 2;
                 float y = m + 70; // フッターより少し上

                 cs.drawImage(illust, x, y, dw, dh);
             }




             // フッター
             drawText(cs, font, 11, w / 2 - 90, m + 30, "Have a nice trip in Yamagata", 150, 150, 150);
         }


            // =========================
            // ★ここが重要：PDFを「表示」させる（inline）
            // =========================
            res.reset();
            res.setContentType("application/pdf");
            res.setCharacterEncoding("UTF-8");

            // キャッシュ抑止（更新連打時に古いPDFが出るのを防ぐ）
            res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);

            String fileName = "route_" +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) +
                    ".pdf";

            // ★attachment → inline に変更
            res.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

            doc.save(res.getOutputStream());
            res.getOutputStream().flush();

        } catch (OutOfMemoryError ome) {
            log("メモリ不足エラー user=" + req.getRemoteAddr() + " size=" +
                (req.getContentLengthLong() / 1024) + "KB", ome);

            String type = "out_of_memory";
            String message = "サーバーのメモリが不足しています。スポットを減らしてください。";

            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.setContentType("application/json; charset=UTF-8");

            try (PrintWriter out = res.getWriter()) {
                out.print("{");
                out.print("\"status\":\"error\",");
                out.print("\"type\":\"" + type + "\",");
                out.print("\"message\":\"" + message.replace("\"", "\\\"") + "\"");
                out.print("}");
            }
        } catch (Exception e) {
        	e.printStackTrace();
            log("PDF生成エラー user=" + req.getRemoteAddr() + " size=" +
                (req.getContentLengthLong() / 1024) + "KB", e);

            String type = "unknown";
            String message = e.getMessage() != null ? e.getMessage() : "不明なエラー";

            // フォント関連エラーなどの追加分岐（必要に応じて）
            if (message.contains("font") || message.contains("NotoSansJP")) {
                type = "font_error";
                message = "日本語フォントの読み込みに失敗しました。";
            } else if (req.getContentLengthLong() > 10_000_000) { // 10MB超え
                type = "payload_too_large";
                message = "データ量が多すぎます（" + (req.getContentLengthLong()/1024/1024) + "MB）。スポットを減らしてください。";
            }

            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.setContentType("application/json; charset=UTF-8");

            try (PrintWriter out = res.getWriter()) {
                out.print("{");
                out.print("\"status\":\"error\",");
                out.print("\"type\":\"" + type + "\",");
                out.print("\"message\":\"" + message.replace("\"", "\\\"") + "\"");
                out.print("}");
            }
        }
    }
}
