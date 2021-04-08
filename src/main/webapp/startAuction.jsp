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
	out.println("Starting an Auction as " + username);	
	
	%>
	
	<form method="post" action="confirmAuction.jsp">
			Item Name:
			<input type="text" name="title" size="50" maxlength="50"/>
			<br>
			Item Description:
			<input type="text" name="description" size="100" maxlength="200"/>
			<br>
			End Date and Time:
			<input type="datetime-local" name="endDate">
			Minimum Price ($):
			<input type="number" name="min_bid" step="0.01">
			Set Minimum Bid Increment ($):
			<input type="number" step="0.01" name="bid_increment">
			<br>
			Subcategories:
			<br>
			Category 1<input type="checkbox" name="category1">
			Field 1:<input type="text" name="cat1field1" maxlength="50" size="50">
			Field 2:<input type="text" name="cat1field2" maxlength="50" size="50">
			<br>
			Category 2<input type="checkbox" name="category2">
			Field 1:<input type="text" name="cat2field1" maxlength="50" size="50">
			Field 2:<input type="text" name="cat2field2" maxlength="50" size="50">
			<br>
			Category 3<input type="checkbox" name="category3">
			Field 1:<input type="text" name="cat3field1" maxlength="50" size="50">
			Field 2:<input type="text" name="cat3field2" maxlength="50" size="50">
			<br>
			<input name="button_clicked" type="submit" value="List Item" />	
	</form>
	
	<form method="post" action="loginPage.jsp">
		<input name="return" type="submit" value="return to login page"/>
	</form>
</body>
</html>