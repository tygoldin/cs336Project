<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit User</title>
</head>
<body>
<% try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	%> 
	
	<%
   		String status = request.getParameter("edit_user");
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		ResultSet result = null;
	
		if (status.equals("change password")){
			result = stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "')");
					
			if (result.next() == false){
				out.println("The user " + username + "does not exist.");
			} else {
				// Make sure Customer Representative is not changing password of another rep or the admin
				if(result.getString("account_type").equals("administrator") || result.getString("account_type").equals("representative")){
					out.println("You cannot edit the information of a Customer Representative or Administrator.");
				}
				else {
					String update="Update accounts set password='" + password + "' where mem_name='"+username+"'";
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Changed user password of " + username + ".");
					} catch (Exception e){
						out.println("Editing user failed. The user, " + username + ", does not exist. Please try again.");
					}
					%>
				
					<form method="post" action="repLogin.jsp">
					<input name="return" type="submit" value="return to Customer Rep page"/>
					</form>

					<%
				}
			}
		} else {
			result = stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "')");
			
			if (result.next() == false){
				out.println("The user " + username + "does not exist.");
			} else {
				// Make sure Customer Representative is not deleting another rep or the admin
				if(result.getString("account_type").equals("administrator") || result.getString("account_type").equals("representative")){
					out.println("You cannot delete a Customer Representative or Administrator account.");
				}
				else {
					String update="DELETE from accounts where mem_name='"+username+"'";
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully deleted account " + username + ".");
					} catch (Exception e){
						out.println("Deleting user failed. The user, " + username + ", does not exist. Please try again.");
					}
					%>
				
					<form method="post" action="repLogin.jsp">
					<input name="return" type="submit" value="return to Customer Rep page"/>
					</form>

					<%
				}
			}
			
		}
   	%>
	
	<%} catch (Exception e) {
			out.print(e);
	}%>
</body>
</html>