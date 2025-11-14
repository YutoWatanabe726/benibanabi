package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ReviewsAdminDAO extends Dao {

    /**
     * 管理者：口コミ削除
     */
    public boolean deleteReviewById(int reviewId) throws Exception {

        System.out.println("[INFO] deleteReviewById START id=" + reviewId);

        String sql = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, reviewId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    System.out.println("[INFO] deleteReviewById SUCCESS id=" + reviewId);
                } else {
                    System.out.println("[WARN] deleteReviewById NOT_FOUND id=" + reviewId);
                }

                conn.commit();
                return result > 0;
            }

        } catch (Exception e) {
            System.err.println("[ERROR] deleteReviewById FAILED → rollback id=" + reviewId);

            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignore) {}
            }

            throw new Exception("口コミ削除中にエラーが発生しました", e);

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignore) {}
            }
        }
    }
}
