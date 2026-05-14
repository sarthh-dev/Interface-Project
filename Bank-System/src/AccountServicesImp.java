import exception.AccountNotFoundException;
import exception.InsufficientBalanceException;
import exception.InvalidAmountException;

public class AccountServicesImp implements AccountServices{
	AccountDao a=new AccountDaoImp();

	@Override
	public void createAc() {
		// TODO Auto-generated method stub
		a.createAc();
	}

	@Override
	public void checkBalance() throws AccountNotFoundException {
		// TODO Auto-generated method stub
		a.checkBalance();
	}

	@Override
	public void withdraw() throws InsufficientBalanceException, InvalidAmountException {
		// TODO Auto-generated method stub
		a.withdraw();
	}

	@Override
	public void deposit() {
		// TODO Auto-generated method stub
		a.deposit();
	}

	@Override
	public void deleteAc() {
		// TODO Auto-generated method stub
		a.deleteAc();
	}
	
	

}
