import java.util.Scanner;

import exception.AccountNotFoundException;
import exception.InsufficientBalanceException;
import exception.InvalidAmountException;

public class Main {
	public static void main(String[] args) throws InsufficientBalanceException, InvalidAmountException, AccountNotFoundException {
     Scanner sc = new Scanner(System.in);

	AccountServices s = new AccountServicesImp();
           int choice;
           do {
        	   System.out.println();
			   System.out.println("------Sarthh  Banking System ------");
	           System.out.println("1 Create Account");
		       System.out.println("2 Deposit");
		       	System.out.println("3 Withdraw");
	           System.out.println("4 check Account");
	           System.out.println("5 Delete Account");
		       System.out.println("6 Exit");
		       System.out.println("Enter Choice");

		      choice = sc.nextInt();
		      switch(choice){
		      case 1: s.createAc();
		                    break;

		                case 2: s.deposit();
		                    break;

		                case 3:
		                    s.withdraw();
		                    break;

		                case 4: s.checkBalance();
		                    break;

		                case 5:s.deleteAc();
		                    break;

		                case 6:System.out.println("Thank you.....");
		                    break;

		                default:
		                    System.out.println("Invalid Choice");

		            }

		        } while(choice != 6);

		    }
	}


