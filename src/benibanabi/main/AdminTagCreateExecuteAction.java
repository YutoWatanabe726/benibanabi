package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Tag;
import dao.TagDAO;
import tool.Action;

public class AdminTagCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // 入力値取得
        String tagName = req.getParameter("tagName");

        // Tag オブジェクト作成
        Tag tag = new Tag();
        tag.setTagName(tagName);

        // DAO で登録
        TagDAO dao = new TagDAO();
        dao.insertTag(tag);

        // 完了画面へ
        req.getRequestDispatcher("admin_tag_create_done.jsp").forward(req, res);
    }
}
