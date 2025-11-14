package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Tag;

/**
 * タグ情報を扱うDAO（完全版）
 * ・指定スポットのタグ一覧取得
 * ・全タグ一覧取得（検索プルダウン用）
 */
public class TagDAO extends Dao {

    // ----------------------------------------------
    // ① 指定したスポットに紐づくタグ一覧を取得する
    // ----------------------------------------------
    /**
     * 指定したスポットに紐づくタグ一覧を取得する
     * @param spotId SPOT_ID
     * @return タグ一覧（0件の場合は空リスト）
     * @throws Exception DBエラー
     */
    public List<Tag> findTagsBySpotId(int spotId) throws Exception {

        System.out.println("[TagDAO] スポットID=" + spotId + " のタグ取得開始");

        List<Tag> tagList = new ArrayList<>();

        String sql = "SELECT t.TAG_ID, t.TAG_NAME "
                   + "FROM TAG t "
                   + "JOIN SPOT_TAG st ON t.TAG_ID = st.TAG_ID "
                   + "WHERE st.SPOT_ID = ? "
                   + "ORDER BY t.TAG_ID";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, spotId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("TAG_ID"));
                tag.setTagName(rs.getString("TAG_NAME"));
                tagList.add(tag);
            }

            System.out.println("[TagDAO] 取得件数: " + tagList.size());

        } catch (Exception e) {
            System.err.println("[TagDAO] タグ取得中エラー");
            throw new Exception("タグ情報の取得中にエラーが発生しました", e);
        }

        return tagList;
    }


    // ----------------------------------------------
    // ② 全タグ一覧を取得（検索プルダウン用）
    // ----------------------------------------------
    /**
     * 全タグ一覧を取得（検索画面のプルダウンなどで使用）
     * @return タグ一覧
     * @throws Exception
     */
    public List<Tag> findAllTags() throws Exception {

        System.out.println("[TagDAO] 全タグ一覧取得開始");

        List<Tag> tagList = new ArrayList<>();

        String sql = "SELECT TAG_ID, TAG_NAME "
                   + "FROM TAG "
                   + "ORDER BY TAG_ID";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("TAG_ID"));
                tag.setTagName(rs.getString("TAG_NAME"));
                tagList.add(tag);
            }

            System.out.println("[TagDAO] 全タグ取得数: " + tagList.size());

        } catch (Exception e) {
            System.err.println("[TagDAO] 全タグ一覧取得中にエラー");
            throw new Exception("全タグ一覧取得中にエラーが発生しました", e);
        }

        return tagList;
    }

}
