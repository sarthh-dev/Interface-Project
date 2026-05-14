package com.src.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import com.src.model.Transaction;

public class TransactionDAO {
    
    // Get all transactions for admin
    public List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String query = "SELECT transaction_id, user_email, user_name, amount, items, payment_status, order_status, transaction_date FROM Transactions ORDER BY transaction_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transaction_id"));
                transaction.setUserEmail(rs.getString("user_email"));
                transaction.setUserName(rs.getString("user_name"));
                transaction.setAmount(rs.getDouble("amount"));
                transaction.setItems(rs.getString("items"));
                transaction.setPaymentStatus(rs.getString("payment_status"));
                transaction.setOrderStatus(rs.getString("order_status"));
                transaction.setTransactionDate(rs.getString("transaction_date"));
                transactions.add(transaction);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    // Get user specific transactions
    public List<Transaction> getUserTransactions(String userEmail) {
        List<Transaction> transactions = new ArrayList<>();
        String query = "SELECT transaction_id, user_email, user_name, amount, items, payment_status, order_status, transaction_date FROM Transactions WHERE user_email = ? ORDER BY transaction_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, userEmail);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transaction_id"));
                transaction.setUserEmail(rs.getString("user_email"));
                transaction.setUserName(rs.getString("user_name"));
                transaction.setAmount(rs.getDouble("amount"));
                transaction.setItems(rs.getString("items"));
                transaction.setPaymentStatus(rs.getString("payment_status"));
                transaction.setOrderStatus(rs.getString("order_status"));
                transaction.setTransactionDate(rs.getString("transaction_date"));
                transactions.add(transaction);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return transactions;
    }
}