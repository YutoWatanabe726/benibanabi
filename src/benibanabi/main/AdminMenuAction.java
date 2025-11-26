package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import tool.Action;

public class AdminMenuAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {


        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            req.setAttribute("errorMessage", "ログインしていません。");
            req.getRequestDispatcher("admin_login.jsp").forward(req, res);
            return;
        }

        // 修正：Admin クラスの getter に合わせる
        req.setAttribute("admin_id", admin.getId());;
        // ▼ JSP へフォワード
        req.getRequestDispatcher("admin_menu.jsp").forward(req, res);
    }
}