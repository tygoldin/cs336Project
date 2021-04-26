<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat,java.util.Date" %>
<%@include file="timerAuction.jsp"%>
<%@include file="readAlerts.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logged in</title>


</head>
<body>
	<%
	String username = (String) request.getSession().getAttribute("userName");
	String item_id = request.getParameter("item_id");
	String status = request.getParameter("button_clicked");
	
	checkAuctions();
	
	out.println(readAlerts(username));
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

		if (status.equals("Bid")){
			ResultSet bidderResult = stmt.executeQuery("SELECT * FROM bids WHERE item_id = '" + item_id + "' AND bid_amount = (SELECT MAX(bid_amount) FROM bids WHERE item_id = '" + item_id + "');");
			String bid_price = "No bids yet";
			String prev_name = "";
			if(bidderResult.next()){
				bid_price = bidderResult.getString("bid_amount");
				prev_name = bidderResult.getString("mem_name");
			}
			bidderResult.close();
			ResultSet result = stmt.executeQuery("SELECT * FROM auctions a, items i WHERE a.item_id = '" + item_id + "' AND a.item_id = i.item_id;");
			result.next();
			String bid_amount = request.getParameter("bid_amount");
			String max_bid = request.getParameter("max_bid");
			String bid_increment = result.getString("bid_increment");
			if (bid_amount.isEmpty()){
				out.println("Must make a bid. <br />");
			} else {
				if (!max_bid.isEmpty()){
					if (Double.parseDouble(request.getParameter("max_bid")) > Double.parseDouble(request.getParameter("bid_amount"))){
						if (bid_price.equals("No bids yet")){
							if (Double.parseDouble(request.getParameter("bid_amount")) > 0){
								String update = "INSERT INTO bids (mem_name, item_id, bid_amount, time, max_bid) VALUES ('" + username + "','" + 
									item_id + "','" + Double.parseDouble(request.getParameter("bid_amount")) + "','" + 
									new Timestamp(System.currentTimeMillis()) + "','"+Double.parseDouble(request.getParameter("max_bid"))+"');";
								int i = stmt.executeUpdate(update);
								out.println("Bid $" + bid_amount + "<br />");
							} else {
								out.println("Must bid higher than $0.00 <br />");
							}
							
						} else {
							if (Double.parseDouble(bid_amount) >= ((Double.parseDouble(bid_price) + Double.parseDouble(bid_increment)))){
								String update = "INSERT INTO bids (mem_name, item_id, bid_amount, time) VALUES ('" + username + "','" + 
										item_id + "','" + Double.parseDouble(request.getParameter("bid_amount")) + "','" + 
										new Timestamp(System.currentTimeMillis()) + "');";
								int i = stmt.executeUpdate(update);
								String alert1 = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+prev_name+"','"+ new Timestamp(System.currentTimeMillis()) +
										"','"+username+" has bid "+bid_amount+"');";
								int a= stmt.executeUpdate(alert1);
								String set = "UPDATE bids SET max_bid = '"+max_bid+"' WHERE(mem_name = '"+username+"' and item_id = '"+item_id+"');";
								int j = stmt.executeUpdate(set);
								Double bidder_amount = Double.parseDouble(bid_amount) + Double.parseDouble(bid_increment);
								ResultSet result2 = stmt.executeQuery("SELECT * FROM bids WHERE (mem_name != '"+username+"' and max_bid >= '"+bidder_amount+"' and item_id = '"+ item_id + "');");
								if (result2.next()){
									String bidder_name = result2.getString("mem_name");
									String bidder_max_bid = result2.getString("max_bid");
									if (Double.parseDouble(request.getParameter("max_bid")) >= (Double.parseDouble(bidder_max_bid) + Double.parseDouble(bid_increment))){
										String auto_bid = "INSERT INTO bids (mem_name, item_id, bid_amount, time, max_bid) VALUES ('" +username+ "','" + 
												item_id + "','" + (Double.parseDouble(bidder_max_bid)+Double.parseDouble(bid_increment)) + "','" + 
												new Timestamp(System.currentTimeMillis()) + "','"+Double.parseDouble(request.getParameter("max_bid"))+"');";
										int k = stmt.executeUpdate(auto_bid);
										String alert = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+bidder_name+"','"+ new Timestamp(System.currentTimeMillis()+1000) +
												"','"+username+" has bid "+(Double.parseDouble(bidder_max_bid)+Double.parseDouble(bid_increment))+"');";
										int l = stmt.executeUpdate(alert);
										
									}else if ((Double.parseDouble(request.getParameter("max_bid")) + Double.parseDouble(bid_increment)) <= Double.parseDouble(bidder_max_bid)){
										String auto_bid = "INSERT INTO bids (mem_name, item_id, bid_amount, time, max_bid) VALUES ('" +bidder_name+ "','" + 
												item_id + "','" + (Double.parseDouble(request.getParameter("max_bid"))+Double.parseDouble(bid_increment)) + "','" + 
												new Timestamp(System.currentTimeMillis()) + "','"+Double.parseDouble(bidder_max_bid)+"');";
										int k = stmt.executeUpdate(auto_bid);
										String alert = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+username+"','"+ new Timestamp(System.currentTimeMillis()) +
												"','"+bidder_name+" has bid "+(Double.parseDouble(request.getParameter("max_bid"))+Double.parseDouble(bid_increment))+".');";
										int l = stmt.executeUpdate(alert);
									}else{
										String auto_bid = "INSERT INTO bids (mem_name, item_id, bid_amount, time, max_bid) VALUES ('" +bidder_name+ "','" + 
												item_id + "','" + (Double.parseDouble(bidder_max_bid)) + "','" + 
												new Timestamp(System.currentTimeMillis()) + "','"+Double.parseDouble(bidder_max_bid)+"');";
										int k = stmt.executeUpdate(auto_bid);
										String alert = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+username+"','"+ new Timestamp(System.currentTimeMillis()) +
												"','"+bidder_name+" has bid "+(Double.parseDouble(bidder_max_bid))+".');";
										int l = stmt.executeUpdate(alert);
										}
									}
								
								out.println("Bid $" + bid_amount + "<br />");
							} else {
								out.println("Need to bid at least $" + (Double.parseDouble(bid_price) + Double.parseDouble(bid_increment)) + "<br />");
							}
						}
					}
					else{
						out.println("Max bid must be higher than current bid <br />");
					}
				}
				else{
					if (bid_price.equals("No bids yet")){
						if (Double.parseDouble(request.getParameter("bid_amount")) > 0){
							String update = "INSERT INTO bids (mem_name, item_id, bid_amount, time) VALUES ('" + username + "','" + 
								item_id + "','" + Double.parseDouble(request.getParameter("bid_amount")) + "','" + 
								new Timestamp(System.currentTimeMillis()) + "');";
							int i = stmt.executeUpdate(update);
							out.println("Bid $" + bid_amount + "<br />");
						} else {
							out.println("Must bid higher than $0.00 <br />");
						}
						
					} else {
						if (Double.parseDouble(bid_amount) >= ((Double.parseDouble(bid_price) + Double.parseDouble(bid_increment)))){
							String update = "INSERT INTO bids (mem_name, item_id, bid_amount, time) VALUES ('" + username + "','" + 
								item_id + "','" + Double.parseDouble(request.getParameter("bid_amount")) + "','" + 
								new Timestamp(System.currentTimeMillis()) + "');";
							int i = stmt.executeUpdate(update);
							String alert1 = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+prev_name+"','"+ new Timestamp(System.currentTimeMillis()) +
									"','"+username+" has bid "+bid_amount+"');";
							int a= stmt.executeUpdate(alert1);
							Double bidder_amount = Double.parseDouble(bid_amount) + Double.parseDouble(bid_increment);
							ResultSet result1 = stmt.executeQuery("SELECT * FROM bids WHERE (mem_name != '"+username+"' and max_bid >= '"
								+ bidder_amount +"' and item_id = '"+ item_id + "');");
							if (result1.next()){
								String bidder_name = result1.getString("mem_name");
								String bidder_max_bid = result1.getString("max_bid");
								String auto_bid = "INSERT INTO bids (mem_name, item_id, bid_amount, time, max_bid) VALUES ('" + bidder_name + "','" + 
										item_id + "','" + bidder_amount + "','" + 
										new Timestamp(System.currentTimeMillis()) + "','"+Double.parseDouble(bidder_max_bid)+"');";
								int j = stmt.executeUpdate(auto_bid);
								String alert = "INSERT INTO alerts (mem_name,alert_time, description) VALUES ('"+username+"','"+ new Timestamp(System.currentTimeMillis()) +
										"','"+bidder_name+" has bid "+bidder_amount+"');";
								int l = stmt.executeUpdate(alert);
							}
							out.println("Bid $" + bid_amount + "<br />");
						} else {
							out.println("Need to bid at least $" + (Double.parseDouble(bid_price) + Double.parseDouble(bid_increment)) + "<br />");
						}
					}
				}
				
			}
		}
		
		ResultSet result = stmt.executeQuery("SELECT * FROM auctions a, items i WHERE a.item_id = '" + item_id + "' AND a.item_id = i.item_id;");
		result.next();
		
		String seller_name = result.getString("mem_name");
		
		out.println("Item: " + result.getString("title") + "<br />");
		out.println("Description: " + result.getString("description") + "<br />");
		out.println("Seller: " + seller_name + "<br />");
		out.println("Auction End: " + result.getString("endDate") + "<br />");
		
	    Statement stmt4 = con.createStatement();
		ResultSet categoryResult = stmt4.executeQuery("SELECT * FROM category1 WHERE item_id = '" + item_id + "';");
		while(categoryResult.next()){
			out.println("Category: category1" + "<br/>");
			out.println("field1: " + categoryResult.getString("field1") + "<br/>");
			out.println("field2: " + categoryResult.getString("field2") + "<br/>");
		}
		categoryResult = stmt4.executeQuery("SELECT * FROM category2 WHERE item_id = '" + item_id + "';");
		while(categoryResult.next()){
			out.println("Category: category2" + "<br/>");
			out.println("field1: " + categoryResult.getString("field1") + "<br/>");
			out.println("field2: " + categoryResult.getString("field2") + "<br/>");
		}
		
		categoryResult = stmt4.executeQuery("SELECT * FROM category3 WHERE item_id = '" + item_id + "';");
		while(categoryResult.next()){
			out.println("Category: category3" + "<br/>");
			out.println("field1: " + categoryResult.getString("field1") + "<br/>");
			out.println("field2: " + categoryResult.getString("field2") + "<br/>");
		}
		String bid_increment = result.getString("bid_increment");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

        Date date = sdf.parse(result.getString("endDate"));
        Statement stmt2 = con.createStatement();
		ResultSet buyerResult = stmt2.executeQuery("Select * FROM buys where item_id = " + result.getString("item_id") +  ";");
		
		if(buyerResult.next()){
			if (buyerResult.getString("mem_name").equals(result.getString("mem_name"))){
				out.println("No bidder had met the minumum price." + "<br />");
			} else {
				out.println("Item purchased by: " + buyerResult.getString("mem_name") + " for $" + buyerResult.getString("price") + "<br />");
			}
			
		} else {
			Statement stmt3 = con.createStatement();
			ResultSet bidderResult = stmt3.executeQuery("SELECT * FROM bids WHERE item_id = '" + item_id + "' AND bid_amount = (SELECT MAX(bid_amount) FROM bids WHERE item_id = '" + item_id + "');");
			if(bidderResult.next()){
				String bid_price = bidderResult.getString("bid_amount");
				out.println("Current Bid: $" + bid_price + " ");
				out.println("Current Bidder: " + bidderResult.getString("mem_name") + "<br />");
			} else {
				out.println("Current Bid: No bids yet" + "<br />");
			}
			if (username.equals(seller_name)){
				out.println("You are currently listing this item.");
			} else {
				%>
				
				<form method="post" action="viewItem.jsp">
					<input type="number" name="bid_amount" step="0.01">
					<input name="button_clicked" type="submit" value="Bid"/>
					<label for="max_bid">Max Bid:</label>
					<input type="number" id="max_bid" name="max_bid"/>
					<input type="hidden" name="item_id" value=<%=item_id%> />
				</form>
				
				<%
				out.println("Minimum Bid Increment: $" + bid_increment + "<br />");
			}
		}
		
		
		
		
	} catch (Exception e){
		out.println(e);	
	}
	
	%>
	
	<form method="post" action="loginPage.jsp">
		<input name="return" type="submit" value="return to login page"/>
	</form>
	<form method="post" action="userLogin.jsp">
			<input name="button_clicked" type="submit" value="Return to Listings"/>
	</form>
	
</body>
</html>