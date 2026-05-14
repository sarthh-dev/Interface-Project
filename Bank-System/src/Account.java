
public class Account {
	
	private int accNumber;
	private	String accName;
	private double balance;
	public Account(int accNumber, String accName, double balance) {
		super();
		this.accNumber = accNumber;
		this.accName = accName;
		this.balance = balance;
	}
	public Account() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getAccNumber() {
		return accNumber;
	}
	public void setAccNumber(int accNumber) {
		this.accNumber = accNumber;
	}
	public String getAccName() {
		return accName;
	}
	public void setAccName(String accName) {
		this.accName = accName;
	}
	public double getBalance() {
		return balance;
	}
	public void setBalance(double balance) {
		this.balance = balance;
	}
	@Override
	public String toString() {
		return "Account [accNumber=" + accNumber + ", accName=" + accName + ", balance=" + balance + "]";
	}
	
	

}
