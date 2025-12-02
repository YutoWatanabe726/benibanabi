package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Souvenir;
import dao.SouvenirDAO;
import tool.Action;

public class AdminSouvenirUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String idStr = req.getParameter("souvenirId");
        if (idStr == null || idStr.isEmpty()) {
            res.sendRedirect("AdminSouvenirList.action");
            return;
        }

        int souvenirId = Integer.parseInt(idStr);
        SouvenirDAO dao = new SouvenirDAO();
        Souvenir s = dao.getById(souvenirId);

        if (s == null) {
            res.sendRedirect("AdminSouvenirList.action");
            return;
        }

        // JSP で初期値表示用
        req.setAttribute("souvenir", s);
        req.getRequestDispatcher("admin_souvenir_update.jsp").forward(req, res);
    }
}
