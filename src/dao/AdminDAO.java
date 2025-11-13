package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import bean.Spot;

/**
 * 管理者用DAO：
 * 管理者ログイン・ログアウト、
 * 観光スポットの登録・更新・削除、
 * および口コミの削除（1件単位）を行う。
 */
public class AdminDAO extends Dao {

    // =====================================================
    // 👇 管理者ログイン・ログアウト機能
    // =====================================================

    /**
     * 管理者ログイン認証
     * @param adminId 管理者ID
     * @param password パスワード
     * @return ログイン成功なら true
     */
    public boolean login(String adminId, String password) {
        String sql = "SELECT * FROM ADMIN WHERE ADMIN_ID = ? AND PASSWORD = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // ログイン状態を更新（任意）
                    updateLoginStatus(adminId, true);
                    System.out.println("✅ 管理者ログイン成功: " + adminId);
                    return true;
                } else {
                    System.out.println("❌ 管理者ログイン失敗: IDまたはパスワードが不正");
                    return false;
                }
            }

        } catch (SQLException e) {
            System.err.println("⚠ 管理者ログイン中にエラー発生: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }

    /**
     * 管理者ログアウト処理
     * @param adminId 管理者ID
     * @return ログアウト成功なら true
     */
    public boolean logout(String adminId) {
        try {
            updateLoginStatus(adminId, false);
            System.out.println("🚪 管理者ログアウト成功: " + adminId);
            return true;
        } catch (Exception e) {
            System.err.println("⚠ 管理者ログアウト中にエラー発生: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 管理者のログイン状態を更新
     * （ADMINテーブルに IS_LOGGED_IN カラムが存在する前提）
     */
    private void updateLoginStatus(String adminId, boolean loggedIn) throws SQLException {
        String sql = "UPDATE ADMIN SET IS_LOGGED_IN = ?, LAST_LOGIN = CURRENT_TIMESTAMP WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, loggedIn);
            ps.setString(2, adminId);
            ps.executeUpdate();
        } catch (Exception e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
    }

    // =====================================================
    // 👇 観光スポット関連の管理機能
    // =====================================================

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
            System.out.println(result > 0
                ? "✅ スポット登録成功: " + spot.getSpotName()
                : "⚠ スポット登録失敗: " + spot.getSpotName());
            return result > 0;

        } catch (SQLException e) {
            System.err.println("⚠ スポット登録中にエラー発生: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println(result > 0
                ? "✅ スポット更新成功 (ID: " + spot.getSpotId() + ")"
                : "⚠ スポット更新失敗 (ID: " + spot.getSpotId() + ")");
            return result > 0;

        } catch (SQLException e) {
            System.err.println("⚠ スポット更新中にエラー発生: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println(result > 0
                ? "🗑️ スポット削除成功 (ID: " + spotId + ")"
                : "⚠ スポット削除失敗 (ID: " + spotId + ")");
            return result > 0;

        } catch (SQLException e) {
            System.err.println("⚠ スポット削除中にエラー発生: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }

    // =====================================================
    // 👇 口コミ関連の管理機能
    // =====================================================

    /**
     * 管理者が特定の口コミを1件削除する
     * @param reviewId 口コミID
     * @return 削除成功なら true
     */
    public boolean deleteReviewById(int reviewId) {
        String sql = "DELETE FROM REVIEW WHERE REVIEW_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            int result = ps.executeUpdate();
            System.out.println(result > 0
                ? "🗑️ 口コミ削除成功 (REVIEW_ID: " + reviewId + ")"
                : "⚠ 口コミ削除失敗 (REVIEW_ID: " + reviewId + ")");
            return result > 0;

        } catch (SQLException e) {
            System.err.println("⚠ 口コミ削除中にエラー発生: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
		return false;
    }
}
