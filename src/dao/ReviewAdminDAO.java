package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ReviewAdminDAO extends Dao {

    /**
     * 管理者：口コミ削除
     * @param reviewId REVIEW_ID
     * @return true：削除成功 / false：対象なし
     * @throws Exception
     */
    public boolean deleteReviewById(int reviewId) throws Exception {

        System.out.println("[INFO] ReviewAdminDAO.deleteReviewById: START id = " + reviewId);

        String sql = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // ▼ トランザクション開始
            conn.setAutoCommit(false);

            ps.setInt(1, reviewId);
            int result = ps.executeUpdate();

            if (result > 0) {
                System.out.println("[INFO] ReviewAdminDAO.deleteReviewById: 削除成功 reviewId=" + reviewId);
            } else {
                System.out.println("[WARN] ReviewAdminDAO.deleteReviewById: 対象なし reviewId=" + reviewId);
            }

            // ▼ コミット
            conn.commit();
            return result > 0;

        } catch (Exception e) {
            System.err.println("[ERROR] ReviewAdminDAO.deleteReviewById: ロールバック実行 reviewId=" + reviewId);
            try {
                // rollback は必ず実行
                Connection conn = getConnection();
                conn.rollback();
            } catch (Exception rollbackEx) {
                System.err.println("[ERROR] rollback失敗: " + rollbackEx.getMessage());
            }

            // 呼び出し側で原因がわかるようにラップして再送出
            throw new Exception("口コミ削除中にエラーが発生しました", e);
        }
    }
}
