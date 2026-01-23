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

        TagDAO dao = new TagDAO();

        // 既存タグとの重複チェック（DAOは変更しない）
        boolean isDuplicate = false;
        for (Tag t : dao.findAllTags()) {
            if (t.getTagName().equals(tagName)) {
                isDuplicate = true;
                break;
            }
        }

        // 重複していた場合
        if (isDuplicate) {
            req.setAttribute("error", "このタグはすでに登録済みです。");
            req.setAttribute("tagName", tagName); // 入力値保持
            req.getRequestDispatcher("admin_tag_create.jsp").forward(req, res);
            return;
        }

        // タグ登録
        Tag tag = new Tag();
        tag.setTagName(tagName);
        dao.insertTag(tag);

        // 完了画面へ
        req.getRequestDispatcher("admin_tag_create_done.jsp").forward(req, res);
    }
}
