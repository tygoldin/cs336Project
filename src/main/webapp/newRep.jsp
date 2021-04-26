<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>New Customer Rep</title>
</head>
<body>

<% try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

   		String status = request.getParameter("create_rep");
		
		String username = request.getParameter("rep_name");
		String password = request.getParameter("rep_password");
		String rep_type = "representative";
		// sql logic for registering the user	

		//Create a SQL statement
			
			
		//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		String update = "INSERT INTO accounts (mem_name, password, account_type) VALUES ('" + username + "','" + password + "','" + rep_type + "');";
		//Run the query against the database.
		try {
			int i = stmt.executeUpdate(update);
			out.println("Registered new customer representative: " + username + ".");
		} catch (Exception e){
			out.println("Registering new customer representative failed. The user, " + username + ", already exists. Please try again.");
		}
		%>
		<form method="post" action="adminLogin.jsp">
			<input name="admin_return" type="submit" value="return to Admin page"/>
		</form>
		<%
	
	} catch (Exception e) {
			out.print(e);
	}%>

</body>
</html>