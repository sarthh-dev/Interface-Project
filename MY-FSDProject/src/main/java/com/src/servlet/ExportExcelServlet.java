package com.src.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.src.dao.DBConnection;

@WebServlet("/ExportExcelServlet")
public class ExportExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"Transactions_Report.xls\"");
        
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT transaction_id, user_name, user_email, amount, items, payment_status, transaction_date FROM Transactions ORDER BY transaction_date DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            StringBuilder excelData = new StringBuilder();
            excelData.append("Transaction ID\tCustomer Name\tEmail\tAmount\tItems\tStatus\tDate\n");
            
            while(rs.next()) {
                excelData.append(rs.getInt("transaction_id")).append("\t");
                excelData.append(rs.getString("user_name")).append("\t");
                excelData.append(rs.getString("user_email")).append("\t");
                excelData.append(rs.getDouble("amount")).append("\t");
                excelData.append(rs.getString("items")).append("\t");
                excelData.append(rs.getString("payment_status")).append("\t");
                excelData.append(rs.getTimestamp("transaction_date")).append("\n");
            }
            
            response.getWriter().write(excelData.toString());
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error generating report: " + e.getMessage());
        }
    }
}