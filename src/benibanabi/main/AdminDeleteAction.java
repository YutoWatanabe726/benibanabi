package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import tool.Action;

public class AdminDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // ▼ セッション（ログイン中管理者情報）
        HttpSession session = req.getSession();
        Admin loginAdmin = (Admin) session.getAttribute("admin");

        // ▼ リクエストパラメータ取得
        String admin_id = req.getParameter("id");
        String admin_password = req.getParameter("password");

        // ▼ JSP で表示するためにセット
        req.setAttribute("admin_id", admin_id);
        req.setAttribute("admin_password", admin_password);

        // ▼ 削除確認画面へ遷移
        req.getRequestDispatcher("admin_delete.jsp").forward(req, res);
    }
}
