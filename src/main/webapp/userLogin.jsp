<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@include file="timerAuction.jsp"%>
<%@include file="readAlerts.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logged in</title>


</head>
<body>

	

	<% try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	%> 
	
	<%
   		String status = request.getParameter("button_clicked");
		
		if (status.equals("register")){
			String username = request.getParameter("username");
			String password = request.getParameter("password");
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
			String username = null;
			String password = null;
			ResultSet result = null;
			if (status.equals("login")){
				username = request.getParameter("username");
				password = request.getParameter("password");
				result = stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "' and password = '" + password + "')");
			} else {
				username = (String) request.getSession().getAttribute("userName");
				result = stmt.executeQuery("SELECT * FROM accounts WHERE mem_name = '" + username + "'");
			}
			if (result.next() == false){
				if (stmt.executeQuery("SELECT * FROM accounts WHERE (mem_name = '" + username + "')").next() == false){
					out.println("The user " + username + "does not exist. Please register for a new account.");
				} else {
					out.println("You have entered in invalid credentials for the user, " + username + ". Please try again.");
				}
			} else {
				checkAuctions();
				out.println(readAlerts(username));
				request.getSession().setAttribute("userName", username);
				out.println("Now logged in as " + result.getString("mem_name") + ".");
				%>
				
				<form method="post" action="startAuction.jsp">
					<input name="button_clicked" type="submit" value="List Item"/>
				</form>
				
				<form method="post" action="loginPage.jsp">
				<input name="return" type="submit" value="return to login page"/>
				</form>
				
				<form method="post" action="SearchFunction.jsp">
 					<input name="button_clicked" type="submit" value="Sort and search listings"/>
 				</form>
				
				<form method="post" action="BidHistory.jsp">
					<input name="button_clicked" type="submit" value="More specific searches"/>
				</form>
				
				<ul>
				<%
				
				result = stmt.executeQuery("SELECT * FROM auctions a, items i WHERE a.item_id = i.item_id;");
				
				while (result.next()){
					%>
					<li>		
						<form method="post" action="viewItem.jsp">
							<% 
							out.println(result.getString("title") + '-');
							out.println(result.getString("description"));
							String item_id = result.getString("item_id");
							%>
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					</li>
					<%
				}
				%>
				</ul>
				<%
			}
			
			
			
		}
   	%>
	
	<%} catch (Exception e) {
			out.print(e);
	}%>
	
	
	
</body>
</html>