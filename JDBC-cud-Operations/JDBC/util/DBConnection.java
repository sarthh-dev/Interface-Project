package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
		
		static String url="jdbc:oracle:thin:@localhost:1521:xe";
		static String uname="system";
		static String upass="system";
		static Connection con=null;
		
		public static Connection getConnection() {
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				con=DriverManager.getConnection(url,uname,upass);
				System.out.println("Connection to Database");
				}catch(ClassNotFoundException | SQLException e) {
					e.printStackTrace();
				}
			return con;
			
		}
}


