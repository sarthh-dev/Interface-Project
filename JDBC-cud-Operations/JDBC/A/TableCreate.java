package A;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class TableCreate {
	public static void main(String[] args) throws SQLException {
		
		String url="jdbc:oracle:thin:@localhost:1521:xe";
		String uname="system";
		String upass="system";
		Connection con=null;
		
		try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
	    con=DriverManager.getConnection(url,uname,upass);
	    con.setAutoCommit(false);
		System.out.println("Connection to Database");
		Statement st=con.createStatement();
		st.execute("create table student(id integer primary key,sname varchar(20))");
		System.out.println("Table Created");
		con.commit();
		
		}catch(ClassNotFoundException e) {
			con.rollback();
			e.printStackTrace();
		}
	}
}
