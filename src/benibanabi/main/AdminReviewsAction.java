package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import bean.Spot;
import dao.ReviewsDAO;
import dao.SpotDAO;
import tool.Action;

public class AdminReviewsAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        try {
            // ① パラメータ取得
            String spotIdStr = req.getParameter("spotId");
            if (spotIdStr == null || spotIdStr.isEmpty()) {
                req.setAttribute("error", "スポットが指定されていません。");
                req.getRequestDispatcher("admin_reviews.jsp").forward(req, res);
                return;
            }

            int spotId = Integer.parseInt(spotIdStr);

            // ② スポット情報を取得
            SpotDAO spotDao = new SpotDAO();
            Spot spot = spotDao.findById(spotId);

            if (spot == null) {
                req.setAttribute("error", "指定されたスポットは存在しません。");
                req.getRequestDispatcher("admin_reviews.jsp").forward(req, res);
                return;
            }

            // ③ レビュー一覧を取得
            ReviewsDAO reviewsDao = new ReviewsDAO();
            List<Reviews> reviewList = reviewsDao.findBySpotId(spotId);

            // JSP に渡す
            req.setAttribute("spot", spot);
            req.setAttribute("reviews", reviewList);

        } catch (Exception e) {
            req.setAttribute("error", "口コミ取得中にエラーが発生しました。");
            e.printStackTrace();
        }

        // ④ 最終的に JSP に forward
        req.getRequestDispatcher("admin_reviews.jsp").forward(req, res);
    }
}
