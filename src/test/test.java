package test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class test {
    public static void main(String[] args) {
        try {
            // コンテキストから DataSource を取得
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            DataSource ds = (DataSource) envCtx.lookup("jdbc/benibanabi");

            try (Connection conn = ds.getConnection();
                 Statement stmt = conn.createStatement()) {

                String sql = "SELECT ID, NAME FROM TEST_TABLE";
                ResultSet rs = stmt.executeQuery(sql);

                System.out.println("=== TEST_TABLEの中身 ===");
                while (rs.next()) {
                    int id = rs.getInt("ID");
                    String name = rs.getString("NAME");
                    System.out.println("ID: " + id + ", NAME: " + name);
                }
            }

        } catch (NamingException | SQLException e) {
            e.printStackTrace();
        }
    }
}
