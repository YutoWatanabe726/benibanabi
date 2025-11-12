package main;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import dao.SpotDAO;

public class SpotListAction {

    /**
     * 観光スポット一覧の表示・検索処理
     * （キーワード・エリア・タグ・お気に入り対応）
     */
    public String execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== SpotListAction 開始 =====");

        // === 1. パラメータ取得 ===
        String keyword = request.getParameter("keyword");
        String[] areaParams = request.getParameterValues("area");
        String[] tagParams = request.getParameterValues("tag");
        String favFilter = request.getParameter("favoriteOnly"); // 「お気に入りのみ表示」チェック用

        System.out.println("🔧 パラメータ: keyword=" + keyword);
        System.out.println("🔧 エリア: " + Arrays.toString(areaParams));
        System.out.println("🔧 タグ: " + Arrays.toString(tagParams));
        System.out.println("🔧 お気に入り絞り込み: " + favFilter);

        // === 2. パラメータ整形 ===
        List<String> areas = new ArrayList<>();
        List<String> tags = new ArrayList<>();
        if (areaParams != null) areas = Arrays.asList(areaParams);
        if (tagParams != null) tags = Arrays.asList(tagParams);

        // === 3. Cookieからお気に入りSPOT_IDを取得 ===
        List<Integer> favoriteIds = new ArrayList<>();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("favoriteSpotIds".equals(cookie.getName())) {
                    try {
                        String[] ids = cookie.getValue().split(",");
                        for (String idStr : ids) {
                            if (!idStr.isEmpty()) favoriteIds.add(Integer.parseInt(idStr));
                        }
                        System.out.println("⭐ Cookieお気に入り一覧: " + favoriteIds);
                    } catch (NumberFormatException e) {
                        System.err.println("⚠ Cookie内のID形式エラー: " + e.getMessage());
                    }
                }
            }
        }

        // === 4. DAO呼び出し ===
        List<Spot> spotList = new ArrayList<>();
        try {
            SpotDAO dao = new SpotDAO();

            // お気に入りのみ絞り込み指定がある場合のみ、favoriteIdsを適用
            List<Integer> filterFavIds = null;
            if ("true".equals(favFilter)) {
                filterFavIds = favoriteIds;
            }

            spotList = dao.findSpots(keyword, areas, tags, filterFavIds);

        } catch (SQLException e) {
            System.err.println("⚠ SpotDAO.findSpots 実行中にエラー: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }

        // === 5. JSPへデータ渡し ===
        request.setAttribute("spotList", spotList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("areas", areas);
        request.setAttribute("tags", tags);
        request.setAttribute("favoriteIds", favoriteIds);

        System.out.println("📦 検索結果件数: " + spotList.size());
        System.out.println("===== SpotListAction 終了 =====");

        // 一覧JSPへフォワード
        return "/jsp/spotList.jsp";
    }
}
