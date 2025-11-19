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
 * 観光スポット一覧の検索実行を行うアクション（検索ボタン押下時）
 */
public class SpotSearchAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // --- パラメータ取得 ---
        String keyword = req.getParameter("keyword");
        String selectedArea = req.getParameter("area");

        // タグ（複数選択）
        String[] tags = req.getParameterValues("tag");

        List<String> tagList = new ArrayList<>();
        if (tags != null) {
            for (String t : tags) tagList.add(t);
        }

        // エリアもリストで扱う（SpotDAO に合わせるため）
        List<String> areaList = new ArrayList<>();
        if (selectedArea != null && !selectedArea.isEmpty()) {
            areaList.add(selectedArea);
        }

        // --- DAO 呼び出し ---
        SpotDAO sDao = new SpotDAO();
        List<Spot> spotList = sDao.searchSpots(keyword, areaList, tagList);

        TagDAO tDao = new TagDAO();
        ArrayList<Tag> tagAllList = tDao.findAllTags();

        // --- JSP に渡す ---
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);

        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("selectedArea", selectedArea != null ? selectedArea : "");
        req.setAttribute("selectedTags", tagList);

        // --- フォワード ---
        req.getRequestDispatcher("spot_list.jsp").forward(req, res);
    }
}
