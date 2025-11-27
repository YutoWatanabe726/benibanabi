package benibanabi.main;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import dao.ReviewsDAO;
import tool.Action;

/**
 * 口コミ投稿用Action（FrontController対応）
 */
public class ReviewsPostAction extends Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ================================
        // 1. 文字コード設定
        // ================================
        request.setCharacterEncoding("UTF-8");

        // ================================
        // 2. パラメータ取得
        // ================================
        String spotIdStr = request.getParameter("spot_id");
        String reviewText = request.getParameter("review_text");

        if (spotIdStr == null || reviewText == null || reviewText.trim().isEmpty()) {
            // パラメータ不足の場合、スポット一覧へ
            response.sendRedirect("SpotList.action");
            return;
        }

        int spotId = Integer.parseInt(spotIdStr);

        // ================================
        // 3. Reviewsオブジェクト作成
        // ================================
        Reviews review = new Reviews();
        review.setSpotId(spotId);
        review.setReviewText(reviewText.trim());
        review.setReviewDate(new Date(System.currentTimeMillis()));

        // ================================
        // 4. DB登録
        // ================================
        ReviewsDAO dao = new ReviewsDAO();
        dao.insertReview(review);

        // ================================
        // 5. 詳細ページへリダイレクト
        // ================================
        response.sendRedirect("SpotDetail.action?spot_id=" + spotId);
    }
}
