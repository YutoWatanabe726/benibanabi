package benibanabi.main;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Tag;
import dao.TagDAO;
import tool.Action;

public class AdminSpotCreateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // TagDAO で全タグ取得
        TagDAO tagDao = new TagDAO();
        ArrayList<Tag> tagList = tagDao.findAllTags();
        req.setAttribute("tagList", tagList);

        // JSP にフォワード
        req.getRequestDispatcher("admin_spot_create.jsp").forward(req, res);
    }
}
