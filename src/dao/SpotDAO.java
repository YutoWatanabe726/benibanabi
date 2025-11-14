package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

import bean.Spot;

/**
 * 観光スポット情報を検索・取得するDAO
 */
public class SpotDAO extends Dao {

    /**
     * 条件に応じて観光スポット一覧を取得する
     */
    public List<Spot> searchSpots(String keyword, List<String> areaList, List<String> tagList) throws Exception {

        List<Spot> list = new ArrayList<>();

        // --- 重複排除（必要最低限の処理） ---
        if (tagList != null && !tagList.isEmpty()) {
            tagList = new ArrayList<>(new HashSet<>(tagList));
        }

        // --- SQL生成 ---
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.SPOT_ID, s.SPOT_NAME, s.AREA, s.DESCRIPTION, ");
        sql.append("s.SPOT_PHOTO, s.LATITUDE, s.LONGITUDE, s.ADDRESS ");
        sql.append("FROM SPOT s WHERE 1=1 ");

        // キーワード
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (s.SPOT_NAME LIKE ? OR s.DESCRIPTION LIKE ?) ");
        }

        // エリア
        if (areaList != null && !areaList.isEmpty()) {
            sql.append("AND s.AREA IN (");
            sql.append(String.join(",", Collections.nCopies(areaList.size(), "?")));
            sql.append(") ");
        }

        // タグ（AND 条件：EXISTS を tagList 分だけ追加）
        if (tagList != null && !tagList.isEmpty()) {
            for (int i = 0; i < tagList.size(); i++) {
                sql.append("AND EXISTS (");
                sql.append(" SELECT 1 FROM SPOT_TAG st ");
                sql.append(" JOIN TAG t ON st.TAG_ID = t.TAG_ID ");
                sql.append(" WHERE st.SPOT_ID = s.SPOT_ID AND t.TAG_NAME = ? ");
                sql.append(") ");
            }
        }

        sql.append("ORDER BY s.SPOT_NAME");

        System.out.println("[DEBUG] SpotDAO.searchSpots SQL = " + sql);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            // ▼ キーワード
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }

            // ▼ エリア
            if (areaList != null && !areaList.isEmpty()) {
                for (String area : areaList) {
                    ps.setString(idx++, area);
                }
            }

            // ▼ タグ
            if (tagList != null && !tagList.isEmpty()) {
                for (String tag : tagList) {
                    ps.setString(idx++, tag);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Spot spot = new Spot();
                spot.setSpotId(rs.getInt("SPOT_ID"));
                spot.setSpotName(rs.getString("SPOT_NAME"));
                spot.setArea(rs.getString("AREA"));
                spot.setDescription(rs.getString("DESCRIPTION"));
                spot.setSpotPhoto(rs.getString("SPOT_PHOTO"));
                spot.setLatitude(rs.getDouble("LATITUDE"));
                spot.setLongitude(rs.getDouble("LONGITUDE"));
                spot.setAddress(rs.getString("ADDRESS"));
                list.add(spot);
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] SpotDAO.searchSpots SQL失敗: " + sql);
            throw new SQLException("観光スポット検索中にエラーが発生しました。", e);
        }

        return list;
    }

    /**
     * 観光スポットIDで1件の詳細を取得
     */
    public Spot findById(int spotId) throws Exception {

        String sql =
            "SELECT SPOT_ID, SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, " +
            "LATITUDE, LONGITUDE, ADDRESS " +
            "FROM SPOT WHERE SPOT_ID = ?";

        System.out.println("[DEBUG] SpotDAO.findById SQL = " + sql + ", spotId=" + spotId);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Spot spot = new Spot();
                spot.setSpotId(rs.getInt("SPOT_ID"));
                spot.setSpotName(rs.getString("SPOT_NAME"));
                spot.setArea(rs.getString("AREA"));
                spot.setDescription(rs.getString("DESCRIPTION"));
                spot.setSpotPhoto(rs.getString("SPOT_PHOTO"));
                spot.setLatitude(rs.getDouble("LATITUDE"));
                spot.setLongitude(rs.getDouble("LONGITUDE"));
                spot.setAddress(rs.getString("ADDRESS"));
                return spot;
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] SpotDAO.findById SQL失敗 spotId=" + spotId);
            throw new SQLException("観光スポット詳細取得中にエラーが発生しました。", e);
        }

        return null;
    }
}
