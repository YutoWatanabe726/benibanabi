package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ReviewsAdminDAO;
import tool.Action;

public class AdminDeleteReviewAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        int reviewId = Integer.parseInt(req.getParameter("reviewId"));
        int spotId = Integer.parseInt(req.getParameter("spotId"));

        ReviewsAdminDAO dao = new ReviewsAdminDAO();
        dao.deleteReviewById(reviewId);

        // 削除後、再び一覧へ
        res.sendRedirect(req.getContextPath() + "/benibanabi/main/AdminReviews.action?spotId=" + spotId);
    }
}
