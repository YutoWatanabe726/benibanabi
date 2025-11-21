package benibanabi.main;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import bean.Tag;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

public class SpotSearchAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // -----------------------------
        // 1. パラメータ取得
        // -----------------------------
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";

        String[] areaValues = req.getParameterValues("area");
        List<String> areaList = areaValues != null
                ? new ArrayList<>(Arrays.asList(areaValues))
                : new ArrayList<>();

        String[] tagValues = req.getParameterValues("tag");
        List<String> tagList = tagValues != null
                ? new ArrayList<>(Arrays.asList(tagValues))
                : new ArrayList<>();

        boolean isFavoriteOnly = "on".equals(req.getParameter("favoriteOnly"));

        // -----------------------------
        // 2. Cookie からお気に入りID取得
        // -----------------------------
        List<String> favoriteIds = new ArrayList<>();
        Cookie[] cookies = req.getCookies();

        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("favoriteIds".equals(c.getName())
                        && c.getValue() != null
                        && !c.getValue().isEmpty()) {

                    // ★ URLデコード（重要）
                    String decoded = java.net.URLDecoder.decode(c.getValue(), "UTF-8");

                    // カンマで分割
                    favoriteIds.addAll(Arrays.asList(decoded.split(",")));
                }
            }
        }

        // -----------------------------
        // 3. DAO による検索
        // -----------------------------
        SpotDAO dao = new SpotDAO();
        List<Spot> spotList = dao.searchSpots(keyword, areaList, tagList);

        // -----------------------------
        // 4. お気に入りのみ表示
        // -----------------------------
        if (isFavoriteOnly) {
            spotList.removeIf(s -> !favoriteIds.contains(String.valueOf(s.getSpotId())));
        }

        // -----------------------------
        // 5. タグ一覧取得
        // -----------------------------
        TagDAO tagDao = new TagDAO();
        ArrayList<Tag> tagAllList = tagDao.findAllTags();

        // -----------------------------
        // 6. JSP へ渡す
        // -----------------------------
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedAreas", areaList);
        req.setAttribute("selectedTags", tagList);
        req.setAttribute("favoriteOnly", isFavoriteOnly ? "on" : null);

        // -----------------------------
        // 7. JSP へフォワード
        // -----------------------------
        req.getRequestDispatcher("/benibanabi/main/spot_list.jsp").forward(req, res);
    }
}
