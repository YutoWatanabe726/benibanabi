package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import bean.Spot;
import bean.Tag;

public class SpotAdminDAO extends Dao {

    // ----------------------------
    // スポット登録（タグあり）
    // ----------------------------
    public boolean insertSpotWithTags(Spot spot, List<Tag> tags) throws Exception {
        String insertSpotSql = "INSERT INTO SPOT (SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, LATITUDE, LONGITUDE, ADDRESS) "
                             + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertTagSql = "INSERT INTO SPOT_TAG (SPOT_ID, TAG_ID) VALUES (?, ?)";

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);
            int spotId;

            // --- スポット登録 ---
            try (PreparedStatement ps = conn.prepareStatement(insertSpotSql, PreparedStatement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, spot.getSpotName());
                ps.setString(2, spot.getArea());
                ps.setString(3, spot.getDescription());
                ps.setString(4, spot.getSpotPhoto());
                ps.setDouble(5, spot.getLatitude());
                ps.setDouble(6, spot.getLongitude());
                ps.setString(7, spot.getAddress());
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (!rs.next()) {
                    throw new Exception("スポット登録に失敗しました。ID取得不可。");
                }
                spotId = rs.getInt(1);
            }

            // --- タグ登録 ---
            if (tags != null && !tags.isEmpty()) {
                try (PreparedStatement psTag = conn.prepareStatement(insertTagSql)) {
                    for (Tag tag : tags) {
                        psTag.setInt(1, spotId);
                        psTag.setInt(2, tag.getTagId());
                        psTag.addBatch();
                    }
                    psTag.executeBatch();
                }
            }

            conn.commit();
            System.out.println("[INFO] Spot inserted: SPOT_ID=" + spotId);
            return true;

        } catch (Exception e) {
            System.err.println("[ERROR] insertSpotWithTags failed: " + e.getMessage());
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

            conn.setAutoCommit(false);

            // --- スポット更新 ---
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
            try (PreparedStatement psDel = conn.prepareStatement(deleteTagSql)) {
                psDel.setInt(1, spot.getSpotId());
                psDel.executeUpdate();
            }

            // --- タグ再登録 ---
            if (tags != null && !tags.isEmpty()) {
                try (PreparedStatement psTag = conn.prepareStatement(insertTagSql)) {
                    for (Tag tag : tags) {
                        psTag.setInt(1, spot.getSpotId());
                        psTag.setInt(2, tag.getTagId());
                        psTag.addBatch();
                    }
                    psTag.executeBatch();
                }
            }

            conn.commit();
            System.out.println("[INFO] Spot updated: SPOT_ID=" + spot.getSpotId());
            return true;

        } catch (Exception e) {
            System.err.println("[ERROR] updateSpotWithTags failed: " + e.getMessage());
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

            conn.setAutoCommit(false);

            // --- タグ削除 ---
            try (PreparedStatement psTag = conn.prepareStatement(deleteTagSql)) {
                psTag.setInt(1, spotId);
                psTag.executeUpdate();
            }

            // --- 口コミ削除 ---
            try (PreparedStatement psReview = conn.prepareStatement(deleteReviewSql)) {
                psReview.setInt(1, spotId);
                psReview.executeUpdate();
            }

            // --- スポット削除 ---
            try (PreparedStatement psSpot = conn.prepareStatement(deleteSpotSql)) {
                psSpot.setInt(1, spotId);
                psSpot.executeUpdate();
            }

            conn.commit();
            System.out.println("[INFO] Spot deleted: SPOT_ID=" + spotId);
            return true;

        } catch (Exception e) {
            System.err.println("[ERROR] deleteSpotWithTagsAndReviews failed: " + e.getMessage());
            throw new Exception("スポット＋関連データ削除中にエラーが発生しました。", e);
        }
    }
}
