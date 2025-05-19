

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.*;
/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/ProcessLogin")
public class ProcessLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProcessLogin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		//User user = new User();
		//PrintWriter pw = response.getWriter();
        String uName = request.getParameter("username");
        String pass = request.getParameter("password");
        boolean validUser = false;
        
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mellowmistmanagement", "root", "1234");
            String query = "select * from users where username = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, uName);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
            	//user.setUsername(uName);
            	String password = rs.getString("password");
            	if (pass != null && pass.equals(password)) {
            		validUser = true;
            	}         	
            }     
        } catch (Exception e) {
        	System.out.println("Error: " + e);
        }
        
        if (validUser) {
        	response.sendRedirect("dashboard.jsp");
        } else {
        	//response.sendRedirect("login.jsp");
        	request.setAttribute("error", "1");
        	RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
        	rd.forward(request, response);
        	System.out.println("Error login");
        }   
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
