package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import bean.Tag;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

public class AdminSpotUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // リクエストパラメータから更新対象のスポットIDを取得
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            req.setAttribute("error", "スポットIDが指定されていません。");
            req.getRequestDispatcher("admin_spot_list.jsp").forward(req, res);
            return;
        }
        int spotId = Integer.parseInt(idStr);

        // スポット情報取得
        SpotDAO spotDao = new SpotDAO();
        Spot spot = spotDao.findById(spotId);
        if (spot == null) {
            req.setAttribute("error", "指定されたスポットは存在しません。");
            req.getRequestDispatcher("admin_spot_list.jsp").forward(req, res);
            return;
        }

        // 全タグ取得
        TagDAO tagDao = new TagDAO();
        ArrayList<Tag> tagList = tagDao.findAllTags();

        // 対象スポットのタグID取得
        ArrayList<Tag> spotTags = tagDao.findTagsBySpotId(spotId);
        List<Integer> spotTagIds = new ArrayList<>();
        for (Tag t : spotTags) spotTagIds.add(t.getTagId());

        // JSP にセット
        req.setAttribute("spot", spot);
        req.setAttribute("tagList", tagList);
        req.setAttribute("spotTagIds", spotTagIds);

        // フォワード
        req.getRequestDispatcher("admin_spot_update.jsp").forward(req, res);
    }
}
