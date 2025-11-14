package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import bean.Spot;

/**
 * 管理者用DAO：観光スポットの登録・更新・削除
 */
public class SpotAdminDAO extends Dao {

    /** スポット新規登録 */
    public boolean insertSpot(Spot spot) throws Exception {
        System.out.println("[SpotAdminDAO] スポット登録処理開始: " + spot.getSpotName());
        String sql = "INSERT INTO SPOT (SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, LATITUDE, LONGITUDE, ADDRESS) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, spot.getSpotName());
            ps.setString(2, spot.getArea());
            ps.setString(3, spot.getDescription());
            ps.setString(4, spot.getSpotPhoto());
            ps.setDouble(5, spot.getLatitude());
            ps.setDouble(6, spot.getLongitude());
            ps.setString(7, spot.getAddress());

            int result = ps.executeUpdate();
            System.out.println(result > 0 ? "[SpotAdminDAO] ✅ 登録成功" : "[SpotAdminDAO] ⚠ 登録失敗");
            return result > 0;

        } catch (Exception e) {
            System.err.println("[SpotAdminDAO] ❌ 登録処理中にエラー: " + e.getMessage());
            e.printStackTrace();
            throw e; // Action に異常を伝える
        }
    }

    /** スポット更新 */
    public boolean updateSpot(Spot spot) throws Exception {
        System.out.println("[SpotAdminDAO] スポット更新処理開始: ID=" + spot.getSpotId());
        String sql = "UPDATE SPOT SET SPOT_NAME = ?, AREA = ?, DESCRIPTION = ?, "
                   + "SPOT_PHOTO = ?, LATITUDE = ?, LONGITUDE = ?, ADDRESS = ? "
                   + "WHERE SPOT_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, spot.getSpotName());
            ps.setString(2, spot.getArea());
            ps.setString(3, spot.getDescription());
            ps.setString(4, spot.getSpotPhoto());
            ps.setDouble(5, spot.getLatitude());
            ps.setDouble(6, spot.getLongitude());
            ps.setString(7, spot.getAddress());
            ps.setInt(8, spot.getSpotId());

            int result = ps.executeUpdate();
            System.out.println(result > 0 ? "[SpotAdminDAO] ✅ 更新成功" : "[SpotAdminDAO] ⚠ 更新失敗");
            return result > 0;

        } catch (Exception e) {
            System.err.println("[SpotAdminDAO] ❌ 更新処理中にエラー: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /** スポット削除 */
    public boolean deleteSpot(int spotId) throws Exception {
        System.out.println("[SpotAdminDAO] スポット削除処理開始: ID=" + spotId);
        String sql = "DELETE FROM SPOT WHERE SPOT_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);
            int result = ps.executeUpdate();
            System.out.println(result > 0 ? "[SpotAdminDAO] 🗑️ 削除成功" : "[SpotAdminDAO] ⚠ 削除失敗");
            return result > 0;

        } catch (Exception e) {
            System.err.println("[SpotAdminDAO] ❌ 削除処理中にエラー: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}
