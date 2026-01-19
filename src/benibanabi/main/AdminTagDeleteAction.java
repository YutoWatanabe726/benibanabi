package benibanabi.main;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Tag;
import dao.TagDAO;
import tool.Action;

public class AdminTagDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String[] tagIds = req.getParameterValues("tagIds");

        // 未選択対策
        if (tagIds == null || tagIds.length == 0) {
            req.setAttribute("error", "削除するタグが選択されていません。");
            req.getRequestDispatcher("AdminTagList.action").forward(req, res);
            return;
        }

        TagDAO dao = new TagDAO();
        ArrayList<Tag> tagList = new ArrayList<>();

        // ID → タグ名を取得
        for (String id : tagIds) {
            Tag tag = new Tag();
            tag.setTagId(Integer.parseInt(id));
            // ★ 全タグから一致するものを取得
            for (Tag t : dao.findAllTags()) {
                if (t.getTagId() == Integer.parseInt(id)) {
                    tag.setTagName(t.getTagName());
                    break;
                }
            }
            tagList.add(tag);
        }

        req.setAttribute("tagList", tagList);
        req.getRequestDispatcher("admin_tag_delete.jsp").forward(req, res);
    }
}
