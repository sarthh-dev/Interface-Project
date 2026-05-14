package com.src.model;

public class Food {
    private int foodId;
    private String name;
    private String category;
    private String vegNonveg;
    private double price;
    
    public Food() {}
    
    public Food(String name, String category, String vegNonveg, double price) {
        this.name = name;
        this.category = category;
        this.vegNonveg = vegNonveg;
        this.price = price;
    }
    
    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getVegNonveg() { return vegNonveg; }
    public void setVegNonveg(String vegNonveg) { this.vegNonveg = vegNonveg; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}