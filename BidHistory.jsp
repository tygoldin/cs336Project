<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bid History</title>
</head>
<body>
	Bid History
	<p>Provide the name of an item that is on auction to see the auction's bid history.</p>
	<form method="post" action="BidHistoryFinder.jsp">
		<label for="item_name">Item name:</label><br>
		<input type="text" id="item_name" name="item_name"><br>
		<input name="button_clicked" type="submit" value="Search"><br>
	</form>
	<p>Provide a site member's name to see all of the auctions they have participated in.</p>
	<form method="post" action="BidHistoryFinder.jsp">
		<label for="member_name">Member name:</label><br>
		<input type="text" id="member_name" name="member_name"><br>
		<input name="button_clicked" type="submit" value="Search_members"><br>
	</form>
	<p>Provide the name of an item to see other items in the same category that have been auctioned recently.</p>
	<form method="post" action="BidHistoryFinder.jsp">
		<label for="item_name">Item name:</label><br>
		<input type="text" id="item_name2" name="item_name2"><br>
		<input name="button_clicked" type="submit" value="Search_items"><br>
	</form>
	
	<form method="post" action="userLogin.jsp">
 			<input name="button_clicked" type="submit" value="Return to Listings"/>
 	</form>
</body>
</html>