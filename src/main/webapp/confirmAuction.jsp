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
		boolean category2 = request.getParameter("category2") != null;
		boolean category3 = request.getParameter("category3") != null;
		String field1 = "";
		String field2 = "";
		String category ="";
		// checks if only one category
		if (((category1 ? 1 : 0) + (category2 ? 1 : 0) + (category3 ? 1 : 0)) == 1){
			if(category1){
				field1 = request.getParameter("cat1field1");
				field2 = request.getParameter("cat1field2");
				category = "category1";
			} else if (category2){
				field1 = request.getParameter("cat2field1");
				field2 = request.getParameter("cat2field2");
				category = "category2";
			} else if (category3){
				field1 = request.getParameter("cat2field1");
				field2 = request.getParameter("cat2field2");
				category = "category3";
			}
			if (field1.length() == 0 || field2.length() == 0){
				out.println("Must enter information for both field values!");
			} else {
				String update = "INSERT INTO items (description, title, mem_name) VALUES ('"+ description + "','" + title + "','"+username+"');";
				int i = stmt.executeUpdate(update, Statement.RETURN_GENERATED_KEYS);
				ResultSet rs = stmt.getGeneratedKeys();
				rs.next();

				update = "INSERT INTO auctions (mem_name, item_id, bid_increment, startDate, endDate, min_price) VALUES ('" + username + "','" + rs.getInt(1) + "','" + bid_increment + "','" +
				new Timestamp(System.currentTimeMillis()) + "','" + sqlEndDate + "','" + min_bid + "');";
				i = stmt.executeUpdate(update);
				
				int id = 0;
				rs = stmt.executeQuery("select * from items");
				if(rs.last()){
					id=rs.getInt("item_id");
				}
				update = "INSERT INTO " + category + " (item_id, field1, field2) VALUES('" + id + "','" + field1 + "','" + field2 + "');";
				i = stmt.executeUpdate(update);
				out.println("You have successfully listed " + title + ".");
			}	
		} else {
			out.println("Must select only one category!");
		}
		
		%>
		<form method="post" action="userLogin.jsp">
			<input name="button_clicked" type="submit" value="Return to Listings"/>
		</form>
		
		<%	
		
	} catch (Exception e){
		out.print(e);
	}
	
	%>
	
</body>
</html>