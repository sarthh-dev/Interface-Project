
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import exception.AccountNotFoundException;
import exception.InsufficientBalanceException;
import exception.InvalidAmountException;
import util.DBConnection;
public class AccountDaoImp implements AccountDao {

	@Override
	public void createAc() {
	       Scanner sc = new Scanner(System.in);
	      Connection con = DBConnection.getConnection();

	        String query = "INSERT INTO Bank VALUES(?,?,?)";

	        try {
	            PreparedStatement st = con.prepareStatement(query);

	            System.out.print("Account Number: ");
	            int accountNo = sc.nextInt();

	            System.out.print("Enter Name: ");
	            String accName = sc.next();

	            System.out.print("Deposit First money min 500 : ");
	            double balance = sc.nextDouble();

	            if (balance >= 500) {
	                st.setInt(1, accountNo);
	                st.setString(2, accName);
	                st.setDouble(3, balance);

	                st.executeUpdate();
	                con.setAutoCommit(false);
	                System.out.println(" Account Created Successfully!");
	             
	            } else {
	                System.out.println("Deposit Jyadaaa krooooooo!!!!!"
	                		+ ""
	                		+ "Try again...");
	            }
	           
	            }
	        catch (SQLException e) {
					// TODO: handle exception
	        	   e.printStackTrace();
				}

	}

	@Override
	public void checkBalance() throws AccountNotFoundException {
		Scanner sc = new Scanner(System.in);
        Connection con = DBConnection.getConnection();

        String query = "SELECT * FROM Bank WHERE accountNo=?";

        try {
            PreparedStatement p = con.prepareStatement(query);

            System.out.print("Enter Account Number: ");
            int accNo = sc.nextInt();

            p.setInt(1, accNo);
            ResultSet rs = p.executeQuery();

            if (rs.next()) {
                System.out.println("Account No: " + rs.getInt(1)+" "+"Name: " + rs.getString(2)+" "+rs.getDouble(3));
            } else {
                 throw new AccountNotFoundException("account not fount");
            }

        } catch (SQLException  e) {
        	// TODO: handle exception
            e.printStackTrace();
        }
	}


	@Override
	public void withdraw() throws InsufficientBalanceException, InvalidAmountException {
		    Connection con = DBConnection.getConnection();
		    Scanner sc = new Scanner(System.in);

		    try {
		        con.setAutoCommit(false);

		        System.out.print("Enter Account Number: ");
		        int accNo = sc.nextInt();

		        System.out.print("Enter amount to withdraw: ");
		        double amount = sc.nextDouble();
		        String sql = "SELECT balance FROM Bank WHERE accountNo=?";
		        PreparedStatement ps = con.prepareStatement(sql);
		        ps.setInt(1, accNo);
		        ResultSet rs = ps.executeQuery();
		        
		        if(amount==0) {
		        	throw new InvalidAmountException("Invalid amount you enter");
		        }

		        if (rs.next()) {
		            double balance = rs.getDouble("balance");
		            
		            if(balance==0) {
		            	throw new InsufficientBalanceException("Insufficient Balance");
		            }

		            if (balance >= amount) {
		                double newBalance = balance - amount;

		                String update = "UPDATE Bank SET balance=? WHERE accountNo=?";
		                PreparedStatement ps1 = con.prepareStatement(update);
		                ps1.setDouble(1, newBalance);
		                ps1.setInt(2, accNo);
		              
		                ResultSet rs1=ps1.executeQuery();
		                con.commit();
		                System.out.println("Withdraw successful. This is your new  Balance: " + newBalance);
		            } else {
		                System.out.println(" Not enough balance!");
		            }
		        } else {
		            System.out.println(" Account not found!");
		        }

		    } catch (SQLException   e) {
		    	// TODO Auto-generated catch block
		        e.printStackTrace();
		    }
		}
		

		public void deposit() {
		    Connection con = DBConnection.getConnection();
		    Scanner sc = new Scanner(System.in);

		    try {
		        con.setAutoCommit(false);

		        System.out.print("Enter Account Number: ");
		        int accNo = sc.nextInt();

		        System.out.print("Enter amount to deposit: ");
		        double amount = sc.nextDouble();
		        String sql = "SELECT balance FROM Bank WHERE accountNo=?";
		        PreparedStatement ps = con.prepareStatement(sql);
		        ps.setInt(1, accNo);
		        ResultSet rs = ps.executeQuery();

		        if (rs.next()) {
		            double balance = rs.getDouble("balance");
		            double newBal = balance + amount;

		            String update = "UPDATE Bank SET balance=? WHERE accountNo=?";
		            PreparedStatement psUpdate = con.prepareStatement(update);
		            psUpdate.setDouble(1, newBal);
		            psUpdate.setInt(2, accNo);
		            psUpdate.executeUpdate();

		            con.commit();
		            System.out.println("Deposit successful.... New Balance: " + newBal);
		        } else {
		            System.out.println(" Account not found!");
		        }

		    } catch (SQLException e) {
		    	// TODO Auto-generated catch block
		        e.printStackTrace();
		    }
		}
		
	

	@Override
	public void deleteAc() {
		Scanner sc = new Scanner(System.in);
        Connection con = DBConnection.getConnection();

        String query = "DELETE FROM Bank WHERE accountNo=?";

        try {
            PreparedStatement st= con.prepareStatement(query);

            System.out.print("Enter Account Number to delete: ");
            int accNo = sc.nextInt();

            st.setInt(1, accNo);
            int r = st.executeUpdate();

            if (r > 0) {
              
            	 System.out.println(" Account deleted successfully!");
            } else {
                System.out.println(" Account not found!");
            }
           

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
