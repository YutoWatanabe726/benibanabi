package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import bean.Tag;

/**
 * タグ情報を取得・管理するDAO。
 * ・スポットごとに登録されているタグを取得
 * ・全タグ一覧を取得
 * ・タグの登録
 * ・タグの削除（スポットとの紐づけも同時削除）
 */
public class TagDAO extends Dao {

    /**
     * 指定した観光スポットに設定されているタグ一覧を取得する
     */
    public ArrayList<Tag> findTagsBySpotId(int spotId) throws Exception {

        System.out.println("[TagDAO] findTagsBySpotId() 開始 spotId=" + spotId);

        ArrayList<Tag> list = new ArrayList<>();

        String sql =
              "SELECT t.tag_id, t.tag_name "
            + "FROM tag t "
            + "JOIN spot_tag st ON t.tag_id = st.tag_id "
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
     * 全タグ一覧を取得（検索プルダウン用）
     */
    public ArrayList<Tag> findAllTags() throws Exception {

        System.out.println("[TagDAO] findAllTags() 開始");

        ArrayList<Tag> list = new ArrayList<>();

        String sql = "SELECT tag_id, tag_name FROM tag ORDER BY tag_id";

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

    /**
     * タグを新規登録する
     */
    public void insertTag(Tag tag) throws Exception {

        System.out.println("[TagDAO] insertTag() 開始 tagName=" + tag.getTagName());

        String sql = "INSERT INTO tag (tag_name) VALUES (?)";

        try (Connection cn = getConnection();
             PreparedStatement st = cn.prepareStatement(sql)) {

            st.setString(1, tag.getTagName());
            st.executeUpdate();

            System.out.println("[TagDAO] タグ登録完了");

        } catch (SQLException e) {
            System.err.println("[TagDAO] insertTag() でエラー発生");
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * タグを削除する（スポットとの紐づけも同時に削除）
     */
    public void deleteTag(int tagId) throws Exception {

        System.out.println("[TagDAO] deleteTag() 開始 tagId=" + tagId);

        String deleteSpotTagSql = "DELETE FROM spot_tag WHERE tag_id = ?";
        String deleteTagSql     = "DELETE FROM tag WHERE tag_id = ?";

        try (Connection cn = getConnection()) {

            cn.setAutoCommit(false);

            try (PreparedStatement st1 = cn.prepareStatement(deleteSpotTagSql);
                 PreparedStatement st2 = cn.prepareStatement(deleteTagSql)) {

                // spot_tag を先に削除
                st1.setInt(1, tagId);
                st1.executeUpdate();

                // tag を削除
                st2.setInt(1, tagId);
                st2.executeUpdate();

                cn.commit();
                System.out.println("[TagDAO] タグ削除完了");

            } catch (SQLException e) {
                cn.rollback();
                System.err.println("[TagDAO] deleteTag() 内部処理でエラー発生");
                e.printStackTrace();
                throw e;
            }

        } catch (SQLException e) {
            System.err.println("[TagDAO] deleteTag() でエラー発生");
            e.printStackTrace();
            throw e;
        }
    }
}
