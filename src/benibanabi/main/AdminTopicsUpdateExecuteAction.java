package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminTopicsUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // フォワード
        req.getRequestDispatcher("admin_topics_update_done.jsp").forward(req, res);

    }
}
