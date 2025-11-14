package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Reviews;

/**
 * 管理者用DAO：口コミ一覧取得＆削除
 */
public class ReviewAdminDAO extends Dao {

    /** 口コミ一覧を取得 */
    public List<Reviews> findAllReviews() throws Exception {
        System.out.println("[ReviewAdminDAO] 口コミ一覧取得開始");

        String sql = "SELECT REVIEW_ID, SPOT_ID, REVIEW_TEXT, REVIEW_DATE FROM REVIEW ORDER BY REVIEW_DATE DESC";

        List<Reviews> list = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reviews r = new Reviews();
                r.setReviewId(rs.getInt("REVIEW_ID"));
                // r.setSpotId(rs.getInt("SPOT_ID")); ← 使うなら bean を有効化
                r.setReviewText(rs.getString("REVIEW_TEXT"));
                r.setReviewDate(rs.getDate("REVIEW_DATE"));

                list.add(r);
            }

            System.out.println("[ReviewAdminDAO] 取得件数: " + list.size());
        }

        return list;
    }

    /** 口コミ削除 */
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
            System.err.println("[ReviewAdminDAO] ❌ 削除エラー: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}
