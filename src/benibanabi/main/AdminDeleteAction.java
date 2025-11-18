package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import tool.Action;

public class AdminDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Admin currentAdmin = (Admin) session.getAttribute("admin");

        if (currentAdmin == null) {
            req.setAttribute("errorMessage", "ログインしていません。");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // 修正：Admin クラスの getter に合わせる
        req.setAttribute("admin_id", currentAdmin.getId());
        req.getRequestDispatcher("admin_delete.jsp").forward(req, res);
    }
}
