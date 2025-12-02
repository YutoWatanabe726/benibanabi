package benibanabi.main;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import bean.Souvenir;
import dao.SouvenirDAO;
import tool.Action;

public class AdminSouvenirCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        if (!ServletFileUpload.isMultipartContent(req)) {
            req.setAttribute("error", "不正なフォーム送信です。");
            req.getRequestDispatcher("admin_souvenir_create.jsp").forward(req, res);
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String name = null;
        String content = null;
        String seasons = null;
        String photoFileName = null;

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(new ServletRequestContext(req));

        String uploadDirPath = req.getServletContext().getRealPath("/souvenirimages");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        for (FileItem item : items) {
            if (item.isFormField()) {
                String value = item.getString("UTF-8");
                switch (item.getFieldName()) {
                    case "souvenirName": name = value; break;
                    case "souvenirContent": content = value; break;
                    case "souvenirSeasons": seasons = value; break;
                }
            } else if (item.getFieldName().equals("souvenirPhoto") && item.getSize() > 0) {
                String fileName = new File(item.getName()).getName();
                String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png") && !ext.equals("gif")) {
                    req.setAttribute("error", "画像ファイルのみアップロード可能です。");
                    req.getRequestDispatcher("admin_souvenir_create.jsp").forward(req, res);
                    return;
                }

                photoFileName = System.currentTimeMillis() + "_" + fileName;
                File saveFile = new File(uploadDir, photoFileName);
                item.write(saveFile);

                /* Eclipse プロジェクトにもコピー */
                try {
                    String localSaveDirPath = "C:/pleiades/workspace/benibanabi/WebContent/souvenirimages";
                    File localDir = new File(localSaveDirPath);
                    if (!localDir.exists()) localDir.mkdirs();
                    File localSaveFile = new File(localDir, photoFileName);
                    Files.copy(saveFile.toPath(), localSaveFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // 必須チェック
        if (name == null || name.isEmpty() || seasons == null || seasons.isEmpty()) {
            req.setAttribute("error", "必須項目が入力されていません。");
            req.getRequestDispatcher("admin_souvenir_create.jsp").forward(req, res);
            return;
        }

        Souvenir s = new Souvenir();
        s.setSouvenirName(name);
        s.setSouvenirContent(content);
        s.setSouvenirSeasons(seasons);
        if (photoFileName != null) s.setSouvenirPhoto("/souvenirimages/" + photoFileName);

        SouvenirDAO dao = new SouvenirDAO();
        dao.insert(s);

        req.getRequestDispatcher("admin_souvenir_create_done.jsp").forward(req, res);
    }
}
