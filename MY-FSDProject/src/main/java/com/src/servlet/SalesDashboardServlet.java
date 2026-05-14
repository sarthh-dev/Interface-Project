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
import org.json.JSONArray;
import org.json.JSONObject;
import com.src.dao.DBConnection;

@WebServlet("/SalesDashboardServlet")
public class SalesDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String period = request.getParameter("period");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if("dailySales".equals(action)) {
                getDailySales(response, period);
            } else if("popularItems".equals(action)) {
                getPopularItems(response, period);
            } else if("categorySales".equals(action)) {
                getCategorySales(response);
            } else if("orderStatus".equals(action)) {
                getOrderStatus(response);
            } else if("summary".equals(action)) {
                getSummary(response, period);
            } else {
                response.getWriter().write("{}");
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().write("{}");
        }
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
    
    private void getDailySales(HttpServletResponse response, String period) throws IOException {
        JSONObject result = new JSONObject();
        JSONArray dates = new JSONArray();
        JSONArray amounts = new JSONArray();
        
        String dateCondition = getDateCondition(period);
        String query = "SELECT TO_CHAR(transaction_date, 'YYYY-MM-DD') as sale_date, NVL(SUM(amount), 0) as total FROM Transactions WHERE 1=1 " + dateCondition + " GROUP BY TO_CHAR(transaction_date, 'YYYY-MM-DD') ORDER BY sale_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while(rs.next()) {
                dates.put(rs.getString("sale_date"));
                amounts.put(rs.getDouble("total"));
            }
            result.put("dates", dates);
            result.put("amounts", amounts);
        } catch(Exception e) {
            result.put("dates", new JSONArray());
            result.put("amounts", new JSONArray());
        }
        response.getWriter().write(result.toString());
    }
    
    private void getPopularItems(HttpServletResponse response, String period) throws IOException {
        JSONObject result = new JSONObject();
        JSONArray names = new JSONArray();
        JSONArray counts = new JSONArray();
        
        String dateCondition = getDateCondition(period);
        String query = "SELECT items, COUNT(*) as order_count FROM Transactions WHERE items IS NOT NULL " + dateCondition + " GROUP BY items ORDER BY order_count DESC FETCH FIRST 5 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while(rs.next()) {
                String items = rs.getString("items");
                if(items != null && items.length() > 20) items = items.substring(0, 20) + "...";
                names.put(items != null ? items : "Unknown");
                counts.put(rs.getInt("order_count"));
            }
            result.put("names", names);
            result.put("counts", counts);
        } catch(Exception e) {
            result.put("names", new JSONArray());
            result.put("counts", new JSONArray());
        }
        response.getWriter().write(result.toString());
    }
    
    private void getCategorySales(HttpServletResponse response) throws IOException {
        JSONObject result = new JSONObject();
        JSONArray categories = new JSONArray();
        JSONArray totals = new JSONArray();
        
        String query = "SELECT category, COUNT(*) as total FROM FoodItems GROUP BY category ORDER BY total DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while(rs.next()) {
                categories.put(rs.getString("category"));
                totals.put(rs.getInt("total"));
            }
            result.put("categories", categories);
            result.put("totals", totals);
        } catch(Exception e) {
            result.put("categories", new JSONArray());
            result.put("totals", new JSONArray());
        }
        response.getWriter().write(result.toString());
    }
    
    private void getOrderStatus(HttpServletResponse response) throws IOException {
        JSONObject result = new JSONObject();
        JSONArray statuses = new JSONArray();
        JSONArray counts = new JSONArray();
        
        String query = "SELECT NVL(order_status, 'Processing') as status, COUNT(*) as count FROM Transactions GROUP BY NVL(order_status, 'Processing')";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while(rs.next()) {
                statuses.put(rs.getString("status"));
                counts.put(rs.getInt("count"));
            }
            result.put("statuses", statuses);
            result.put("counts", counts);
        } catch(Exception e) {
            result.put("statuses", new JSONArray());
            result.put("counts", new JSONArray());
        }
        response.getWriter().write(result.toString());
    }
    
    private void getSummary(HttpServletResponse response, String period) throws IOException {
        JSONObject result = new JSONObject();
        String dateCondition = getDateCondition(period);
        String query = "SELECT COUNT(*) as total_orders, NVL(SUM(amount), 0) as total_revenue, NVL(AVG(amount), 0) as avg_order FROM Transactions WHERE 1=1 " + dateCondition;
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if(rs.next()) {
                result.put("totalOrders", rs.getInt("total_orders"));
                result.put("totalRevenue", rs.getDouble("total_revenue"));
                result.put("avgOrderValue", rs.getDouble("avg_order"));
            } else {
                result.put("totalOrders", 0);
                result.put("totalRevenue", 0);
                result.put("avgOrderValue", 0);
            }
        } catch(Exception e) {
            result.put("totalOrders", 0);
            result.put("totalRevenue", 0);
            result.put("avgOrderValue", 0);
        }
        response.getWriter().write(result.toString());
    }
}