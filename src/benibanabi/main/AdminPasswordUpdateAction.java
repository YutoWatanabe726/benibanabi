package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import tool.Action;

public class AdminPasswordUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // ▼ セッション（ログイン中管理者）
        HttpSession session = req.getSession();
        Admin admin = (Admin)session.getAttribute("user");


        // 特にパラメータはなし

        // ▼ JSP へフォワード
        req.getRequestDispatcher("admin_password_update.jsp").forward(req, res);
    }
}
