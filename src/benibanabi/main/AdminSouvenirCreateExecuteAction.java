package benibanabi.main;

import java.io.File;
import java.nio.file.Paths;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dao.SouvenirDAO;
import tool.Action;

public class AdminSouvenirCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");

        // 画像の Part を取得
        Part part = request.getPart("image");
        String fileName = "";

        if (part != null && part.getSubmittedFileName() != null) {
            fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        }

        // 保存先フォルダ
        String dir = request.getServletContext().getRealPath("/images/souvenir");
        File folder = new File(dir);
        if (!folder.exists()) folder.mkdirs();

        // ファイル保存
        if (!fileName.isEmpty()) {
            part.write(dir + File.separator + fileName);
        }

        // DBへ登録
        SouvenirDAO dao = new SouvenirDAO();
        dao.insert(name, description, price, "/images/souvenir/" + fileName);

        // 登録後の遷移
        request.getRequestDispatcher("/benibanabi/main/souvenir.jsp")
               .forward(request, response);
    }
}
