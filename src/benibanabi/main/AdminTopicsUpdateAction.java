package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Topics;
import dao.TopicsDAO;
import tool.Action;

public class AdminTopicsUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            req.setAttribute("error", "対象IDが指定されていません");
            req.getRequestDispatcher("admin_topics_list.jsp").forward(req, res);
            return;
        }

        int id = Integer.parseInt(idStr);
        TopicsDAO dao = new TopicsDAO();
        Topics t = dao.findAll().stream()
                        .filter(topic -> topic.getTopicsId() == id)
                        .findFirst().orElse(null);

        if (t == null) {
            req.setAttribute("error", "対象データが見つかりません");
        } else {
            req.setAttribute("topics", t);
        }

        req.getRequestDispatcher("admin_topics_update.jsp").forward(req, res);
    }
}
