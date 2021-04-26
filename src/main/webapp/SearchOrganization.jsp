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
			if (status.equals("Sort by maximum price")) {
				ResultSet result = stmt.executeQuery("SELECT DISTINCT i.title, i.item_id, i.mem_name, b.max_bid FROM items i, bids b WHERE i.item_id = b.item_id"); 
				while(result.next()) {
					out.print(result.getString("title") + ", ");
					out.print(result.getString("item_id") + ", ");
					out.print(result.getString("mem_name") + ", ");
					out.println(result.getString("max_bid"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Sort by title")) {
				ResultSet result = stmt.executeQuery("SELECT * FROM items ORDER BY title");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Sort by user")) {
				ResultSet result = stmt.executeQuery("SELECT * FROM items ORDER BY mem_name");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Sort through category 1")) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category1.field1, category1.field2 FROM items INNER JOIN category1 ON (items.item_id = category1.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category1.field1") + ", ");
					out.println(result.getString("category1.field2"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Sort through category 2")) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category2.field1, category2.field2 FROM items INNER JOIN category2 ON (items.item_id = category2.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category2.field1") + ", ");
					out.println(result.getString("category2.field2"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Sort through category 3")) {
				ResultSet result = stmt.executeQuery("SELECT items.title, items.item_id, items.mem_name, category3.field1, category3.field2 FROM items INNER JOIN category3 ON (items.item_id = category3.item_id)");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("category3.field1") + ", ");
					out.println(result.getString("category3.field2"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Search by title")) {
				String entry = request.getParameter("title2");
				ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.title LIKE '" + entry + "'");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Search by user")) {
				String entry = request.getParameter("user2");
				ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.mem_name LIKE '" + entry + "'");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
				}
			}
			if (status.equals("Search by item id")) {
				String entry = request.getParameter("item_id");
				ResultSet result = stmt.executeQuery("SELECT * FROM items WHERE items.item_id LIKE '" + entry + "'");
				while(result.next()) {
					out.print(result.getString("items.item_id") + ", ");
					out.print(result.getString("items.title") + ", ");
					out.print(result.getString("items.mem_name") + ", ");
					out.println(result.getString("items.description"));
					String item_id = result.getString("item_id");
					%>	
						<form method="post" action="viewItem.jsp">
							<input name="button_clicked" type="submit" value="View Item"/>
							<input type="hidden" name="item_id" value=<%=item_id%> />
						</form>
					<%
					%>
					<br>
					<%
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
