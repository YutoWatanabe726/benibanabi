package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Topics;

public class TopicsDAO extends Dao {

    // ▼ 全件取得 ---------------------------------
    public List<Topics> findAll() throws Exception {

        List<Topics> list = new ArrayList<>();

        Connection con = getConnection();
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            st = con.prepareStatement(
                "SELECT TOPICS_ID, TOPICS_PUBLICATION_DATE, TOPICS_STARTDATE, TOPICS_ENDDATE, TOPICS_CONTENT, TOPICS_AREA " +
                "FROM TOPICS ORDER BY TOPICS_PUBLICATION_DATE DESC"
            );
            rs = st.executeQuery();

            while (rs.next()) {
                Topics t = new Topics();
                t.setTopicsId(rs.getInt("TOPICS_ID"));
                t.setTopicsPublicationDate(rs.getDate("TOPICS_PUBLICATION_DATE"));
                t.setTopicsStartDate(rs.getDate("TOPICS_STARTDATE"));
                t.setTopicsEndDate(rs.getDate("TOPICS_ENDDATE"));
                t.setTopicsContent(rs.getString("TOPICS_CONTENT"));
                t.setTopicsArea(rs.getString("TOPICS_AREA"));
                list.add(t);
            }

        } finally {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return list;
    }


    // ▼ 新規登録（INSERT） -------------------------
    public int insert(Topics t) throws Exception {

        Connection con = getConnection();
        PreparedStatement st = null;
        int result = 0;

        try {
            st = con.prepareStatement(
                "INSERT INTO TOPICS (TOPICS_PUBLICATION_DATE, TOPICS_STARTDATE, TOPICS_ENDDATE, TOPICS_CONTENT, TOPICS_AREA) " +
                "VALUES (?, ?, ?, ?, ?)"
            );
            st.setDate(1, t.getTopicsPublicationDate());
            st.setDate(2, t.getTopicsStartDate());
            st.setDate(3, t.getTopicsEndDate());
            st.setString(4, t.getTopicsContent());
            st.setString(5, t.getTopicsArea());

            result = st.executeUpdate();

        } finally {
            if (st != null) st.close();
            if (con != null) con.close();
        }

        return result; // 1なら成功
    }


    // ▼ 更新（UPDATE） -----------------------------
    public int update(Topics t) throws Exception {

        Connection con = getConnection();
        PreparedStatement st = null;
        int result = 0;

        try {
            st = con.prepareStatement(
                "UPDATE TOPICS SET TOPICS_PUBLICATION_DATE = ?, TOPICS_STARTDATE = ?, TOPICS_ENDDATE = ?, " +
                "TOPICS_CONTENT = ?, TOPICS_AREA = ? WHERE TOPICS_ID = ?"
            );
            st.setDate(1, t.getTopicsPublicationDate());
            st.setDate(2, t.getTopicsStartDate());
            st.setDate(3, t.getTopicsEndDate());
            st.setString(4, t.getTopicsContent());
            st.setString(5, t.getTopicsArea());
            st.setInt(6, t.getTopicsId());

            result = st.executeUpdate();

        } finally {
            if (st != null) st.close();
            if (con != null) con.close();
        }

        return result; // 1なら成功
    }
}
