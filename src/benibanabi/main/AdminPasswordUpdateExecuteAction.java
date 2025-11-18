package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminPasswordUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        // セッションが無ければログイン画面へ
        if (admin == null) {
            res.sendRedirect("admin_login.jsp");
            return;
        }

        String currentPass = req.getParameter("currentPass");
        String newPass = req.getParameter("newPass");
        String newPass2 = req.getParameter("newPass2");
        String error = "";

        AdminDAO dao = new AdminDAO();

        // 入力チェック
        if (!newPass.equals(newPass2)) {
            error = "新しいパスワードが一致しません。";
        } else if (!dao.login(admin.getId(), currentPass)) {
            // 現在のパスワードチェック（login() の副作用あり）
            error = "現在のパスワードが違います。";
        }

        if (!error.isEmpty()) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("admin_password_update.jsp").forward(req, res);
            return;
        }

        // パスワード更新
        dao.changePassword(admin.getId(), newPass);

        // 完了画面へ
        req.getRequestDispatcher("admin_password_update_done.jsp").forward(req, res);
    }
}
