import exception.AccountNotFoundException;
import exception.InsufficientBalanceException;
import exception.InvalidAmountException;

public interface AccountServices {
	
	void createAc();
	
	void checkBalance() throws AccountNotFoundException;
	
	void withdraw() throws InsufficientBalanceException, InvalidAmountException;
	
	void deposit();
	
	void deleteAc();
}
