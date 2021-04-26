<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Searching by different criteria</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
	%>
	
	<%
	
		%>
		<form method="post" action="userLogin.jsp">
 			<input name="button_clicked" type="submit" value="Return to Listings"/>
 		</form>
 		<form method="post" action="SearchFunction.jsp">
 			<input name="button_clicked" type="submit" value="Return to Search Home"/>
 		</form>
		<%
	
		String status = request.getParameter("button_clicked");
		if (status.equals("Sort")) {
			if (request.getParameter("maximum_price") != null) {
				ResultSet result = stmt.executeQuery("SELECT DISTINCT i.title, i.item_id, i.mem_name, b.max_bid FROM items i, bids b WHERE i.item_id = b.item_id"); 
				while(result.next()) {
					out.print(result.getString("i.title") + ", ");
					out.print(result.getString("i.item_id") + ", ");
					out.print(result.getString("i.mem_name") + ", ");
					out.println(result.getString("b.max_bid"));
				}
			}
			if (request.getParameter("title") != null) {
				ResultSet result = stmt.executeQuery("SELECT * FROM items GROUP BY title");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
				}
			}
			if (request.getParameter("user") != null) {
				ResultSet result = stmt.executeQuery("SELECT * FROM items GROUP BY user");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
				}
			}
			if (request.getParameter("category1") != null) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category1.field1, category1.field2 FROM items INNER JOIN category1 ON (items.item_id = category1.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category1.field1") + ", ");
					out.println(result.getString("category1.field2"));
				}
			}
			if (request.getParameter("category2") != null) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category2.field1, category2.field2 FROM items INNER JOIN category2 ON (items.item_id = category2.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category2.field1") + ", ");
					out.println(result.getString("category2.field2"));
				}
			}
			if (request.getParameter("category3") != null) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category3.field1, category3.field2 FROM items INNER JOIN category3 ON (items.item_id = category3.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category3.field1") + ", ");
					out.println(result.getString("category3.field2"));
				}
			}
		}
		else {
			if (request.getParameter("title2") != null && request.getParameter("user2") != null && request.getParameter("item_id") != null) {
				String entry = request.getParameter("title2");
				String entry2 = request.getParameter("user2");
				String entry3 = request.getParameter("item_id");
				ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.title LIKE '" + entry + "' AND items.user LIKE '" + entry2 + "' AND items.item_id LIKE '" + entry3 + "'");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
				}
			}
			else {
				if (request.getParameter("title2") != null) {
					String entry = request.getParameter("title2");
					ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.title LIKE '" + entry + "'");
					while(result.next()) {
						out.print(result.getString("items.item_id") + ", ");
						out.print(result.getString("items.title") + ", ");
						out.print(result.getString("items.mem_name") + ", ");
						out.println(result.getString("items.description"));
					}
				}
				if (request.getParameter("user2") != null) {
					String entry = request.getParameter("user2");
					ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.mem_name LIKE '" + entry + "'");
					while(result.next()) {
						out.print(result.getString("items.item_id") + ", ");
						out.print(result.getString("items.title") + ", ");
						out.print(result.getString("items.mem_name") + ", ");
						out.println(result.getString("items.description"));
					}
				}
				if (request.getParameter("user3") != null) {
					String entry = request.getParameter("item_id");
					ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.item_id LIKE '" + entry + "'");
					while(result.next()) {
						out.print(result.getString("items.item_id") + ", ");
						out.print(result.getString("items.title") + ", ");
						out.print(result.getString("items.mem_name") + ", ");
						out.println(result.getString("items.description"));
					}
				}
			}
		}
	%>
	
	<%
		}catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>