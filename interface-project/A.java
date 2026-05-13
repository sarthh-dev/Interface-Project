package interfacee;

public interface A {
	void show();
	
	default void display() {
		System.out.println("Display from A");
	}
	
	public static void view() {
		System.out.println("View from A");
	}
	
	
}
