package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.TagDAO;
import tool.Action;

public class AdminTagDeleteExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String[] tagIds = req.getParameterValues("tagIds");

        TagDAO dao = new TagDAO();

        if (tagIds != null) {
            for (String id : tagIds) {
                dao.deleteTag(Integer.parseInt(id));
            }
        }

        req.getRequestDispatcher("admin_tag_delete_done.jsp").forward(req, res);
    }
}
