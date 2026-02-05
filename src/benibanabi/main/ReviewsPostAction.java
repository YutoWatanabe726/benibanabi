package benibanabi.main;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import dao.ReviewsDAO;
import tool.Action;

/**
 * 口コミ投稿用Action
 */
public class ReviewsPostAction extends Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ================================
        // 1. 文字コード
        // ================================
        request.setCharacterEncoding("UTF-8");

        // ================================
        // 2. パラメータ取得
        // ================================
        String spotIdStr = request.getParameter("spot_id");
        String reviewText = request.getParameter("review_text");

        if (spotIdStr == null || reviewText == null || reviewText.trim().isEmpty()) {
            response.sendRedirect("SpotList.action");
            return;
        }

        // 空白除去
        reviewText = reviewText.trim();

        // 文字数チェック
        if (reviewText.length() > 300) {
            response.sendRedirect("SpotDetail.action?spot_id=" + spotIdStr);
            return;
        }

        // spotId安全変換
        int spotId;
        try {
            spotId = Integer.parseInt(spotIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("SpotList.action");
            return;
        }

        // HTMLエスケープ
        reviewText = escapeHtml(reviewText);

        // ================================
        // 3. Bean作成
        // ================================
        Reviews review = new Reviews();
        review.setSpotId(spotId);
        review.setReviewText(reviewText);
        review.setReviewDate(new Date(System.currentTimeMillis()));

        // ================================
        // 4. DB登録
        // ================================
        ReviewsDAO dao = new ReviewsDAO();
        dao.insertReview(review);

        // ================================
        // 5. リダイレクト
        // ================================
        response.sendRedirect("SpotDetail.action?spot_id=" + spotId);
    }

    // ================================
    // HTMLエスケープ
    // ================================
    private String escapeHtml(String text) {
        if (text == null) return null;

        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
