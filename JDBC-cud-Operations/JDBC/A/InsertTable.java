package A;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import util.DBConnection;
public class InsertTable {
	public static void main(String[] args) {
		Connection con= DBConnection.getConnection();
		try {
			Statement st=con.createStatement();
			st.execute("insert into student values(102,'Rohan')");
			System.out.println("Data Inserted");
			con.commit();
		}catch (SQLException e) {
			e.printStackTrace();
		}
	}
}