package benibanabi.main;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import bean.Spot;
import dao.SpotAdminDAO;
import tool.Action;

public class AdminSpotCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // multipart/form-data チェック
        if (!ServletFileUpload.isMultipartContent(req)) {
            req.setAttribute("error", "不正なフォーム送信です。");
            req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
            return;
        }

        req.setCharacterEncoding("UTF-8");

        // 入力値格納用
        String spotName = null;
        String description = null;
        String city = null;
        String spotPhoto = null;

        // ファイルアップロード準備
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        List<FileItem> items = upload.parseRequest(new ServletRequestContext(req));

        for (FileItem item : items) {

            if (item.isFormField()) {
                switch (item.getFieldName()) {
                    case "spotName":
                        spotName = item.getString("UTF-8");
                        break;
                    case "description":
                        description = item.getString("UTF-8");
                        break;
                    case "city":
                        city = item.getString("UTF-8");
                        break;
                }

            } else {
                // ファイルフォーム
                if (item.getSize() > 0) {
                    spotPhoto = System.currentTimeMillis() + "_" + item.getName();

                    String uploadPath = req.getServletContext().getRealPath("/upload_spot");
                    File dir = new File(uploadPath);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    item.write(new File(dir, spotPhoto));
                }
            }
        }

        // 必須チェック
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

        // Spot Bean にセット（area は空、city のみ登録）
        Spot spot = new Spot();
        spot.setSpotName(spotName);
        spot.setDescription(description);
        spot.setArea(city);  // 市町村名のみセット
        spot.setSpotPhoto(spotPhoto);

        // DAO 登録（タグは未指定なので null）
        SpotAdminDAO dao = new SpotAdminDAO();
        boolean result = dao.insertSpotWithTags(spot, null);

        if (!result) {
            req.setAttribute("error", "登録に失敗しました。");
            req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
            return;
        }

        // 完了画面へ
        req.getRequestDispatcher("admin_spot_create_done.jsp").forward(req, res);
    }
}
