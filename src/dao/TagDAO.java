package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import bean.Tag;

/**
 * タグ情報を取得するDAO。
 * ・スポットごとに登録されているタグを取得
 * ・全タグ一覧を取得（検索用）
 */
public class TagDAO extends Dao {

    /**
     * 指定した観光スポットに設定されているタグ一覧を取得する
     */
    public ArrayList<Tag> findTagsBySpotId(int spotId) throws Exception {

        System.out.println("[TagDAO] findTagsBySpotId() 開始 spotId=" + spotId);

        ArrayList<Tag> list = new ArrayList<>();

        String sql = "SELECT t.tag_id, t.tag_name "
                   + "FROM tags t "
                   + "JOIN spot_tags st ON t.tag_id = st.tag_id "
                   + "WHERE st.spot_id = ? "
                   + "ORDER BY t.tag_id";

        try (Connection cn = getConnection();
             PreparedStatement st = cn.prepareStatement(sql)) {

            st.setInt(1, spotId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("tag_id"));
                tag.setTagName(rs.getString("tag_name"));
                list.add(tag);
            }

            System.out.println("[TagDAO] スポットタグ取得件数: " + list.size());

        } catch (SQLException e) {
            System.err.println("[TagDAO] findTagsBySpotId() でエラー発生");
            e.printStackTrace();
            throw e;
        }

        System.out.println("[TagDAO] findTagsBySpotId() 正常終了");
        return list;
    }


    /**
     * 全タグ一覧を取得（検索プルダウン使用）
     */
    public ArrayList<Tag> findAllTags() throws Exception {

        System.out.println("[TagDAO] findAllTags() 開始");

        ArrayList<Tag> list = new ArrayList<>();

        String sql = "SELECT tag_id, tag_name FROM tags ORDER BY tag_id";

        try (Connection cn = getConnection();
             PreparedStatement st = cn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("tag_id"));
                tag.setTagName(rs.getString("tag_name"));
                list.add(tag);
            }

            System.out.println("[TagDAO] 全タグ取得件数: " + list.size());

        } catch (SQLException e) {
            System.err.println("[TagDAO] findAllTags() でエラー発生");
            e.printStackTrace();
            throw e;
        }

        System.out.println("[TagDAO] findAllTags() 正常終了");
        return list;
    }
}
