package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminLoginExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String adminId = req.getParameter("id");
        String password = req.getParameter("password");
        AdminDAO adminDAO = new AdminDAO();

        boolean loginSuccess = adminDAO.login(adminId, password);

        if (loginSuccess) {
            // ログイン成功 → Admin オブジェクトをセッションにセット
            HttpSession session = req.getSession(true);
            Admin admin = new Admin();
            admin.setId(adminId);
            session.setAttribute("admin", admin);

            // メニュー画面へリダイレクト
            res.sendRedirect("admin_menu.jsp");

        } else {
            // ログイン失敗
            List<String> errors = new ArrayList<>();
            errors.add("IDまたはパスワードが確認できませんでした。");
            req.setAttribute("errors", errors);
            req.setAttribute("id", adminId);
            req.getRequestDispatcher("admin_login.jsp").forward(req, res);
        }
    }
}
