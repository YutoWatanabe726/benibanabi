package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import bean.Spot;
import dao.ReviewsDAO;
import dao.SpotDAO;
import tool.Action;

public class ReviewsListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // ===============================
        // パラメータ取得
        // ===============================
        String sid = req.getParameter("spot_id");
        if (sid == null) {
            return;
        }
        int spotId = Integer.parseInt(sid);

        String pageParam = req.getParameter("page");
        int page = 1;
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        // ===============================
        // DAO
        // ===============================
        SpotDAO spotDao = new SpotDAO();
        Spot spot = spotDao.findById(spotId);

        ReviewsDAO reviewsDao = new ReviewsDAO();
        List<Reviews> reviewList = reviewsDao.findBySpotId(spotId);

        // ===============================
        // request セット
        // ===============================
        req.setAttribute("spot", spot);
        req.setAttribute("reviewList", reviewList);
        req.setAttribute("page", page);   // ★ これが無いのが原因

        // ===============================
        // JSP フォワード
        // ===============================
        req.getRequestDispatcher("/benibanabi/main/reviews_list.jsp")
           .forward(req, res);
    }
}
