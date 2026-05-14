package A;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import util.DBConnection;

public class UpdateTable {
	public static void main(String[] args) {
		Connection con= DBConnection.getConnection();
		try {
			Statement st=con.createStatement();
			st.execute("update student set sname='Sarthak' where id=101");
			System.out.println("Data updated");
			con.commit();
		}catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
}

