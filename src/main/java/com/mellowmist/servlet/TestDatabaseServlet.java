package com.mellowmist.servlet;

import com.mellowmist.dao.OrderQueueDAO;
import com.mellowmist.model.OrderQueue;
import com.mellowmist.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/TestDatabase")
public class TestDatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(TestDatabaseServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        // Test the connection
        boolean connectionSuccessful = DBConnection.testDatabaseConnection();
        out.println("<p>Connection test: " + (connectionSuccessful ? "SUCCESS" : "FAILED") + "</p>");
        
        if (connectionSuccessful) {
            // If connection works, test database metadata
            try (Connection conn = DBConnection.getConnection()) {
                DatabaseMetaData metaData = conn.getMetaData();
                out.println("<h2>Database Information</h2>");
                out.println("<p>Database: " + metaData.getDatabaseProductName() + " " + 
                            metaData.getDatabaseProductVersion() + "</p>");
                out.println("<p>Driver: " + metaData.getDriverName() + " " + 
                            metaData.getDriverVersion() + "</p>");
                
                // List all tables
                out.println("<h2>Tables</h2>");
                out.println("<ul>");
                ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
                boolean hasQueueTable = false;
                
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    out.println("<li>" + tableName + "</li>");
                    
                    if (tableName.equalsIgnoreCase("queue")) {
                        hasQueueTable = true;
                    }
                }
                out.println("</ul>");
                
                // If we have the queue table, show its structure
                if (hasQueueTable) {
                    out.println("<h2>Queue Table Structure</h2>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Column Name</th><th>Type</th><th>Nullable</th><th>Default</th></tr>");
                    
                    ResultSet columns = metaData.getColumns(null, null, "queue", null);
                    while (columns.next()) {
                        out.println("<tr>");
                        out.println("<td>" + columns.getString("COLUMN_NAME") + "</td>");
                        out.println("<td>" + columns.getString("TYPE_NAME") + "</td>");
                        out.println("<td>" + (columns.getInt("NULLABLE") == 1 ? "Yes" : "No") + "</td>");
                        out.println("<td>" + columns.getString("COLUMN_DEF") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p style='color:red'>WARNING: 'queue' table not found!</p>");
                }
                
                // Test DAO operations
                out.println("<h2>OrderQueueDAO Test</h2>");
                OrderQueueDAO dao = new OrderQueueDAO();
                
                // Test connection through DAO
                out.println("<p>DAO Connection Test: " + 
                           (dao.testConnection() ? "SUCCESS" : "FAILED") + "</p>");
                
                // Test count method
                int count = dao.getTotalQueueCount();
                out.println("<p>Total Queue Count: " + count + "</p>");
                
                // Test getQueuesByPage method
                out.println("<h3>Queue Entries (Page 1)</h3>");
                List<OrderQueue> queues = dao.getQueuesByPage(1, 10);
                
                if (queues != null && !queues.isEmpty()) {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Queue ID</th><th>Order ID</th><th>Status</th><th>Queue Number</th></tr>");
                    
                    for (OrderQueue queue : queues) {
                        out.println("<tr>");
                        out.println("<td>" + queue.getQueueId() + "</td>");
                        out.println("<td>" + queue.getOrderId() + "</td>");
                        out.println("<td>" + queue.getQueueStatus() + "</td>");
                        out.println("<td>" + queue.getQueueNumber() + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p>No queue entries found. The table might be empty.</p>");
                }
            } catch (Exception e) {
                out.println("<h2>Error</h2>");
                out.println("<p style='color:red'>Exception: " + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
                logger.severe("Error in test servlet: " + e.getMessage());
            }
        }
        
        out.println("</body></html>");
    }
}