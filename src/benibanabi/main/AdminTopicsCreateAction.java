package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminTopicsCreateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // JSP にフォワード
        req.getRequestDispatcher("admin_topics_create.jsp").forward(req, res);
    }
}
