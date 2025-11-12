package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.Reviews;
import bean.Spot;
import bean.Tag;

public class SpotDAO extends Dao {

    /**
     * 観光スポット一覧を条件付きで検索する
     * （キーワード・エリア・タグ・お気に入り(cookie)対応）
     */
    public List<Spot> findSpots(String keyword, List<String> areas, List<String> tags, List<Integer> favoriteIds) throws SQLException {
        List<Spot> spotList = new ArrayList<>();

        try (Connection conn = getConnection()) {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT DISTINCT s.SPOT_ID, s.SPOT_NAME, s.AREA, s.DESCRIPTION, ");
            sql.append("s.SPOT_PHOTO, s.LATITUDE, s.LONGITUDE, s.ADDRESS ");
            sql.append("FROM SPOT s ");
            sql.append("LEFT JOIN SPOT_TAG st ON s.SPOT_ID = st.SPOT_ID ");
            sql.append("LEFT JOIN TAG t ON st.TAG_ID = t.TAG_ID ");
            sql.append("WHERE 1=1 ");

            // 🔍 キーワード検索
            if (keyword != null && !keyword.isEmpty()) {
                sql.append("AND (s.SPOT_NAME LIKE ? OR s.DESCRIPTION LIKE ?) ");
            }

            // 🗾 エリア絞り込み
            if (areas != null && !areas.isEmpty()) {
                sql.append("AND s.AREA IN (");
                for (int i = 0; i < areas.size(); i++) {
                    sql.append("?");
                    if (i < areas.size() - 1) sql.append(", ");
                }
                sql.append(") ");
            }

            // 🏷️ タグ絞り込み
            if (tags != null && !tags.isEmpty()) {
                sql.append("AND t.TAG_NAME IN (");
                for (int i = 0; i < tags.size(); i++) {
                    sql.append("?");
                    if (i < tags.size() - 1) sql.append(", ");
                }
                sql.append(") ");
            }

            // ⭐ Cookieお気に入り（IDリスト）による絞り込み
            if (favoriteIds != null && !favoriteIds.isEmpty()) {
                sql.append("AND s.SPOT_ID IN (");
                for (int i = 0; i < favoriteIds.size(); i++) {
                    sql.append("?");
                    if (i < favoriteIds.size() - 1) sql.append(", ");
                }
                sql.append(") ");
            }

            sql.append("ORDER BY s.SPOT_NAME");

            // System.out.println("📘 実行SQL文(findSpots): " + sql);

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (areas != null && !areas.isEmpty()) {
                for (String area : areas) ps.setString(index++, area);
            }
            if (tags != null && !tags.isEmpty()) {
                for (String tag : tags) ps.setString(index++, tag);
            }
            if (favoriteIds != null && !favoriteIds.isEmpty()) {
                for (Integer favId : favoriteIds) ps.setInt(index++, favId);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Spot spot = new Spot();
                spot.setSpotId(rs.getInt("SPOT_ID"));
                spot.setSpotName(rs.getString("SPOT_NAME"));
                spot.setdescription(rs.getString("DESCRIPTION"));
                spot.setSpotPhoto(rs.getString("SPOT_PHOTO"));
                spot.setLatitude(rs.getDouble("LATITUDE"));
                spot.setLongitude(rs.getDouble("LONGITUDE"));
                spot.setAddress(rs.getString("ADDRESS"));
                spot.setArea(rs.getString("AREA"));

                spotList.add(spot);
                // System.out.println("🔧 取得データ: SPOT_ID=" + spot.getSpotId() + ", SPOT_NAME=" + spot.getSpotName());
            }

            // System.out.println("📦 取得件数: " + spotList.size());

        } catch (Exception e) {
            // System.err.println("⚠ DB接続または検索中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
        }

        return spotList;
    }

    /**
     * 観光スポット詳細をIDで取得
     */
    public Spot findById(int spotId) {
        Spot spot = null;
        try (Connection conn = getConnection()) {
            String sql = "SELECT SPOT_ID, SPOT_NAME, AREA, DESCRIPTION, SPOT_PHOTO, LATITUDE, LONGITUDE, ADDRESS "
                       + "FROM SPOT WHERE SPOT_ID = ?";
            // System.out.println("📘 実行SQL文(findById): " + sql);
            // System.out.println("🔧 設定パラメータ: spotId=" + spotId);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                spot = new Spot();
                spot.setSpotId(rs.getInt("SPOT_ID"));
                spot.setSpotName(rs.getString("SPOT_NAME"));
                spot.setArea(rs.getString("AREA"));
                spot.setdescription(rs.getString("DESCRIPTION"));
                spot.setSpotPhoto(rs.getString("SPOT_PHOTO"));
                spot.setLatitude(rs.getDouble("LATITUDE"));
                spot.setLongitude(rs.getDouble("LONGITUDE"));
                spot.setAddress(rs.getString("ADDRESS"));

                // 全カラム自動ログ出力
                /*
                System.out.println("✅ 取得スポット詳細データ:");
                ResultSetMetaData meta = rs.getMetaData();
                int columnCount = meta.getColumnCount();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = meta.getColumnName(i);
                    Object value = rs.getObject(i);
                    System.out.println("  " + columnName + " = " + value);
                }
                */
            } else {
                // System.out.println("⚠ 該当するスポットが見つかりません (spotId=" + spotId + ")");
            }

        } catch (Exception e) {
            // System.err.println("⚠ スポット詳細取得中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
        }
        return spot;
    }

    /**
     * 指定された観光スポットのタグ一覧を取得
     */
    public List<Tag> findTagsBySpotId(int spotId) {
        List<Tag> tags = new ArrayList<>();
        try (Connection conn = getConnection()) {
            String sql = "SELECT t.TAG_ID, t.TAG_NAME "
                       + "FROM TAG t "
                       + "INNER JOIN SPOT_TAG st ON t.TAG_ID = st.TAG_ID "
                       + "WHERE st.SPOT_ID = ?";
            // System.out.println("📘 実行SQL文(findTagsBySpotId): " + sql);
            // System.out.println("🔧 設定パラメータ: spotId=" + spotId);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("TAG_ID"));
                tag.setTagName(rs.getString("TAG_NAME"));
                tags.add(tag);
                // System.out.println("🏷️ 取得タグ: " + tag.getTagName());
            }

            // System.out.println("📦 取得タグ件数: " + tags.size());

        } catch (Exception e) {
            // System.err.println("⚠ タグ取得中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
        }
        return tags;
    }

    /**
     * 指定された観光スポットの口コミ一覧を取得
     */
    public List<Reviews> findReviewsBySpotId(int spotId) {
        List<Reviews> reviews = new ArrayList<>();
        try (Connection conn = getConnection()) {
            String sql = "SELECT REVIEW_ID, REVIEW_TEXT, REVIEW_DATE "
                       + "FROM REVIEW WHERE SPOT_ID = ? ORDER BY REVIEW_DATE DESC";
            // System.out.println("📘 実行SQL文(findReviewsBySpotId): " + sql);
            // System.out.println("🔧 設定パラメータ: spotId=" + spotId);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reviews review = new Reviews();
                review.setReviewId(rs.getInt("REVIEW_ID"));
                review.setReviewText(rs.getString("REVIEW_TEXT"));
                review.setReviewDate(rs.getDate("REVIEW_DATE"));
                reviews.add(review);
                // System.out.println("💬 取得口コミ: " + review.getReviewText());
            }

            // System.out.println("📦 取得口コミ件数: " + reviews.size());

        } catch (Exception e) {
            // System.err.println("⚠ 口コミ取得中にエラー発生: " + e.getMessage());
            // e.printStackTrace();
        }
        return reviews;
    }
}
