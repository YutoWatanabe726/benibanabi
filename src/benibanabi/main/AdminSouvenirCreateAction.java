package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminSouvenirCreateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // JSP にフォワード
        req.getRequestDispatcher("admin_souvenir_create.jsp").forward(req, res);
    }
}
