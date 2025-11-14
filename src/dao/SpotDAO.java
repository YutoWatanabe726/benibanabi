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
 * スポット情報を検索・取得するDAO
 */
public class SpotDAO extends Dao {

    /**
     * 条件に応じて観光スポット一覧を取得する
     * @param keyword キーワード（スポット名・説明文に部分一致）
     * @param areaList エリア（複数可）
     * @param tagList タグ（複数可）
     * @return 条件に合致したスポットのリスト
     * @throws Exception DBエラー時
     */
    public List<Spot> searchSpots(String keyword, List<String> areaList, List<String> tagList) throws Exception {

        List<Spot> list = new ArrayList<>();

        // --- ベースSQL ---
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.SPOT_ID, s.SPOT_NAME, s.AREA, s.DESCRIPTION, ");
        sql.append("s.SPOT_PHOTO, s.LATITUDE, s.LONGITUDE, s.ADDRESS ");
        sql.append("FROM SPOT s WHERE 1=1 ");

        // --- キーワード検索 ---
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (s.SPOT_NAME LIKE ? OR s.DESCRIPTION LIKE ?) ");
        }

        // --- エリア検索 ---
        if (areaList != null && !areaList.isEmpty()) {
            sql.append("AND s.AREA IN (");
            sql.append(String.join(",", Collections.nCopies(areaList.size(), "?")));
            sql.append(") ");
        }

        // --- タグ検索（AND条件） ---
        if (tagList != null && !tagList.isEmpty()) {
            // 重複除去
            tagList = new ArrayList<>(new HashSet<>(tagList));
            for (int i = 0; i < tagList.size(); i++) {
                sql.append("AND EXISTS (");
                sql.append("SELECT 1 FROM SPOT_TAG st ");
                sql.append("JOIN TAG t ON st.TAG_ID = t.TAG_ID ");
                sql.append("WHERE st.SPOT_ID = s.SPOT_ID AND t.TAG_NAME = ? ) ");
            }
        }

        // --- 並び順 ---
        sql.append("ORDER BY s.SPOT_NAME");

        // --- DB接続 ---
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            // --- パラメータ設定 ---
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
                ps.setString(idx++, "%" + keyword + "%");
            }

            if (areaList != null && !areaList.isEmpty()) {
                for (String area : areaList) {
                    ps.setString(idx++, area);
                }
            }

            if (tagList != null && !tagList.isEmpty()) {
                for (String tag : tagList) {
                    ps.setString(idx++, tag);
                }
            }

            // --- SQL実行 ---
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
            throw new SQLException("観光スポット検索中にエラーが発生しました", e);
        }

        return list;
    }
}
