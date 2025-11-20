package benibanabi.main;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;
import org.json.JSONArray;
import org.json.JSONObject;

import bean.Spot;
import bean.Tag;
import dao.SpotAdminDAO;
import tool.Action;

public class AdminSpotCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        if (!ServletFileUpload.isMultipartContent(req)) {
            req.setAttribute("error", "不正なフォーム送信です。");
            req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String spotName = null;
        String description = null;
        String district = null;
        String city = null;
        String address = null;
        String photoFileName = null;
        List<Tag> tagList = new ArrayList<>();

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(new ServletRequestContext(req));

        String uploadDir = req.getServletContext().getRealPath("/upload/spot_img");
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        for (FileItem item : items) {
            if (item.isFormField()) {
                String value = item.getString("UTF-8");
                switch (item.getFieldName()) {
                    case "spotName": spotName = value; break;
                    case "description": description = value; break;
                    case "district": district = value; break;
                    case "city": city = value; break;
                    case "address": address = value; break;
                    case "tags":
                        if (value != null && !value.isEmpty()) {
                            Tag t = new Tag();
                            t.setTagId(Integer.parseInt(value));
                            tagList.add(t);
                        }
                        break;
                }
            } else {
                if (item.getSize() > 0) {
                    photoFileName = System.currentTimeMillis() + "_" + new File(item.getName()).getName();
                    item.write(new File(uploadFolder, photoFileName));
                }
            }
        }

        // バリデーション
        if (spotName == null || spotName.isEmpty()) {
            req.setAttribute("error", "観光スポット名は必須です。");
            req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
            return;
        }

        if (city == null || city.isEmpty()) {
            req.setAttribute("error", "市町村は必須です。");
            req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
            return;
        }

        Spot spot = new Spot();
        spot.setSpotName(spotName);
        spot.setDescription(description);
        spot.setArea(city);
        spot.setAddress(address);

        // -----------------------------
        // Community Geocoder で緯度経度を取得
        // -----------------------------
        double[] latlng = getLatLngFromCommunityGeocoder("山形県", city, address);
        spot.setLatitude(latlng[0]);
        spot.setLongitude(latlng[1]);

        if (photoFileName != null) {
            spot.setSpotPhoto("/benibanabi/images/" + photoFileName);
        }

        SpotAdminDAO dao = new SpotAdminDAO();
        dao.insertSpotWithTags(spot, tagList);

        req.getRequestDispatcher("admin_spot_create_done.jsp").forward(req, res);
    }

    // -----------------------------
    // Community Geocoder で住所から緯度経度を取得
    // -----------------------------
    private double[] getLatLngFromCommunityGeocoder(String prefecture, String city, String address) {
        double[] latlng = new double[]{38.2554, 140.3396}; // デフォルト：山形駅
        try {
            StringBuilder fullAddress = new StringBuilder();
            if (prefecture != null && !prefecture.trim().isEmpty()) fullAddress.append(prefecture.trim()).append(" ");
            if (city != null && !city.trim().isEmpty()) fullAddress.append(city.trim()).append(" ");
            if (address != null && !address.trim().isEmpty()) fullAddress.append(address.trim());

            String encodedAddress = URLEncoder.encode(fullAddress.toString(), "UTF-8");
            String urlStr = "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
                          + "?SingleLine=" + encodedAddress
                          + "&f=pjson";

            System.out.println("debug: Community Geocoder URL > " + urlStr);

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            reader.close();

            JSONObject json = new JSONObject(sb.toString());
            JSONArray candidates = json.getJSONArray("candidates");
            if (candidates.length() > 0) {
                JSONObject location = candidates.getJSONObject(0).getJSONObject("location");
                latlng[0] = location.getDouble("y"); // 緯度
                latlng[1] = location.getDouble("x"); // 経度
            } else {
                System.out.println("debug: 住所から緯度経度が取得できませんでした。");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("debug: 緯度=" + latlng[0] + ", 経度=" + latlng[1]);
        return latlng;
    }
}
