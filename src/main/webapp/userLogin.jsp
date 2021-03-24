<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logged in</title>


</head>
<body>

	

	<% try {
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	%> 
	
	<%
   		String status = request.getParameter("button_clicked");
		
		if (status.equals("register")){
			// sql logic for registering the user	

			//Create a SQL statement
			
			
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String update = "INSERT INTO accounts (mem_name, password) VALUES ('" + username + "','" + password + "');";
			//Run the query against the database.
			try {
				int i = stmt.executeUpdate(update);
				out.println("Registered new user: " + username + ".");
			} catch (Exception e){
				out.println("Registering new user failed. The user, " + username + ", already exists. Please try again.");
			}
			
			%>
			<form method="post" action="loginPage.jsp">
				<input name="return" type="submit" value="return to login page"/>
			</form>
			
			
			
			<%
		} else {
			ResultSet result = stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "' and password = '" + password + "')");
			if (result.next() == false){
				if (stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "')").next() == false){
					out.println("The user " + username + "does not exist. Please register for a new account.");
				} else {
					out.println("You have entered in invalid credentials for the user, " + username + ". Please try again.");
				}
			} else {
				out.println("Now logged in as " + result.getString("mem_name") + ".");
			}
			
			%>
			<form method="post" action="loginPage.jsp">
				<input name="return" type="submit" value="return to login page"/>
			</form>
			<%
			
		}
   	%>
	
	<%} catch (Exception e) {
			out.print(e);
	}%>
	
	
	
</body>
</html>