package interfacee;

public class B implements A,C{

	@Override
	public void show() {
}
	public  void display() {
		C.super.display();
		System.out.println("Display from B");
	}
	
	public static void view() {
		System.out.println("View from c");
	}
	

}
