package A;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;
import util.DBConnection;
public class FetchData {
	public static void main(String[] args) {
		Scanner sc=new Scanner(System.in);
		Connection con =DBConnection.getConnection();
		try {
			con.setAutoCommit(false);
			String query="select * from student where id=?";
			PreparedStatement pstmt=con.prepareStatement(query);
			System.out.println("Enter ID to search");
			int searchId=sc.nextInt();
			pstmt.setInt(1, searchId);
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				if(rs.getInt(1)==searchId) {
					System.out.println(rs.getInt(1)+"  "+rs.getString(2));
				}
			}
		}
				catch (SQLException e) {
					e.printStackTrace();
				}
		}
	}


