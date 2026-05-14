package A;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import util.DBConnection;

public class DeleteTable {
	public static void main(String[] args) {
		Connection con= DBConnection.getConnection();
		try {
			Statement st=con.createStatement();
			st.execute("delete  from student   where id=104");
			System.out.println("Data Deleted");
			con.commit();
		}catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

}
