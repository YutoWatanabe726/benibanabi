package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import bean.Spot;

/**
 * 管理者用DAO：観光スポットの登録・更新・削除を行う
 */
public class AdminSpotDAO extends Dao {

    /**
     * 観光スポットを新規登録する
     */
    public boolean insertSpot(Spot spot) {
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
            return result > 0;

        } catch (SQLException e) {
            // System.err.println("⚠ スポット登録中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }

    /**
     * 観光スポットを更新する
     */
    public boolean updateSpot(Spot spot) {
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
            return result > 0;

        } catch (SQLException e) {
            // System.err.println("⚠ スポット更新中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }

    /**
     * 観光スポットを削除する
     */
    public boolean deleteSpot(int spotId) {
        String sql = "DELETE FROM SPOT WHERE SPOT_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);
            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            // System.err.println("⚠ スポット削除中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }
}
