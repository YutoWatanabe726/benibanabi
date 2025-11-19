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

/**
 * 観光スポット一覧表示（初期表示・検索用共通）
 */
public class SpotListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // 1. 文字コード設定
        req.setCharacterEncoding("UTF-8");

        // 2. 検索条件取得（検索フォームから渡される場合）
        String keyword = req.getParameter("keyword");
        String selectedArea = req.getParameter("area");
        String[] tags = req.getParameterValues("tag");

        List<String> tagList = new ArrayList<>();
        if (tags != null) {
            for (String t : tags) {
                tagList.add(t);
            }
        }

        List<String> areaList = new ArrayList<>();
        if (selectedArea != null && !selectedArea.isEmpty()) {
            areaList.add(selectedArea);
        }

        // 3. DAO呼び出し
        SpotDAO sDao = new SpotDAO();
        List<Spot> spotList;

        // もし検索条件が何も指定されていなければ、全件取得
        if ((keyword == null || keyword.isEmpty()) && areaList.isEmpty() && tagList.isEmpty()) {
            spotList = sDao.findAll();
        } else {
            spotList = sDao.searchSpots(keyword, areaList, tagList);
        }

        // 4. タグ一覧取得（全件）
        TagDAO tDao = new TagDAO();
        ArrayList<Tag> tagAllList = tDao.findAllTags();

        // 5. リクエストスコープにセット
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);
        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("selectedArea", selectedArea != null ? selectedArea : "");
        req.setAttribute("selectedTags", tagList);

        // 6. JSPへフォワード
        req.getRequestDispatcher("spot_list.jsp").forward(req, res);
    }
}
