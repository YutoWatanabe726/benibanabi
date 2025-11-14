package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 管理者用DAO（認証＋アカウント管理、安全版＋ログ出力付き）
 */
public class AdminDAO extends Dao {

    // ----------------------------
    // ログイン・ログアウト
    // ----------------------------
    public boolean login(String adminId, String password) throws Exception {
        String hashedPassword = sha256(password);

        String sql = "SELECT ADMIN_ID FROM ADMIN WHERE ADMIN_ID = ? AND PASSWORD_HASH = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                updateLoginStatus(adminId, true);
                System.out.println("[AdminDAO] ✅ 管理者ログイン成功: " + adminId);
                return true;
            } else {
                System.out.println("[AdminDAO] ❌ 管理者ログイン失敗: " + adminId);
                return false;
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO] ⚠ SQLエラー: ログイン中 adminId=" + adminId);
            throw new SQLException("管理者ログイン中にエラーが発生しました。", e);
        }
    }

    public boolean logout(String adminId) throws Exception {
        updateLoginStatus(adminId, false);
        System.out.println("[AdminDAO] 🚪 管理者ログアウト完了: " + adminId);
        return true;
    }

    private void updateLoginStatus(String adminId, boolean loggedIn) throws Exception {
        String sql = "UPDATE ADMIN SET IS_LOGGED_IN = ?, LAST_LOGIN = CURRENT_TIMESTAMP WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, loggedIn);
            ps.setString(2, adminId);
            ps.executeUpdate();
            System.out.println("[AdminDAO] 📝 ログイン状態更新: " + adminId + ", IS_LOGGED_IN=" + loggedIn);
        }
    }

    // ----------------------------
    // アカウント管理
    // ----------------------------

    /**
     * 新規管理者アカウント作成（同一IDは作れない）
     */
    public boolean createAdmin(String adminId, String password) throws Exception {
        if (existsAdmin(adminId)) {
            System.out.println("[AdminDAO] ⚠ アカウント作成失敗: 既存ID=" + adminId);
            throw new Exception("指定した管理者IDはすでに存在します。");
        }

        String hashedPassword = sha256(password);
        String sql = "INSERT INTO ADMIN (ADMIN_ID, PASSWORD_HASH, IS_LOGGED_IN) VALUES (?, ?, false)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ps.setString(2, hashedPassword);
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                System.out.println("[AdminDAO] ➕ 管理者アカウント作成成功: " + adminId);
            }
            return result;
        } catch (SQLException e) {
            System.err.println("[AdminDAO] ⚠ SQLエラー: アカウント作成中 adminId=" + adminId);
            throw new SQLException("管理者アカウント作成中にエラーが発生しました。", e);
        }
    }

    /**
     * パスワード変更
     */
    public boolean changePassword(String adminId, String newPassword) throws Exception {
        if (!existsAdmin(adminId)) {
            System.out.println("[AdminDAO] ⚠ パスワード変更失敗: 不存在ID=" + adminId);
            throw new Exception("指定した管理者IDは存在しません。");
        }

        String hashedPassword = sha256(newPassword);
        String sql = "UPDATE ADMIN SET PASSWORD_HASH = ? WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setString(2, adminId);
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                System.out.println("[AdminDAO] 🔑 パスワード変更成功: " + adminId);
            }
            return result;
        } catch (SQLException e) {
            System.err.println("[AdminDAO] ⚠ SQLエラー: パスワード変更中 adminId=" + adminId);
            throw new SQLException("パスワード変更中にエラーが発生しました。", e);
        }
    }

    /**
     * 管理者アカウント削除
     */
    public boolean deleteAdmin(String adminId) throws Exception {
        if (!existsAdmin(adminId)) {
            System.out.println("[AdminDAO] ⚠ アカウント削除失敗: 不存在ID=" + adminId);
            throw new Exception("指定した管理者IDは存在しません。");
        }

        String sql = "DELETE FROM ADMIN WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                System.out.println("[AdminDAO] ❌ 管理者アカウント削除成功: " + adminId);
            }
            return result;
        } catch (SQLException e) {
            System.err.println("[AdminDAO] ⚠ SQLエラー: アカウント削除中 adminId=" + adminId);
            throw new SQLException("管理者アカウント削除中にエラーが発生しました。", e);
        }
    }

    /**
     * 指定IDの管理者が存在するか確認
     */
    private boolean existsAdmin(String adminId) throws Exception {
        String sql = "SELECT 1 FROM ADMIN WHERE ADMIN_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // ----------------------------
    // SHA-256 ハッシュ化
    // ----------------------------
    private String sha256(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(input.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
