package c;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import util.DBConnection;
public class BatchDemo {
	public static void main(String[] args) throws SQLException {
//		Connection con =DBConnection.getConnection();
//		Statement pstmt =con.createStatement();
//		pstmt.addBatch("insert into student values(104,'a')");
//		pstmt.addBatch("insert into student values(105,'b')");
//		pstmt.addBatch("insert into student values(106,'c')");
//		pstmt.addBatch("insert into student values(107,'d')");
//		pstmt.addBatch("insert into student values(108,'e')");
//		pstmt.executeBatch();
//		System.out.println("Batch added    ");
//		
		Connection con=DBConnection.getConnection();
		PreparedStatement pt=con.prepareStatement("insert into student values(?,?)");
		pt.setInt(1,109);
		pt.setString(2, "jann");
		pt.addBatch();
		
		pt.setInt(1, 110);
		pt.setString(2, "rooo");
        pt.addBatch();
        
        pt.executeBatch();
        System.out.println("Batch added");
		
	}

}
