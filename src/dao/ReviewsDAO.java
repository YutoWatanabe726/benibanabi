package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.Reviews;

public class ReviewsDAO extends Dao {

    /**
     * 指定スポットの口コミ一覧を取得（新しい順）
     * @param spotId SPOT_ID
     * @return 口コミ一覧
     * @throws Exception
     */
    public List<Reviews> findBySpotId(int spotId) throws Exception {

        List<Reviews> list = new ArrayList<>();

        String sql = "SELECT REVIEW_ID, SPOT_ID, REVIEW_TEXT, REVIEW_DATE "
                   + "FROM REVIEW "
                   + "WHERE SPOT_ID = ? "
                   + "ORDER BY REVIEW_DATE DESC, REVIEW_ID DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reviews rv = new Reviews();
                rv.setReviewId(rs.getInt("REVIEW_ID"));
                rv.setSpotId(rs.getInt("SPOT_ID"));
                rv.setReviewText(rs.getString("REVIEW_TEXT"));
                rv.setReviewDate(rs.getDate("REVIEW_DATE"));
                list.add(rv);
            }

        } catch (SQLException e) {
            throw new SQLException("口コミ一覧の取得中にエラーが発生しました。", e);
        }

        return list;
    }

    /**
     * 口コミを1件取得（必要に応じて）
     * @param reviewId REVIEW_ID
     * @return Reviews / null
     */
    public Reviews findById(int reviewId) throws Exception {

        String sql = "SELECT REVIEW_ID, SPOT_ID, REVIEW_TEXT, REVIEW_DATE "
                   + "FROM REVIEW WHERE REVIEW_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reviews rv = new Reviews();
                rv.setReviewId(rs.getInt("REVIEW_ID"));
                rv.setSpotId(rs.getInt("SPOT_ID"));
                rv.setReviewText(rs.getString("REVIEW_TEXT"));
                rv.setReviewDate(rs.getDate("REVIEW_DATE"));
                return rv;
            }

        } catch (SQLException e) {
            throw new SQLException("口コミ取得中にエラーが発生しました。", e);
        }

        return null;
    }

    /**
     * 口コミを投稿する
     * @param review Reviews オブジェクト
     * @return true：成功 false：失敗
     */
    public boolean insertReview(Reviews review) throws Exception {

        String sql = "INSERT INTO REVIEW (SPOT_ID, REVIEW_TEXT, REVIEW_DATE) "
                   + "VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getSpotId());
            ps.setString(2, review.getReviewText());
            ps.setDate(3, review.getReviewDate());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            throw new SQLException("口コミ投稿中にエラーが発生しました。", e);
        }
    }
}
