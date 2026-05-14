package com.src.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.src.dao.DBConnection;

@WebServlet("/ExportPDFServlet")
public class ExportPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("type");
        String period = request.getParameter("period");
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Analytics_Report_" + reportType + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".pdf\"");
        
        try {
            Document document = new Document(PageSize.A4.rotate());
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();
            
            // Title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD);
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
            
            Paragraph title = new Paragraph("SRC Fast Food - " + getReportTitle(reportType, period), titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            
            document.add(new Paragraph(" "));
            
            Paragraph datePara = new Paragraph("Generated on: " + new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date()), normalFont);
            datePara.setAlignment(Element.ALIGN_CENTER);
            document.add(datePara);
            
            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));
            
            if("transactions".equals(reportType)) {
                generateTransactionReport(document, period, headerFont, normalFont);
            } else if("bestSelling".equals(reportType)) {
                generateBestSellingReport(document, period, headerFont, normalFont);
            } else if("customerSpending".equals(reportType)) {
                generateCustomerReport(document, period, headerFont, normalFont);
            } else if("summary".equals(reportType)) {
                generateSummaryReport(document, period, headerFont, normalFont);
            }
            
            // Footer
            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));
            Paragraph footer = new Paragraph("Thank you for choosing SRC Fast Food!", new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC));
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            out.flush();
            out.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error generating PDF: " + e.getMessage());
        }
    }
    
    private String getReportTitle(String type, String period) {
        String periodText = "";
        if("weekly".equals(period)) periodText = " (Last 7 Days)";
        else if("monthly".equals(period)) periodText = " (Last 30 Days)";
        else if("yearly".equals(period)) periodText = " (Last 365 Days)";
        
        if("transactions".equals(type)) return "Transaction Report" + periodText;
        if("bestSelling".equals(type)) return "Best Selling Items Report" + periodText;
        if("customerSpending".equals(type)) return "Customer Spending Report" + periodText;
        return "Analytics Summary Report" + periodText;
    }
    
    private void generateTransactionReport(Document document, String period, Font headerFont, Font normalFont) throws Exception {
        String dateCondition = getDateCondition(period);
        String query = "SELECT transaction_id, user_name, user_email, amount, items, payment_status, order_status, transaction_date " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "ORDER BY transaction_date DESC";
        
        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        String[] headers = {"Order ID", "Customer", "Email", "Items", "Amount", "Status", "Date"};
        for(String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(228, 0, 43));
            cell.setBorderColor(new com.itextpdf.text.BaseColor(255, 255, 255));
            table.addCell(cell);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
            
            while (rs.next()) {
                table.addCell(new Phrase("#" + rs.getInt("transaction_id"), normalFont));
                table.addCell(new Phrase(rs.getString("user_name") != null ? rs.getString("user_name") : "Guest", normalFont));
                table.addCell(new Phrase(rs.getString("user_email") != null ? rs.getString("user_email") : "-", normalFont));
                String items = rs.getString("items");
                table.addCell(new Phrase(items != null && items.length() > 30 ? items.substring(0, 27) + "..." : items, normalFont));
                table.addCell(new Phrase("₹" + rs.getDouble("amount"), normalFont));
                table.addCell(new Phrase(rs.getString("order_status") != null ? rs.getString("order_status") : "Processing", normalFont));
                table.addCell(new Phrase(rs.getTimestamp("transaction_date") != null ? sdf.format(rs.getTimestamp("transaction_date")) : "N/A", normalFont));
            }
        }
        
        document.add(table);
    }
    
    private void generateBestSellingReport(Document document, String period, Font headerFont, Font normalFont) throws Exception {
        String dateCondition = getDateCondition(period);
        String query = "SELECT items, COUNT(*) as order_count, SUM(amount) as total_revenue " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "GROUP BY items ORDER BY order_count DESC FETCH FIRST 10 ROWS ONLY";
        
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        String[] headers = {"Item Name", "Orders Count", "Total Revenue"};
        for(String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(228, 0, 43));
            table.addCell(cell);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String items = rs.getString("items");
                table.addCell(new Phrase(items != null && items.length() > 40 ? items.substring(0, 37) + "..." : items, normalFont));
                table.addCell(new Phrase(String.valueOf(rs.getInt("order_count")), normalFont));
                table.addCell(new Phrase("₹" + rs.getDouble("total_revenue"), normalFont));
            }
        }
        
        document.add(table);
    }
    
    private void generateCustomerReport(Document document, String period, Font headerFont, Font normalFont) throws Exception {
        String dateCondition = getDateCondition(period);
        String query = "SELECT user_name, user_email, COUNT(*) as order_count, SUM(amount) as total_spent " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                       "GROUP BY user_name, user_email ORDER BY total_spent DESC FETCH FIRST 10 ROWS ONLY";
        
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        String[] headers = {"Customer Name", "Email", "Orders", "Total Spent"};
        for(String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(228, 0, 43));
            table.addCell(cell);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                table.addCell(new Phrase(rs.getString("user_name") != null ? rs.getString("user_name") : "Guest", normalFont));
                table.addCell(new Phrase(rs.getString("user_email"), normalFont));
                table.addCell(new Phrase(String.valueOf(rs.getInt("order_count")), normalFont));
                table.addCell(new Phrase("₹" + rs.getDouble("total_spent"), normalFont));
            }
        }
        
        document.add(table);
    }
    
    private void generateSummaryReport(Document document, String period, Font headerFont, Font normalFont) throws Exception {
        String dateCondition = getDateCondition(period);
        
        String query = "SELECT COUNT(*) as total_orders, SUM(amount) as total_revenue, AVG(amount) as avg_order_value " +
                       "FROM Transactions WHERE payment_status = 'Success' " + dateCondition;
        Connection conn = DBConnection.getConnection();
        try (
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                PdfPTable table = new PdfPTable(2);
                table.setWidthPercentage(100);
                table.setSpacingBefore(10);
                
                addSummaryRow(table, "Total Orders", String.valueOf(rs.getInt("total_orders")), headerFont, normalFont);
                addSummaryRow(table, "Total Revenue", "₹" + rs.getDouble("total_revenue"), headerFont, normalFont);
                addSummaryRow(table, "Average Order Value", "₹" + rs.getDouble("avg_order_value"), headerFont, normalFont);
                
                document.add(table);
            }
        }
        
        // Add peak hours
        document.add(new Paragraph(" "));
        Paragraph peakHeader = new Paragraph("Peak Ordering Hours", headerFont);
        document.add(peakHeader);
        
        String peakQuery = "SELECT TO_CHAR(transaction_date, 'HH24') as hour, COUNT(*) as order_count " +
                           "FROM Transactions WHERE payment_status = 'Success' " + dateCondition +
                           "GROUP BY TO_CHAR(transaction_date, 'HH24') ORDER BY order_count DESC FETCH FIRST 5 ROWS ONLY";
        
        PdfPTable peakTable = new PdfPTable(2);
        peakTable.setWidthPercentage(100);
        peakTable.setSpacingBefore(10);
        
        addSummaryRow(peakTable, "Hour", "Orders Count", headerFont, normalFont);
        
        try (PreparedStatement pstmt = conn.prepareStatement(peakQuery);
             ResultSet rs2 = pstmt.executeQuery()) {
            while (rs2.next()) {
                addSummaryRow(peakTable, rs2.getString("hour") + ":00", String.valueOf(rs2.getInt("order_count")), headerFont, normalFont);
            }
        }
        
        document.add(peakTable);
    }
    
    private void addSummaryRow(PdfPTable table, String label, String value, Font headerFont, Font normalFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, headerFont));
        labelCell.setBorderColor(new com.itextpdf.text.BaseColor(228, 0, 43));
        PdfPCell valueCell = new PdfPCell(new Phrase(value, normalFont));
        valueCell.setBorderColor(new com.itextpdf.text.BaseColor(228, 0, 43));
        table.addCell(labelCell);
        table.addCell(valueCell);
    }
    
    private String getDateCondition(String period) {
        if("weekly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 7";
        } else if("monthly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 30";
        } else if("yearly".equals(period)) {
            return "AND transaction_date >= SYSDATE - 365";
        }
        return "";
    }
}