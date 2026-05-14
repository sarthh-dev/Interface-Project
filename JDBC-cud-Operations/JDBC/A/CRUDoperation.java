package A;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

import util.DBConnection;
public class CRUDoperation {
	public static void main(String[] args) throws SQLException {
		
		Connection con= DBConnection.getConnection();
		Scanner sc=new Scanner(System.in);
		int s;
		do {
		System.out.println("Insert ke liye 1 dabaye");
		System.out.println("update ke liye 2 dabaye");
		System.out.println("delete ke liye 3 dabaye");
		System.out.println("fetch ke liye 4 dabaye");
	    s =sc.nextInt();
		switch(s){
		case 1:
				con.setAutoCommit(false);
				String query="insert into student values(?,?)";
				PreparedStatement stmt=con.prepareStatement(query);
				
				System.out.println("Enter Student ID:");
				int sid=sc.nextInt();
				System.out.println("Enter Student Name:");
				String sname=sc.next();
				
				stmt.setInt(1, 101);
				stmt.setString(2, sname);
				
				stmt.execute();
				
				con.commit();
				System.out.println("Data inserted....");
		
			   break;
			 
		case 2:	 
			con.setAutoCommit(false);
			String query1="update into student values(?,?)";
			PreparedStatement stmt1=con.prepareStatement(query1);
			
			System.out.println("Enter Student ID:");
			int sid1=sc.nextInt();
			System.out.println("Enter Student Name:");
			String sname1=sc.next();
			
			stmt1.setInt(1, 101);
			stmt1.setString(2, sname1);
			
			stmt1.execute();
			
			con.commit();
			System.out.println("Data updated....");
			 break;
			 
		case 3:
			con.setAutoCommit(false);
			String query2="delete from  student where id=?";
			PreparedStatement stmt2=con.prepareStatement(query2);
			
			System.out.println("Enter Student ID:");
			int sid2=sc.nextInt();
			
			stmt2.setInt(1, 101);
			stmt2.execute();
			
			con.commit();
			System.out.println("Data updated....");
			 
			break;
		case 4:
			try {
				con.setAutoCommit(false);
				String query4="select * from student where id=?";
				PreparedStatement pstmt=con.prepareStatement(query4);
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
			break;
			
		case 5:
			System.out.println("Exitttttt");
			break;
			default:
				System.out.println("Invalid");
		
		}
		}
		while(s!=5) ;
			System.out.println("Khatam tata bye bye");
		
		

}
}
