package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import bean.Spot;
import bean.Tag;

/**
 * 管理者用DAO：スポット＋タグ登録・更新、削除時はタグ＋口コミ＋スポットまとめて削除
 */
public class SpotAdminDAO extends Dao {

    // ----------------------------
    // スポット登録（タグあり）
    // ----------------------------
    public boolean insertSpotWithTags(Spot spot, List<Tag> tags) throws Exception {
        String insertSpotSql = "INSERT INTO SPOT (SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, LATITUDE, LONGITUDE, ADDRESS) "
                             + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertTagSql = "INSERT INTO SPOT_TAG (SPOT_ID, TAG_ID) VALUES (?, ?)";

        try (Connection conn = getConnection()) {

            System.out.println("[INFO] insertSpotWithTags: トランザクション開始");
            conn.setAutoCommit(false);
            int spotId;

            // --- スポット登録 ---
            try (PreparedStatement ps = conn.prepareStatement(insertSpotSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                System.out.println("[INFO] スポット登録開始: " + spot.getSpotName());

                ps.setString(1, spot.getSpotName());
                ps.setString(2, spot.getArea());
                ps.setString(3, spot.getDescription());
                ps.setString(4, spot.getSpotPhoto());
                ps.setDouble(5, spot.getLatitude());
                ps.setDouble(6, spot.getLongitude());
                ps.setString(7, spot.getAddress());
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    spotId = rs.getInt(1);
                    System.out.println("[INFO] スポット登録成功: SPOT_ID=" + spotId);
                } else {
                    throw new Exception("スポット登録に失敗しました。ID取得不可。");
                }
            }

            // --- タグ登録 ---
            if (tags != null && !tags.isEmpty()) {
                System.out.println("[INFO] タグ登録開始: 件数=" + tags.size());

                try (PreparedStatement psTag = conn.prepareStatement(insertTagSql)) {
                    for (Tag tag : tags) {
                        System.out.println("[INFO] タグ登録: TAG_ID=" + tag.getTagId());
                        psTag.setInt(1, spotId);
                        psTag.setInt(2, tag.getTagId());
                        psTag.addBatch();
                    }
                    psTag.executeBatch();
                }
            } else {
                System.out.println("[INFO] タグなし、タグ登録スキップ");
            }

            conn.commit();
            System.out.println("[INFO] insertSpotWithTags: トランザクション完了");
            return true;

        } catch (Exception e) {
            System.out.println("[ERROR] insertSpotWithTags: エラー → ロールバック実施");
            throw new Exception("スポット＋タグ登録中にエラーが発生しました。", e);
        }
    }

    // ----------------------------
    // スポット更新（タグ更新含む）
    // ----------------------------
    public boolean updateSpotWithTags(Spot spot, List<Tag> tags) throws Exception {
        String updateSpotSql = "UPDATE SPOT SET SPOT_NAME = ?, AREA = ?, DESCRIPTION = ?, SPOT_PHOTO = ?, LATITUDE = ?, LONGITUDE = ?, ADDRESS = ? WHERE SPOT_ID = ?";
        String deleteTagSql = "DELETE FROM SPOT_TAG WHERE SPOT_ID = ?";
        String insertTagSql = "INSERT INTO SPOT_TAG (SPOT_ID, TAG_ID) VALUES (?, ?)";

        try (Connection conn = getConnection()) {

            System.out.println("[INFO] updateSpotWithTags: トランザクション開始 SPOT_ID=" + spot.getSpotId());
            conn.setAutoCommit(false);

            // --- スポット更新 ---
            System.out.println("[INFO] スポット更新開始");

            try (PreparedStatement ps = conn.prepareStatement(updateSpotSql)) {
                ps.setString(1, spot.getSpotName());
                ps.setString(2, spot.getArea());
                ps.setString(3, spot.getDescription());
                ps.setString(4, spot.getSpotPhoto());
                ps.setDouble(5, spot.getLatitude());
                ps.setDouble(6, spot.getLongitude());
                ps.setString(7, spot.getAddress());
                ps.setInt(8, spot.getSpotId());
                ps.executeUpdate();
            }

            // --- タグ削除 ---
            System.out.println("[INFO] 既存タグ削除開始");

            try (PreparedStatement psDel = conn.prepareStatement(deleteTagSql)) {
                psDel.setInt(1, spot.getSpotId());
                psDel.executeUpdate();
            }

            // --- タグ再登録 ---
            if (tags != null && !tags.isEmpty()) {
                System.out.println("[INFO] タグ再登録開始: 件数=" + tags.size());

                try (PreparedStatement psTag = conn.prepareStatement(insertTagSql)) {
                    for (Tag tag : tags) {
                        System.out.println("[INFO] 再登録タグ: TAG_ID=" + tag.getTagId());
                        psTag.setInt(1, spot.getSpotId());
                        psTag.setInt(2, tag.getTagId());
                        psTag.addBatch();
                    }
                    psTag.executeBatch();
                }
            } else {
                System.out.println("[INFO] タグなし、タグ再登録スキップ");
            }

            conn.commit();
            System.out.println("[INFO] updateSpotWithTags: トランザクション完了");
            return true;

        } catch (Exception e) {
            System.out.println("[ERROR] updateSpotWithTags: エラー → ロールバック実施");
            throw new Exception("スポット＋タグ更新中にエラーが発生しました。", e);
        }
    }

    // ----------------------------
    // スポット削除（タグ＋口コミもまとめて削除）
    // ----------------------------
    public boolean deleteSpotWithTagsAndReviews(int spotId) throws Exception {

        String deleteTagSql = "DELETE FROM SPOT_TAG WHERE SPOT_ID = ?";
        String deleteReviewSql = "DELETE FROM REVIEW WHERE SPOT_ID = ?";
        String deleteSpotSql = "DELETE FROM SPOT WHERE SPOT_ID = ?";

        try (Connection conn = getConnection()) {

            System.out.println("[INFO] deleteSpotWithTagsAndReviews: トランザクション開始 SPOT_ID=" + spotId);
            conn.setAutoCommit(false);

            // --- タグ削除 ---
            System.out.println("[INFO] タグ削除開始");

            try (PreparedStatement psTag = conn.prepareStatement(deleteTagSql)) {
                psTag.setInt(1, spotId);
                psTag.executeUpdate();
            }

            // --- 口コミ削除 ---
            System.out.println("[INFO] 口コミ削除開始");

            try (PreparedStatement psReview = conn.prepareStatement(deleteReviewSql)) {
                psReview.setInt(1, spotId);
                psReview.executeUpdate();
            }

            // --- スポット削除 ---
            System.out.println("[INFO] スポット削除開始");

            try (PreparedStatement psSpot = conn.prepareStatement(deleteSpotSql)) {
                psSpot.setInt(1, spotId);
                psSpot.executeUpdate();
            }

            conn.commit();
            System.out.println("[INFO] deleteSpotWithTagsAndReviews: トランザクション完了");
            return true;

        } catch (Exception e) {
            System.out.println("[ERROR] deleteSpotWithTagsAndReviews: エラー → ロールバック実施");
            throw new Exception("スポット＋関連データ削除中にエラーが発生しました。", e);
        }
    }
}
