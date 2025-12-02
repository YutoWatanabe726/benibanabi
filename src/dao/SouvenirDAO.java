package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Souvenir;

public class SouvenirDAO extends Dao {

    // ▼ 一覧取得（全件）
    public List<Souvenir> getAll() throws Exception {
        List<Souvenir> list = new ArrayList<>();

        Connection con = getConnection();
        PreparedStatement st = con.prepareStatement(
            "SELECT * FROM SOUVENIR ORDER BY SOUVENIR_ID DESC"
        );
        ResultSet rs = st.executeQuery();

        while (rs.next()) {
            Souvenir s = new Souvenir();
            s.setSouvenirId(rs.getInt("SOUVENIR_ID"));
            s.setSouvenirSeasons(rs.getString("SOUVENIR_SEASONS"));
            s.setSouvenirName(rs.getString("SOUVENIR_NAME"));
            s.setSouvenirContent(rs.getString("SOUVENIR_CONTENT"));
            s.setSouvenirPhoto(rs.getString("SOUVENIR_PHOTO"));
            list.add(s);
        }

        rs.close();
        st.close();
        con.close();

        return list;
    }


    // ▼ 四季ごとの取得（春・夏・秋・冬）
    public List<Souvenir> getBySeason(String season) throws Exception {
        List<Souvenir> list = new ArrayList<>();

        Connection con = getConnection();
        PreparedStatement st = con.prepareStatement(
            "SELECT * FROM SOUVENIR WHERE SOUVENIR_SEASONS = ? ORDER BY SOUVENIR_ID DESC"
        );
        st.setString(1, season);

        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Souvenir s = new Souvenir();
            s.setSouvenirId(rs.getInt("SOUVENIR_ID"));
            s.setSouvenirSeasons(rs.getString("SOUVENIR_SEASONS"));
            s.setSouvenirName(rs.getString("SOUVENIR_NAME"));
            s.setSouvenirContent(rs.getString("SOUVENIR_CONTENT"));
            s.setSouvenirPhoto(rs.getString("SOUVENIR_PHOTO"));
            list.add(s);
        }

        rs.close();
        st.close();
        con.close();

        return list;
    }


    // ▼ 1件取得（更新用）
    public Souvenir getById(int souvenirId) throws Exception {
        Souvenir s = null;

        Connection con = getConnection();
        PreparedStatement st = con.prepareStatement(
            "SELECT * FROM SOUVENIR WHERE SOUVENIR_ID = ?"
        );
        st.setInt(1, souvenirId);

        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            s = new Souvenir();
            s.setSouvenirId(rs.getInt("SOUVENIR_ID"));
            s.setSouvenirSeasons(rs.getString("SOUVENIR_SEASONS"));
            s.setSouvenirName(rs.getString("SOUVENIR_NAME"));
            s.setSouvenirContent(rs.getString("SOUVENIR_CONTENT"));
            s.setSouvenirPhoto(rs.getString("SOUVENIR_PHOTO"));
        }

        rs.close();
        st.close();
        con.close();

        return s;
    }


    // ▼ 登録（INSERT）
    public int insert(Souvenir s) throws Exception {
        Connection con = getConnection();
        PreparedStatement st = con.prepareStatement(
            "INSERT INTO SOUVENIR (SOUVENIR_SEASONS, SOUVENIR_NAME, SOUVENIR_CONTENT, SOUVENIR_PHOTO) "
          + "VALUES (?, ?, ?, ?)"
        );

        st.setString(1, s.getSouvenirSeasons());
        st.setString(2, s.getSouvenirName());
        st.setString(3, s.getSouvenirContent());
        st.setString(4, s.getSouvenirPhoto());

        int rows = st.executeUpdate();

        st.close();
        con.close();

        return rows;
    }


    // ▼ 更新（UPDATE）
    public int update(Souvenir s) throws Exception {
        Connection con = getConnection();
        PreparedStatement st = con.prepareStatement(
            "UPDATE SOUVENIR SET "
          + "SOUVENIR_SEASONS = ?, "
          + "SOUVENIR_NAME = ?, "
          + "SOUVENIR_CONTENT = ?, "
          + "SOUVENIR_PHOTO = ? "
          + "WHERE SOUVENIR_ID = ?"
        );

        st.setString(1, s.getSouvenirSeasons());
        st.setString(2, s.getSouvenirName());
        st.setString(3, s.getSouvenirContent());
        st.setString(4, s.getSouvenirPhoto());
        st.setInt(5, s.getSouvenirId());

        int rows = st.executeUpdate();

        st.close();
        con.close();

        return rows;
    }
}
