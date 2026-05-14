package com.src.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String gender;
    private String contact;
    private String password;
    
    public User() {}
    
    public User(String name, String email, String gender, String contact, String password) {
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.contact = contact;
        this.password = password;
    }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}