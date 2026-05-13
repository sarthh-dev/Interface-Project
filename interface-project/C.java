package interfacee;

public interface C {
void show();
	
	default void display() {
		System.out.println("Display from C");
	}
	
	public static void view() {
		System.out.println("View from C");
	}
	
	

}
