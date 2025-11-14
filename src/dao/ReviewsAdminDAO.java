package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ReviewsAdminDAO extends Dao {

    /**
     * 管理者：口コミ削除
     * @param reviewId REVIEW_ID
     * @return true：削除成功 / false：対象なし
     * @throws Exception
     */
    public boolean deleteReviewById(int reviewId) throws Exception {

        System.out.println("[INFO] ReviewAdminDAO.deleteReviewById START id=" + reviewId);

        String sql = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";

        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);   // ▼ トランザクション開始

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, reviewId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    System.out.println("[INFO] 削除成功 reviewId=" + reviewId);
                } else {
                    System.out.println("[WARN] 対象なし reviewId=" + reviewId);
                }

                conn.commit();      // ▼ コミット
                return result > 0;
            }

        } catch (Exception e) {
            System.err.println("[ERROR] 削除中に例外発生 → rollback開始");

            if (conn != null) {
                try {
                    conn.rollback();   // ▼ 正しく rollback
                } catch (Exception rbEx) {
                    System.err.println("[ERROR] rollback失敗: " + rbEx.getMessage());
                }
            }

            throw new Exception("口コミ削除中にエラーが発生しました", e);

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // 念のため autoCommit を元に戻す
                    conn.close();
                } catch (Exception ex) {
                    // close 失敗はログだけ
                }
            }
        }
    }
}
