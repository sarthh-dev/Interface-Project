package com.src.model;

public class Transaction {
    private int transactionId;
    private String userEmail;
    private String userName;
    private double amount;
    private String items;
    private String paymentStatus;
    private String orderStatus;
    private String estimatedTime;
    private String deliveryPartner;
    private String transactionDate;
    
    public Transaction() {}
    
    public Transaction(String userEmail, String userName, double amount, String items) {
        this.userEmail = userEmail;
        this.userName = userName;
        this.amount = amount;
        this.items = items;
        this.paymentStatus = "Success";
        this.orderStatus = "Processing";
    }
    
    // Getters and Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getItems() { return items; }
    public void setItems(String items) { this.items = items; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
    
    public String getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(String estimatedTime) { this.estimatedTime = estimatedTime; }
    
    public String getDeliveryPartner() { return deliveryPartner; }
    public void setDeliveryPartner(String deliveryPartner) { this.deliveryPartner = deliveryPartner; }
    
    public String getTransactionDate() { return transactionDate; }
    public void setTransactionDate(String transactionDate) { this.transactionDate = transactionDate; }
}