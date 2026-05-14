import exception.AccountNotFoundException;
import exception.InsufficientBalanceException;
import exception.InvalidAmountException;

public interface AccountDao {
	
	void createAc();
	
	void checkBalance() throws AccountNotFoundException;
	
	void withdraw() throws InsufficientBalanceException, InvalidAmountException;
	
	void deposit();
	
	void deleteAc();
	

}
