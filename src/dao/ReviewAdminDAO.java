package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * 管理者用DAO：口コミ削除専用
 */
public class ReviewAdminDAO extends Dao {

    /**
     * 管理者が特定の口コミを削除する
     * @param reviewId 口コミID
     */
    public boolean deleteReviewById(int reviewId) throws Exception {
        System.out.println("[ReviewAdminDAO] 口コミ削除処理開始: REVIEW_ID=" + reviewId);
        String sql = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            int result = ps.executeUpdate();
            System.out.println(result > 0 ? "[ReviewAdminDAO] 🗑️ 削除成功" : "[ReviewAdminDAO] ⚠ 削除失敗");
            return result > 0;

        } catch (Exception e) {
            System.err.println("[ReviewAdminDAO] ❌ 口コミ削除処理中にエラー: " + e.getMessage());
            e.printStackTrace();
            throw e; // Action へ異常を伝達
        }
    }
}
