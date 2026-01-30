package benibanabi.main;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.json.JSONArray;
import org.json.JSONObject;

import bean.Spot;
import bean.Tag;
import dao.SpotAdminDAO;
import tool.Action;

public class AdminSpotUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        if (!ServletFileUpload.isMultipartContent(req)) {
            req.setAttribute("error", "不正なフォーム送信です。");
            req.getRequestDispatcher("admin_spot_update.jsp").forward(req, res);
            return;
        }

        req.setCharacterEncoding("UTF-8");

        int spotId = 0;
        String spotName = null;
        String description = null;
        String district = null;
        String city = null;
        String address = null;
        String photoFileName = null;
        String oldPhoto = null;
        List<Tag> tagList = new ArrayList<>();

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(new ServletRequestContext(req));

        String uploadDirPath = req.getServletContext().getRealPath("/spotimages");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        for (FileItem item : items) {
            if (item.isFormField()) {
                String value = item.getString("UTF-8");
                switch (item.getFieldName()) {
                    case "spotId":
                        spotId = Integer.parseInt(value);
                        break;
                    case "spotName":
                        spotName = value;
                        break;
                    case "description":
                        description = value;
                        break;
                    case "district":
                        district = value;
                        break;
                    case "city":
                        city = value;
                        break;
                    case "address":
                        address = value;
                        break;
                    case "oldPhoto":
                        oldPhoto = value;
                        break;
                    case "tags":
                        if (value != null && !value.isEmpty()) {
                            Tag t = new Tag();
                            t.setTagId(Integer.parseInt(value));
                            tagList.add(t);
                        }
                        break;
                }
            } else if (item.getFieldName().equals("spotPhoto") && item.getSize() > 0) {

                String fileName = new File(item.getName()).getName();
                String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

                if (!ext.equals("jpg") && !ext.equals("jpeg")
                        && !ext.equals("png") && !ext.equals("gif")) {
                    req.setAttribute("error", "画像ファイルのみアップロード可能です。");
                    req.getRequestDispatcher("admin_spot_update.jsp").forward(req, res);
                    return;
                }

                // ===== UUIDでファイル名生成 =====
                String uuid = UUID.randomUUID().toString();
                photoFileName = uuid + "." + ext;

                File saveFile = new File(uploadDir, photoFileName);
                item.write(saveFile);

                // Eclipse プロジェクト側にもコピー
                try {
                    String localSaveDirPath =
                        "C:/pleiades/workspace/benibanabi/WebContent/spotimages";

                    File localDir = new File(localSaveDirPath);
                    if (!localDir.exists()) localDir.mkdirs();

                    File localSaveFile = new File(localDir, photoFileName);

                    java.nio.file.Files.copy(
                        saveFile.toPath(),
                        localSaveFile.toPath(),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        if (spotName == null || spotName.isEmpty()) {
            req.setAttribute("error", "観光スポット名は必須です。");
            req.getRequestDispatcher("admin_spot_update.jsp").forward(req, res);
            return;
        }

        if (city == null || city.isEmpty()) {
            req.setAttribute("error", "市町村は必須です。");
            req.getRequestDispatcher("admin_spot_update.jsp").forward(req, res);
            return;
        }

        Spot spot = new Spot();
        spot.setSpotId(spotId);
        spot.setSpotName(spotName);
        spot.setDescription(description);
        spot.setArea(city);
        spot.setAddress(address);

        if (photoFileName != null) {
            spot.setSpotPhoto("/spotimages/" + photoFileName);
        } else {
            spot.setSpotPhoto(oldPhoto); // 元の画像を維持
        }

        double[] latlng = getLatLngFromCommunityGeocoder("山形県", city, address);
        spot.setLatitude(latlng[0]);
        spot.setLongitude(latlng[1]);

        SpotAdminDAO dao = new SpotAdminDAO();
        dao.updateSpotWithTags(spot, tagList);

        req.getRequestDispatcher("admin_spot_update_done.jsp").forward(req, res);
    }

    private double[] getLatLngFromCommunityGeocoder(String prefecture, String city, String address) {

        double[] latlng = new double[]{38.2554, 140.3396};

        try {
            String fullAddr = (prefecture + " " + city + " " + address).trim();

            String urlStr =
                "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
                + "?SingleLine=" + URLEncoder.encode(fullAddr, "UTF-8")
                + "&f=pjson";

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader =
                new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            reader.close();

            JSONObject json = new JSONObject(sb.toString());
            JSONArray candidates = json.getJSONArray("candidates");

            if (candidates.length() > 0) {
                JSONObject loc =
                    candidates.getJSONObject(0).getJSONObject("location");
                latlng[0] = loc.getDouble("y");
                latlng[1] = loc.getDouble("x");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return latlng;
    }
}
