package interfacee;

public class Employee implements Printable{
	
	int id=101;
	String name="Sarthh";
	
	public String toString() {
		return id +" "+name;
		
	}
	
	public void show() {
		System.out.println(toString());
	}
	
	

}
