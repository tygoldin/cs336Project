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

	<%!
	public String checkAuctions()
	{
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			Statement stmt2 = con.createStatement();
			String item_return = "";
			
			ResultSet result = stmt.executeQuery("SELECT * FROM auctions LEFT OUTER JOIN buys ON auctions.item_id = buys.item_id WHERE buys.item_id IS NULL AND '" + new Timestamp(System.currentTimeMillis()) + "' >= auctions.endDate;");
			while (result.next()){
				ResultSet bidderResult = stmt2.executeQuery("SELECT * FROM bids WHERE item_id = " + result.getString("item_id") + " and bid_amount in (select MAX(bid_amount) from bids);");
				if (bidderResult.next()){
					do {
						String mem_name = bidderResult.getString("mem_name");
						String bid_amount = bidderResult.getString("bid_amount");
						String min_price = result.getString("min_price");
						String item_id = result.getString("item_id");
						if (Double.parseDouble(bid_amount) >= Double.parseDouble(min_price)){
							Statement stmt3 = con.createStatement();
							String update = "INSERT INTO buys(mem_name,item_id,price) VALUES ('"+ mem_name + "'," + item_id + ",'" + bid_amount + "');";
							int i = stmt3.executeUpdate(update);
							update = "INSERT INTO alerts(mem_name, alert_time, description) VALUES ('"+ mem_name+"','"+ new Timestamp(System.currentTimeMillis()) + "','"+ "You have won the auction for " + item_id + "');";
							i = stmt3.executeUpdate(update);
							
						} else {
							Statement stmt3 = con.createStatement();
							String update = "INSERT INTO buys(mem_name,item_id,price) VALUES ('"+ result.getString("mem_name") + "'," + item_id + ", '0');";
							int i = stmt3.executeUpdate(update);
							update = "INSERT INTO alerts(mem_name, alert_time, description) VALUES ('"+ result.getString("mem_name") +"','"+ new Timestamp(System.currentTimeMillis()) + "','"+ "No one had bought your item: " + item_id + "');";
							i = stmt3.executeUpdate(update);
						}
					} while (bidderResult.next());
				} else {
					Statement stmt3 = con.createStatement();
					String update = "INSERT INTO buys(mem_name,item_id,price) VALUES ('"+ result.getString("mem_name") + "'," + result.getString("item_id") + ", '0');";
					int i = stmt3.executeUpdate(update);
					update = "INSERT INTO alerts(mem_name, alert_time, description) VALUES ('"+ result.getString("mem_name") +"','"+ new Timestamp(System.currentTimeMillis()) + "','"+ "No one had bought your item: " + result.getString("item_id") + "');";
					i = stmt3.executeUpdate(update);
				}
				while (bidderResult.next()){
					
				}
				
			}
			return item_return;
		} catch (Exception e){
			return "true";
		}
	}
	%>
</body>
</html>