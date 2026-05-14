package A;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;
import util.DBConnection;

public class UpdateData {
	public static void main(String[] args) throws SQLException {
		Scanner sc=new Scanner(System.in);
		Connection con =DBConnection.getConnection();
		
		String query="update student set sname=? where id=?";
	  
		PreparedStatement pstmt=con.prepareStatement(query);
		System.out.println("Enter id to update");
		int id=sc.nextInt();
		System.out.println("Enter name to update");
		String uname=sc.next();
		pstmt.setString(1, uname);
		pstmt.setInt(2, id);
		pstmt.executeUpdate();
		con.commit();
		System.out.println("Data updated");
	}

}
