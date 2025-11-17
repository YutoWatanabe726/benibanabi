package benibanabi.main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AdminDAO;

public class LoginAction extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, java.io.IOException {

        String id = req.getParameter("id");
        String password = req.getParameter("password");

        AdminDAO dao = new AdminDAO();
        boolean ok = dao.login(id, password);

        if (ok) {
            HttpSession session = req.getSession();
            session.setAttribute("id", id);

            // 管理者トップへ
            res.sendRedirect("admin_menu.jsp");
        } else {
            req.setAttribute("error", "ID またはパスワードが違います");
            RequestDispatcher rd = req.getRequestDispatcher("admin_login.jsp");
            rd.forward(req, res);
        }
    }
}
