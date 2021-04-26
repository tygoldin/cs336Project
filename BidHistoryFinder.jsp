<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Niche Searches</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement();
	%>
	
	<%
	
		%>
		<form method="post" action="userLogin.jsp">
			<input name="button_clicked" type="submit" value="Return to Listings"/>
		</form>
		<form method="post" action="BidHistory.jsp">
			<input name="button_clicked" type="submit" value="Return to Specific Searches"/>
		</form>
		<%
	
		String status = request.getParameter("button_clicked");
		if (status.equals("Search")) {
			String entry = request.getParameter("item_name");
			ResultSet result = stmt.executeQuery("SELECT i.title, b.mem_name, b.bid_amount FROM items i, bids b WHERE i.title = '" + entry + "' AND i.item_id = b.item_id");
			while(result.next()) {
				out.print(result.getString("i.title") + ", ");
				out.print(result.getString("b.mem_name") + ", ");
				out.println(result.getString("b.bid_amount"));
			}
		}
		if (status.equals("Search_members")) {
			String entry = request.getParameter("member_name");
			ResultSet result = stmt.executeQuery("SELECT a.mem_name, a.item_id FROM auctions a WHERE a.mem_name = '" + entry + "'");
			out.println("Seller");
			while(result.next()) {
				out.print(result.getString("a.mem_name") + ", ");
				out.println(result.getString("a.item_id"));
			}
			ResultSet result2 = stmt2.executeQuery("SELECT DISTINCT b.mem_name, b.item_id FROM bids b WHERE b.mem_name = '" + entry + "'");
			out.println("Buyer");
			while(result.next()) {
				out.print(result.getString("b.mem_name") + ", ");
				out.println(result.getString("b.item_id"));
			}
		}
		else {
			String entry = request.getParameter("item_name2");
			ResultSet result = stmt.executeQuery("SELECT DISTINCT i.item_id FROM items i WHERE i.title = '" + entry + "'");
			String id = result.getString("i.item_id");
			ResultSet result2 = stmt2.executeQuery("SELECT c1.item_id FROM category1 c1 WHERE c1.item_id = '" + id + "'");
			if (result2 == null) {
				result2 = stmt2.executeQuery("SELECT c2.item_id FROM category2 c2 WHERE c2.item_id = '" + id + "'");
				if (result2 == null) {
					result2 = stmt2.executeQuery("SELECT c3.item_id FROM category3 c3 WHERE c3.item_id = '" + id + "'");
					ResultSet result3 = stmt.executeQuery("SELECT c3.item_id, i.title FROM category3 c3, items i, auctions a WHERE c3.item_id = i.item_id AND a.startDate > (SELECT MONTH(GETDATE()) - 1)");
					while(result.next()) {
						out.print(result.getString("c3.item_id") + ", ");
						out.println(result.getString("i.title"));
					}
				}
				else {
					ResultSet result3 = stmt.executeQuery("SELECT c2.item_id, i.title FROM category2 c2, items i, auctions a WHERE c2.item_id = i.item_id AND a.startDate > (SELECT MONTH(GETDATE()) - 1)");
					while(result.next()) {
						out.print(result.getString("c2.item_id") + ", ");
						out.println(result.getString("i.title"));
					}
				}
			}
			else{
				ResultSet result3 = stmt.executeQuery("SELECT c1.item_id, i.title FROM category1 c1, items i, auctions a WHERE c1.item_id = i.item_id AND a.startDate > (SELECT MONTH(GETDATE()) - 1)");
				while(result.next()) {
					out.print(result.getString("c1.item_id") + ", ");
					out.println(result.getString("i.title"));
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