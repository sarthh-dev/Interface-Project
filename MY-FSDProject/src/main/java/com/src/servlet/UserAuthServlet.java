package com.src.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.src.dao.UserDAO;
import com.src.model.User;

@WebServlet("/UserAuthServlet")
public class UserAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if("signup".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String gender = request.getParameter("gender");
            String contact = request.getParameter("contact");
            String password = request.getParameter("password");
            
            User user = new User(name, email, gender, contact, password);
            
            if(userDAO.registerUser(user)) {
                response.sendRedirect("userLogin.jsp?message=Registration successful! Please login.");
            } else {
                response.sendRedirect("userSignup.jsp?error=Registration failed! Email may already exist.");
            }
        } else if("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            User user = userDAO.loginUser(email, password);
            
            if(user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userId", user.getUserId());
                response.sendRedirect("userDashboard.jsp");
            } else {
                response.sendRedirect("userLogin.jsp?error=Invalid email or password!");
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if("logout".equals(action)) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("index.jsp");
        }
    }
}