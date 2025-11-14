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
     */
    public List<Reviews> findBySpotId(int spotId) throws Exception {

        System.out.println("[ReviewsDAO] findBySpotId() 開始 spotId=" + spotId);

        List<Reviews> list = new ArrayList<>();

        String sql = "SELECT REVIEW_ID, SPOT_ID, REVIEW_TEXT, REVIEW_DATE "
                   + "FROM REVIEW "
                   + "WHERE SPOT_ID = ? "
                   + "ORDER BY REVIEW_DATE DESC, REVIEW_ID DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);
            System.out.println("[ReviewsDAO] SQL 実行 spotId=" + spotId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reviews rv = new Reviews();
                rv.setReviewId(rs.getInt("REVIEW_ID"));
                rv.setSpotId(rs.getInt("SPOT_ID"));
                rv.setReviewText(rs.getString("REVIEW_TEXT"));
                rv.setReviewDate(rs.getDate("REVIEW_DATE"));
                list.add(rv);
            }

            System.out.println("[ReviewsDAO] 取得件数=" + list.size());

        } catch (SQLException e) {
            System.err.println("[ReviewsDAO] findBySpotId() 例外発生");
            e.printStackTrace();
            throw new SQLException("口コミ一覧の取得中にエラーが発生しました。", e);
        }

        System.out.println("[ReviewsDAO] findBySpotId() 正常終了");
        return list;
    }


    /**
     * 口コミを1件取得
     */
    public Reviews findById(int reviewId) throws Exception {

        System.out.println("[ReviewsDAO] findById() 開始 reviewId=" + reviewId);

        String sql = "SELECT REVIEW_ID, SPOT_ID, REVIEW_TEXT, REVIEW_DATE "
                   + "FROM REVIEW WHERE REVIEW_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            System.out.println("[ReviewsDAO] SQL 実行 reviewId=" + reviewId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reviews rv = new Reviews();
                rv.setReviewId(rs.getInt("REVIEW_ID"));
                rv.setSpotId(rs.getInt("SPOT_ID"));
                rv.setReviewText(rs.getString("REVIEW_TEXT"));
                rv.setReviewDate(rs.getDate("REVIEW_DATE"));

                System.out.println("[ReviewsDAO] 対象口コミを取得");
                return rv;
            }

            System.out.println("[ReviewsDAO] 該当口コミなし");

        } catch (SQLException e) {
            System.err.println("[ReviewsDAO] findById() 例外発生");
            e.printStackTrace();
            throw new SQLException("口コミ取得中にエラーが発生しました。", e);
        }

        System.out.println("[ReviewsDAO] findById() 正常終了（null）");
        return null;
    }


    /**
     * 口コミ投稿
     */
    public boolean insertReview(Reviews review) throws Exception {

        System.out.println("[ReviewsDAO] insertReview() 開始 spotId=" + review.getSpotId());

        String sql = "INSERT INTO REVIEW (SPOT_ID, REVIEW_TEXT, REVIEW_DATE) "
                   + "VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getSpotId());
            ps.setString(2, review.getReviewText());
            ps.setDate(3, review.getReviewDate());

            System.out.println("[ReviewsDAO] SQL 実行 spotId="
                + review.getSpotId()
                + " text=" + review.getReviewText());

            int result = ps.executeUpdate();

            System.out.println("[ReviewsDAO] insertReview() 結果=" + result);

            return result > 0;

        } catch (SQLException e) {
            System.err.println("[ReviewsDAO] insertReview() 例外発生");
            e.printStackTrace();
            throw new SQLException("口コミ投稿中にエラーが発生しました。", e);
        }
    }
}
