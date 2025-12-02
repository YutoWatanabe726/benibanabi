package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class SouvenirDAO {

    public void insert(String name, String description, String price, String image) {

        String sql = "INSERT INTO SOUVENIR(name, description, price, image) VALUES (?, ?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setString(3, price);
            ps.setString(4, image);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
