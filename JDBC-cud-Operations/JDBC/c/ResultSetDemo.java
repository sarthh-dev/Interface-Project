package c;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import util.DBConnection;
public class ResultSetDemo {
	public static void main(String[] args) throws SQLException {
		Connection con =DBConnection.getConnection();
		 
	
		Statement ps=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		ResultSet rs=ps.executeQuery("select * from stud");
		System.out.println("student data is");
		
		while(rs.next()) {
			System.out.println(rs.getInt(1)+" "+rs.getString(2));
		}
		
		while(rs.previous()) {
			System.out.println(rs.getInt(1)+" "+rs.getString(2));
		}
		
		rs.moveToInsertRow();
		rs.updateInt(1, 103);
		
		
		
		
		
	}

}
