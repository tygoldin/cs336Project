<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Function</title>
</head>
<body>
	Search Page
		<p> If you want to sort the items by a certain category, use one of the buttons below. </p>
		<form method="post" action="SearchOrganization.jsp">
			<input type="radio" id="maximum_price" name="criteria" value="maximum_price">
			<label for="maximum_price">Maximum Price</label><br>
			<input type="radio" id="title" name="criteria" value="title">
			<label for="title">Title</label><br>
			<input type="radio" id="user" name="criteria" value="user">
			<label for="user">User</label><br>
			<input type="radio" id="category1" name="criteria" value="category1">
			<label for="category1">Category 1</label><br>
			<input type="radio" id="category2" name="criteria" value="category2">
			<label for="category2">Category 2</label><br>
			<input type="radio" id="category3" name="criteria" value="category3">
			<label for="category3">Category 3</label><br>
			<input name="button_clicked" type="submit" value="Sort">
		</form>
		<p> If you want to do a more specific search for items, use one of the text boxes below. </p>
		<form method="post" action="SearchOrganization.jsp">
			<label for="title2">Title</label><br>
			<input type="text" id="title2" name="title2"><br>
			<label for="user">User</label><br>
			<input type="text" id="user2" name="user2"><br>
			<input name="button_clicked" type="submit" value="Search">
			<label for="item_id">Item ID</label><br>
			<input type="text" id="item_id" name="item_id"><br>
		</form>
		
		<form method="post" action="userLogin.jsp">
 			<input name="button_clicked" type="submit" value="Return to Listings"/>
 		</form>
</body>
</html>