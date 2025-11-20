package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import dao.SpotDAO;
import tool.Action;

public class AdminReviewsSpotListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String keyword = req.getParameter("keyword");  // ← ★検索ワード取得

        SpotDAO dao = new SpotDAO();
        List<Spot> list;

        if (keyword != null && !keyword.isEmpty()) {
            // キーワード検索
            list = dao.searchSpots(keyword, null, null);
        } else {
            // 全件取得
            list = dao.searchSpots(null, null, null);
        }

        req.setAttribute("spotList", list);

        req.getRequestDispatcher("admin_reviews_spot_list.jsp").forward(req, res);
    }
}




