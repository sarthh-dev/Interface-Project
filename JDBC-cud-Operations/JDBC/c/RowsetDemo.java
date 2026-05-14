package c;

import java.sql.SQLException;

import javax.sql.rowset.JdbcRowSet;
import javax.sql.rowset.RowSetProvider;

public class RowsetDemo {
	public static void main(String[] args) throws SQLException {
		JdbcRowSet j= RowSetProvider.newFactory().createJdbcRowSet();
		j.setUrl("jdbc:oracle:thin:@localhost:1521:xe");
	    j.setUsername("system");
	    j.setPassword("system");
	    
	    System.out.println("connected");
	    
	    j.setCommand("insert into stud values(1,'oooohooo')");
	    j.execute();
	    System.out.println("inserted");

	}

}
