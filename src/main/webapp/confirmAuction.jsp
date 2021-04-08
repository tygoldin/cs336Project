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
	<%
	String username = (String) request.getSession().getAttribute("userName");
	out.println("Confirming an auction for " + username);
	
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String title = (String) request.getParameter("title");
		String description = (String) request.getParameter("description");
		String endDate = ((String) request.getParameter("endDate")).replace("T"," ") + ":00.00";
		Timestamp sqlEndDate = Timestamp.valueOf(endDate);
		double min_bid = Double.parseDouble(request.getParameter("min_bid"));
		double bid_increment = Double.parseDouble(request.getParameter("bid_increment"));
		boolean category1 = request.getParameter("category1") != null;
		if(category1){
			String field1 = request.getParameter("cat1field1");
			String field2 = request.getParameter("cat1field2");
		}
		boolean category2 = request.getParameter("category2") != null;
		if(category2){
			String field1 = request.getParameter("cat2field1");
			String field2 = request.getParameter("cat2field2");
		}
		boolean category3 = request.getParameter("category3") != null;
		if(category3){
			String field1 = request.getParameter("cat2field1");
			String field2 = request.getParameter("cat2field2");
		}
		
		String update = "INSERT INTO items (description, title, mem_name) VALUES ('"+ description + "','" + title + "','"+username+"');";
		int i = stmt.executeUpdate(update, Statement.RETURN_GENERATED_KEYS);
		ResultSet rs = stmt.getGeneratedKeys();
		rs.next();

		update = "INSERT INTO auctions (mem_name, item_id, bid_increment, startDate, endDate, min_price) VALUES ('" + username + "','" + rs.getInt(1) + "','" + bid_increment + "','" +
		new Timestamp(System.currentTimeMillis()) + "','" + sqlEndDate + "','" + min_bid + "');";
		i = stmt.executeUpdate(update);
		%>
		
		
		<%	
		
	} catch (Exception e){
		out.print(e);
	}
	
	%>
	
</body>
</html>