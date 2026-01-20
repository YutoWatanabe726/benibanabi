package benibanabi.main;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import bean.Tag;
import constant.PaginationConst;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

public class SpotSearchAction extends Action {

    private static final int PAGE_SIZE = PaginationConst.PAGE_SIZE;

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        /* ===============================
         * 1. ページ番号取得
         * =============================== */
        int currentPage = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && pageStr.matches("\\d+")) {
            currentPage = Integer.parseInt(pageStr);
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        /* ===============================
         * 2. パラメータ取得
         * =============================== */
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

        /* ===============================
         * 3. Cookie（お気に入り）
         * =============================== */
        List<String> favoriteIds = new ArrayList<>();
        Cookie[] cookies = req.getCookies();

        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("favoriteIds".equals(c.getName())
                        && c.getValue() != null
                        && !c.getValue().isEmpty()) {

                    String decoded = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
                    favoriteIds.addAll(Arrays.asList(decoded.split(",")));
                }
            }
        }

        /* ===============================
         * 4. 検索（全件取得）
         * =============================== */
        SpotDAO dao = new SpotDAO();
        List<Spot> allResult = dao.searchSpots(keyword, areaList, tagList);

        // お気に入りのみ
        if (isFavoriteOnly) {
            allResult.removeIf(s ->
                !favoriteIds.contains(String.valueOf(s.getSpotId()))
            );
        }

        /* ===============================
         * 5. ページング処理
         * =============================== */
        int totalCount = allResult.size();
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        int toIndex = Math.min(offset + PAGE_SIZE, totalCount);
        List<Spot> spotList = new ArrayList<>();

        if (offset < totalCount) {
            spotList = allResult.subList(offset, toIndex);
        }

        /* ===============================
         * 6. タグ一覧
         * =============================== */
        TagDAO tagDao = new TagDAO();
        ArrayList<Tag> tagAllList = tagDao.findAllTags();

        /* ===============================
         * 7. JSPへ渡す
         * =============================== */
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);

        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedAreas", areaList);
        req.setAttribute("selectedTags", tagList);
        req.setAttribute("favoriteOnly", isFavoriteOnly ? "on" : null);

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("totalCount", totalCount);  // ★ 総ヒット件数


        /* ===============================
         * 8. forward
         * =============================== */
        req.getRequestDispatcher("/benibanabi/main/spot_list.jsp")
           .forward(req, res);
    }
}
