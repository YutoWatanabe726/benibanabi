package benibanabi.main;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Tag;
import dao.TagDAO;
import tool.Action;

public class AdminTagListAction extends Action {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // タグ一覧取得
        TagDAO dao = new TagDAO();
        ArrayList<Tag> tagList = dao.findAllTags();

        // JSPへ渡す
        req.setAttribute("tagList", tagList);

        // フォワード
        req.getRequestDispatcher("admin_tag_list.jsp").forward(req, res);
    }
}
