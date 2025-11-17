package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 管理者DAO（最小限ログ）
 */
public class AdminDAO extends Dao {

    // ----------------------------
    // ログイン
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
                System.out.println("[INFO] Admin login success: id=" + adminId);
                return true;
            } else {
                System.out.println("[WARN] Admin login failed: id=" + adminId);
                return false;
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] Admin login SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // ログアウト（ログは不要）
    // ----------------------------
    public boolean logout(String adminId) throws Exception {
        updateLoginStatus(adminId, false);
        return true;
    }

    private void updateLoginStatus(String adminId, boolean loggedIn) throws Exception {
        String sql = "UPDATE ADMIN SET IS_LOGGED_IN = ?, LAST_LOGIN = CURRENT_TIMESTAMP WHERE ADMIN_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, loggedIn);
            ps.setString(2, adminId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[ERROR] updateLoginStatus SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // アカウント作成
    // ----------------------------
    public boolean createAdmin(String adminId, String password) throws Exception {
        if (existsAdmin(adminId)) {
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
                System.out.println("[INFO] Admin created: id=" + adminId);
            }
            return result;

        } catch (SQLException e) {
            System.err.println("[ERROR] createAdmin SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // パスワード変更
    // ----------------------------
    public boolean changePassword(String adminId, String newPassword) throws Exception {
        if (!existsAdmin(adminId)) {
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
                System.out.println("[INFO] Password updated: id=" + adminId);
            }
            return result;

        } catch (SQLException e) {
            System.err.println("[ERROR] changePassword SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // アカウント削除
    // ----------------------------
    public boolean deleteAdmin(String adminId) throws Exception {
        if (!existsAdmin(adminId)) {
            throw new Exception("指定した管理者IDは存在しません。");
        }

        String sql = "DELETE FROM ADMIN WHERE ADMIN_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            boolean result = ps.executeUpdate() > 0;

            if (result) {
                System.out.println("[INFO] Admin deleted: id=" + adminId);
            }
            return result;

        } catch (SQLException e) {
            System.err.println("[ERROR] deleteAdmin SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // 管理者存在チェック
    // ----------------------------
    private boolean existsAdmin(String adminId) throws Exception {
        String sql = "SELECT 1 FROM ADMIN WHERE ADMIN_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, adminId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.err.println("[ERROR] existsAdmin SQL error (id=" + adminId + "): " + e.getMessage());
            throw e;
        }
    }

    // ----------------------------
    // SHA-256
    // ----------------------------
    private String sha256(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] bytes = md.digest(input.getBytes());

        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
