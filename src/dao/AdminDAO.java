package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 管理者用DAO（認証専用）
 */
public class AdminDAO extends Dao {

    /**
     * 管理者ログイン認証
     * @param adminId 管理者ID
     * @param password パスワード
     * @return ログイン成功なら true
     */
    public boolean login(String adminId, String password) {
        String sql = "SELECT * FROM ADMIN WHERE ADMIN_ID = ? AND PASSWORD = ?";
        System.out.println("[AdminDAO] 管理者ログイン処理開始: adminId=" + adminId);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                updateLoginStatus(adminId, true);
                System.out.println("[AdminDAO] ✅ ログイン成功: " + adminId);
                return true;
            } else {
                System.out.println("[AdminDAO] ❌ ログイン失敗: IDまたはパスワードが不正");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("[AdminDAO] ⚠ SQLエラー: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[AdminDAO] ⚠ 予期せぬエラー: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 管理者ログアウト
     */
    public boolean logout(String adminId) throws Exception {
        System.out.println("[AdminDAO] 管理者ログアウト処理開始: adminId=" + adminId);
        updateLoginStatus(adminId, false);
        System.out.println("[AdminDAO] 🚪 ログアウト完了: " + adminId);
        return true;
    }

    /**
     * ログイン状態更新
     */
    private void updateLoginStatus(String adminId, boolean loggedIn) throws SQLException {
        String sql = "UPDATE ADMIN SET IS_LOGGED_IN = ?, LAST_LOGIN = CURRENT_TIMESTAMP WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, loggedIn);
            ps.setString(2, adminId);
            ps.executeUpdate();
            System.out.println("[AdminDAO] ログイン状態更新: adminId=" + adminId + ", loggedIn=" + loggedIn);
        } catch (Exception e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
    }
}
