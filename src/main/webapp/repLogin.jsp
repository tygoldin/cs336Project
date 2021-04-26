<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Representative Login</title>
</head>
<% try {
			
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

   		String status = request.getParameter("button_clicked");
   		ResultSet result=null;
		if(status!=null){
			if (status.equals("Remove Auction")){
				String item_id = request.getParameter("item_id");
				out.println("Removing "+item_id);
				%><br><%
				
				result = stmt.executeQuery("SELECT * FROM auctions WHERE (item_id = '" + item_id + "')");
				
				if (result.next() == false){
					out.println("The item " + item_id + "does not exist.");
					%><br><%
				} else {
					// Make sure Customer Representative is not deleting another rep or the admin
					String update="DELETE from auctions where item_id='"+item_id+"'";
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully deleted auction " + item_id + ".");
					} catch (Exception e){
						out.println("Deleting auction failed. The auction for " + item_id + ", does not exist. Please try again.");
					}
					%><br><%
				}
				
			} else if (status.equals("Remove Last Bid")){
				String item_id = request.getParameter("item_id");
				out.println("Removing last bid from "+item_id);
				%><br><%
				
				result = stmt.executeQuery("SELECT MAX(bid_amount) FROM bids WHERE (item_id = '" + item_id + "')");
				
				
				
				if (result.next() == false){
					out.println("There are no bids for item " + item_id + ".");
					%><br><%
				} else {
					
					String update="DELETE from bids where item_id='"+item_id+"' and bid_amount='"+result.getString(1)+"'";
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully deleted highest bid for " + item_id + ".");
					} catch (Exception e){
						out.println("Unable to remove highest bid for item " + item_id + ". Please try again.");
					}
					%><br><%
				}
			}
		}
}
catch(Exception e){
	out.print(e);
}
%>
<body>
Customer Representative Login as <% out.println((String) request.getSession().getAttribute("userName")); %>
<br>
	<form method="post" action="replies.jsp">
		<input name="return" type="submit" value="view and reply to questions"/>
	</form>
	<form method="post" action="loginPage.jsp">
		<input name="return" type="submit" value="return to login page"/>
	</form>
	<br><br>
	Modify User Account:
	<br>
	<form method="post" action="editUser.jsp">
		Username<br>
		<input type="text" name="username" maxlength="50"/>
		<br>
		Password (can leave blank if deleting user)<br>
		<input type="password" name="password" maxlength="50"/>
		<br>
		<input name="edit_user" type="submit" value="change password"/>
		<br>
		<input name="edit_user" type="submit" value="delete user"/>	
	</form>
	<% try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			ResultSet result = stmt.executeQuery("SELECT * FROM auctions a, items i WHERE a.endDate >= '" + new Timestamp(System.currentTimeMillis()) + "' AND a.item_id = i.item_id;");

			while (result.next()){
				%>
				<li>		
					<form method="post" action="repLogin.jsp">
						<% 
						out.println(result.getString("title") + '-');
						out.println(result.getString("description"));
						String item_id = result.getString("item_id");
						%>
						<input name="button_clicked" type="submit" value="Remove Auction"/>
						<input name="button_clicked" type="submit" value="Remove Last Bid"/>
						<input type="hidden" name="item_id" value=<%=item_id%> />
					</form>
				</li>
				<%
			}	
   	%>
	
	<%} catch (Exception e) {
			out.print(e);
	}%>
</body>
</html>