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

@WebServlet("/GenerateReceiptServlet")
public class GenerateReceiptServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String transactionId = request.getParameter("transactionId");
        
        if(transactionId == null || transactionId.isEmpty()) {
            response.setContentType("text/html");
            response.getWriter().write("<h3>Error: Transaction ID is required</h3>");
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT * FROM Transactions WHERE transaction_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(transactionId));
            ResultSet rs = pstmt.executeQuery();
            
            if(rs.next()) {
                String userName = rs.getString("user_name");
                String userEmail = rs.getString("user_email");
                double amount = rs.getDouble("amount");
                String items = rs.getString("items");
                String transactionDate = rs.getString("transaction_date");
                String paymentStatus = rs.getString("payment_status");
                
                generatePDF(response, transactionId, userName, userEmail, amount, items, transactionDate, paymentStatus);
            } else {
                response.setContentType("text/html");
                response.getWriter().write("<h3>Error: Transaction not found</h3>");
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch(Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().write("<h3>Error generating receipt: " + e.getMessage() + "</h3>");
        }
    }
    
    private void generatePDF(HttpServletResponse response, String transactionId, 
                             String userName, String userEmail, double amount, 
                             String items, String transactionDate, String paymentStatus) throws Exception {
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"SRC_Receipt_" + transactionId + ".pdf\"");
        
        Document document = new Document(PageSize.A4);
        OutputStream out = response.getOutputStream();
        PdfWriter.getInstance(document, out);
        
        document.open();
        
        // Fonts
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
        Font boldFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
        
        // Header
        Paragraph title = new Paragraph("SRC FAST FOOD", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        
        Paragraph subtitle = new Paragraph("Sarthak & Rohan's Cafe", new Font(Font.FontFamily.HELVETICA, 14, Font.NORMAL));
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);
        
        Paragraph address = new Paragraph("Indore, India | Contact: +91 98765 43210", new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL));
        address.setAlignment(Element.ALIGN_CENTER);
        document.add(address);
        
        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));
        
        // Receipt Title
        Paragraph receiptTitle = new Paragraph("PAYMENT RECEIPT", new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD));
        receiptTitle.setAlignment(Element.ALIGN_CENTER);
        document.add(receiptTitle);
        
        document.add(new Paragraph(" "));
        
        // Separator
        Paragraph line = new Paragraph("--------------------------------------------------", new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL));
        line.setAlignment(Element.ALIGN_CENTER);
        document.add(line);
        
        document.add(new Paragraph(" "));
        
        // Details Table
        PdfPTable detailsTable = new PdfPTable(2);
        detailsTable.setWidthPercentage(90);
        detailsTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        String formattedDate = "";
        try {
            if(transactionDate != null && !transactionDate.isEmpty()) {
                formattedDate = transactionDate;
            } else {
                formattedDate = sdf.format(new Date());
            }
        } catch(Exception e) {
            formattedDate = sdf.format(new Date());
        }
        
        addDetailRow(detailsTable, "Transaction ID:", "#" + transactionId, boldFont, normalFont);
        addDetailRow(detailsTable, "Date:", formattedDate, boldFont, normalFont);
        addDetailRow(detailsTable, "Customer Name:", userName, boldFont, normalFont);
        addDetailRow(detailsTable, "Customer Email:", userEmail, boldFont, normalFont);
        addDetailRow(detailsTable, "Payment Status:", paymentStatus, boldFont, normalFont);
        
        document.add(detailsTable);
        
        document.add(new Paragraph(" "));
        
        // Items Section
        Paragraph itemsHeader = new Paragraph("ORDER DETAILS", headerFont);
        itemsHeader.setAlignment(Element.ALIGN_LEFT);
        document.add(itemsHeader);
        
        document.add(new Paragraph(" "));
        
        PdfPTable itemsTable = new PdfPTable(1);
        itemsTable.setWidthPercentage(90);
        itemsTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        String[] itemList = items.split(",");
        for(String item : itemList) {
            PdfPCell itemCell = new PdfPCell(new Phrase("• " + item.trim(), normalFont));
            itemCell.setBorder(PdfPCell.NO_BORDER);
            itemCell.setPadding(5);
            itemsTable.addCell(itemCell);
        }
        
        document.add(itemsTable);
        
        document.add(new Paragraph(" "));
        
        // Total Amount
        PdfPTable totalTable = new PdfPTable(2);
        totalTable.setWidthPercentage(90);
        totalTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        totalTable.setSpacingBefore(10);
        
        PdfPCell totalLabelCell = new PdfPCell(new Phrase("TOTAL AMOUNT:", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)));
        totalLabelCell.setBorder(PdfPCell.NO_BORDER);
        totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalLabelCell.setPadding(8);
        
        PdfPCell totalValueCell = new PdfPCell(new Phrase("₹ " + String.format("%.2f", amount), new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD)));
        totalValueCell.setBorder(PdfPCell.NO_BORDER);
        totalValueCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        totalValueCell.setPadding(8);
        
        totalTable.addCell(totalLabelCell);
        totalTable.addCell(totalValueCell);
        
        document.add(totalTable);
        
        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));
        
        // Footer
        Paragraph thankYou = new Paragraph("Thank you for ordering with SRC Fast Food!", new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        thankYou.setAlignment(Element.ALIGN_CENTER);
        document.add(thankYou);
        
        Paragraph footer = new Paragraph("Visit again! | Follow us on Instagram: @src_fastfood", new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL));
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);
        
        Paragraph generatedDate = new Paragraph("Generated on: " + sdf.format(new Date()), new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL));
        generatedDate.setAlignment(Element.ALIGN_CENTER);
        document.add(generatedDate);
        
        document.close();
        out.flush();
        out.close();
    }
    
    private void addDetailRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        labelCell.setBorder(PdfPCell.NO_BORDER);
        labelCell.setPadding(6);
        labelCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        
        PdfPCell valueCell = new PdfPCell(new Phrase(value, valueFont));
        valueCell.setBorder(PdfPCell.NO_BORDER);
        valueCell.setPadding(6);
        valueCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        
        table.addCell(labelCell);
        table.addCell(valueCell);
    }
}