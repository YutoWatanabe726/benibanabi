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
     * 条件に応じて観光スポット一覧を取得する（タグ検索は OR 条件）
     */
    public List<Spot> searchSpots(String keyword, List<String> areaList, List<String> tagList) throws Exception {

        System.out.println("[INFO] SpotDAO.searchSpots: START");

        List<Spot> list = new ArrayList<>();

        // --- タグ重複排除 ---
        if (tagList != null && !tagList.isEmpty()) {
            tagList = new ArrayList<>(new HashSet<>(tagList));
        }

        // --- SQL生成 ---
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.SPOT_ID, s.SPOT_NAME, s.AREA, s.DESCRIPTION, ");
        sql.append("s.SPOT_PHOTO, s.LATITUDE, s.LONGITUDE, s.ADDRESS ");
        sql.append("FROM SPOT s WHERE 1=1 ");

        // キーワード（名前 or 説明）
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (s.SPOT_NAME LIKE ? OR s.DESCRIPTION LIKE ?) ");
        }

        // エリア OR 条件
        if (areaList != null && !areaList.isEmpty()) {
            sql.append("AND s.AREA IN (");
            sql.append(String.join(",", Collections.nCopies(areaList.size(), "?")));
            sql.append(") ");
        }

        // タグ OR 条件（修正版）
        if (tagList != null && !tagList.isEmpty()) {
            sql.append("AND s.SPOT_ID IN ( ");
            sql.append("  SELECT st.SPOT_ID FROM SPOT_TAG st ");
            sql.append("  JOIN TAG t ON st.TAG_ID = t.TAG_ID ");
            sql.append("  WHERE t.TAG_NAME IN (");
            sql.append(String.join(",", Collections.nCopies(tagList.size(), "?")));
            sql.append(") ");
            sql.append(") ");
        }

        sql.append("ORDER BY s.SPOT_NAME");

        System.out.println("[DEBUG] SQL = " + sql.toString());
        System.out.println("[DEBUG] Params: keyword=" + keyword
                + ", areaCount=" + (areaList != null ? areaList.size() : 0)
                + ", tagCount=" + (tagList != null ? tagList.size() : 0));

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            // キーワード
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }

            // エリア
            if (areaList != null && !areaList.isEmpty()) {
                for (String area : areaList) {
                    ps.setString(idx++, area);
                }
            }

            // タグ（OR 条件）
            if (tagList != null && !tagList.isEmpty()) {
                for (String tag : tagList) {
                    ps.setString(idx++, tag);
                }
            }

            ResultSet rs = ps.executeQuery();

            int count = 0;
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
                count++;
            }

            System.out.println("[INFO] SpotDAO.searchSpots: 取得件数=" + count);

        } catch (SQLException e) {
            System.err.println("[ERROR] SpotDAO.searchSpots: SQL実行エラー");
            throw new SQLException("観光スポット検索中にエラーが発生しました。", e);
        }

        System.out.println("[INFO] SpotDAO.searchSpots: END");
        return list;
    }

    /**
     * 観光スポットIDで1件取得
     */
    public Spot findById(int spotId) throws Exception {

        System.out.println("[INFO] SpotDAO.findById: START spotId=" + spotId);

        String sql =
            "SELECT SPOT_ID, SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, "
            + "LATITUDE, LONGITUDE, ADDRESS "
            + "FROM SPOT WHERE SPOT_ID = ?";

        System.out.println("[DEBUG] SQL = " + sql);

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

                System.out.println("[INFO] SpotDAO.findById: Hit spotId=" + spotId);
                System.out.println("[INFO] SpotDAO.findById: END");
                return spot;
            } else {
                System.out.println("[WARN] SpotDAO.findById: データなし spotId=" + spotId);
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] SpotDAO.findById: SQL実行エラー");
            throw new SQLException("観光スポット詳細取得中にエラーが発生しました。", e);
        }

        System.out.println("[INFO] SpotDAO.findById: END");
        return null;
    }

    /**
     * 観光スポットを全件取得
     */
    public List<Spot> findAll() throws Exception {

        System.out.println("[INFO] SpotDAO.findAll: START");

        List<Spot> list = new ArrayList<>();
        String sql =
            "SELECT SPOT_ID, SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, "
          + "LATITUDE, LONGITUDE, ADDRESS "
          + "FROM SPOT ORDER BY SPOT_NAME";

        System.out.println("[DEBUG] SQL = " + sql);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int count = 0;
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
                count++;
            }

            System.out.println("[INFO] SpotDAO.findAll: 取得件数=" + count);

        } catch (SQLException e) {
            System.err.println("[ERROR] SpotDAO.findAll: SQL実行エラー");
            throw new SQLException("観光スポット全件取得中にエラーが発生しました。", e);
        }

        System.out.println("[INFO] SpotDAO.findAll: END");
        return list;
    }

    public List<String> getAllAreas() throws Exception {
        List<String> areas = new ArrayList<>();
        String sql = "SELECT DISTINCT AREA FROM SPOT ORDER BY AREA"; // 重複削除＋ソート

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                String area = rs.getString("AREA");
                if(area != null && !area.isEmpty()) {
                    areas.add(area);
                }
            }
        }
        return areas;
    }
}
