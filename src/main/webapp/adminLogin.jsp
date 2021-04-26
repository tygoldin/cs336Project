<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Administrator Login</title>
</head>
<% try {
			
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

   		String status = request.getParameter("button_clicked");
   		ResultSet result=null;
		if(status!=null){
			if (status.equals("total earnings")){
				String create = "insert into reports (report_type) values ('total_earnings');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				
				result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b where a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				if (result.next() == false){
					out.println("Unable to calculate total earnings.");
					%><br><%
				} else {
					// Make sure Customer Representative is not deleting another rep or the admin
					String s = result.getString(1);
					String update="insert into total_earnings (report_id, value) values ('"+rid+"', '"+ s +"');";
					System.out.println(update);
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully added total earnings report.");
						%><br><%
						out.println("Total Earnings: ");
						out.println(s); 
					} catch (Exception e){
						out.println("Unable to generate total_earnings report. Please try again.");
					}
					%><br><%
				}
			} else if (status.equals("item")){
				String input = request.getParameter("report_input");
				String create = "insert into reports (report_type) values ('earnings_per_item');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b where a.item_id='"+input+"'and a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				if (result.next() == false){
					out.println("Unable to calculate total earnings.");
					%><br><%
				} else {
					// Make sure Customer Representative is not deleting another rep or the admin
					String s = result.getString(1);
					String update="insert into earnings_per (report_id, item_id, value) values ('"+rid+"', '"+ input +"', '"+ s +"');";
					System.out.println(update);
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully added earnings per item report.");
						%><br><%
						out.println("Earnings for item "+input+": ");
						out.println(s);
					} catch (Exception e){
						out.println("Unable to generate earnings per item report. Please try again.");
					}
					%><br><%
				}
			} else if (status.equals("item-type")){
				String input = request.getParameter("report_input");
				if(!(input.equals("1") || input.equals("2") || input.equals("3"))){
					out.println("Enter valid category: 1-3");
				} else {
				String create = "insert into reports (report_type) values ('earnings_per_item-type');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				if(input.equals("1")){
					result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b, category1 c where c.item_id=b.item_id and a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				} else if(input.equals("2")){
					result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b, category2 c where c.item_id=b.item_id and a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				} else if(input.equals("3")){
					result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b, category3 c where c.item_id=b.item_id and a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				}
				if (result.next() == false){
					out.println("Unable to calculate total earnings.");
					%><br><%
				} else {
					// Make sure Customer Representative is not deleting another rep or the admin
					String s = result.getString(1);
					String update="insert into earnings_per (report_id, item_type, value) values ('"+rid+"', '"+ input +"', '"+ s +"');";
					System.out.println(update);
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully added earnings per item report.");
						%><br><%
						out.println("Earnings for category "+input+": ");
						out.println(s);
					} catch (Exception e){
						out.println("Unable to generate earnings per item report. Please try again.");
					}
					%><br><%
				}}
			} else if (status.equals("end-user")){
				String input = request.getParameter("report_input");
				String create = "insert into reports (report_type) values ('earnings_per_end-user');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				result = stmt.executeQuery("SELECT sum(b.bid_amount) FROM auctions a, bids b where a.mem_name='"+input+"'and a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				if (result.next() == false){
					out.println("Unable to calculate earnings per end-user.");
					%><br><%
				} else {
					// Make sure Customer Representative is not deleting another rep or the admin
					String s = result.getString(1);
					String update="insert into earnings_per (report_id, end_user, value) values ('"+rid+"', '"+ input +"', '"+ s +"');";
					System.out.println(update);
					//Run the query against the database.
					try {
						int i = stmt.executeUpdate(update);
						out.println("Successfully added earnings per end-user.");
						%><br><%
						out.println("Earnings for "+input+": ");
						out.println(s);
					} catch (Exception e){
						out.println("Unable to generate earnings per end-user report. Please try again.");
					}
					%><br><%
				}
			} else if (status.equals("best-selling items")){
				String input = request.getParameter("report_input");
				String create = "insert into reports (report_type) values ('best-selling items');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				result = stmt.executeQuery("SELECT * FROM auctions a, bids b where a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id);");
				ArrayList<String[]> items = new ArrayList<String[]>();
				while(result.next()!=false){
					String[] s = {result.getString("item_id"), result.getString("bid_amount")};
					items.add(s);
				}
				Collections.sort(items,new Comparator<String[]>() {
		            public int compare(String[] strings, String[] otherStrings) {
		            	return otherStrings[1].compareTo(strings[1]);
		            }
		        });
				String type1="N/A", type2="N/A", type3="N/A", value1="0", value2="0", value3="0";
				//System.out.println(items.size());
				if(items.size()>=1){
					type1=items.get(0)[0];
					value1=items.get(0)[1];
				}
				if(items.size()>=2){
					type2=items.get(1)[0];
					value2=items.get(1)[1];
				}
				if(items.size()>=3){
					type3=items.get(2)[0];
					value3=items.get(2)[1];
				}
				String update="insert into best_selling (report_id, item_or_user, type1, type2, type3, value1, value2, value3) values ('"+rid+"', 'item', '"+ type1 +"', '"+ type2 +"', '"+ type3 +"', '"+ value1 +"', '"+ value2 +"', '"+ value3 +"');";
				System.out.println(update);
				
				try {
					int i = stmt.executeUpdate(update);
					out.println("Successfully added best-selling items report.");
					%><br><%
					out.println("Top 3 Items:");
					%><br><%
					out.println(type1 + " - " + value1);%><br><%
					out.println(type2 + " - " + value2);%><br><%
					out.println(type3 + " - " + value3);
				} catch (Exception e){
					out.println("Unable to generate best-selling items report. Please try again.");
				}
				%><br><%
			} else if (status.equals("best buyers")){
				String input = request.getParameter("report_input");
				String create = "insert into reports (report_type) values ('best-selling items');";
				try {
					int i = stmt.executeUpdate(create);
					//System.out.println("Successfully created report.");
				} catch (Exception e){
					System.out.println("Creating report failed. Please try again.");
				}
				
				ResultSet get_id = stmt.executeQuery("select max(report_id) from reports;");
				String rid = "";
				if(get_id.next()){
					rid = get_id.getString(1);
					System.out.println(rid);
				} else {
					System.out.println("Unable to get rid");
				}
				result = stmt.executeQuery("SELECT sum(b.bid_amount) as price, b.mem_name FROM auctions a, bids b where a.endDate<'" + new Timestamp(System.currentTimeMillis()) + "' and a.item_id=b.item_id and b.bid_amount>=(select max(bid_amount) from bids c where c.item_id=a.item_id) group by b.mem_name;");
				ArrayList<String[]> items = new ArrayList<String[]>();
				while(result.next()!=false){
					//System.out.println(result.getString(0));
					String[] s = {result.getString("mem_name"), result.getString("price")};
					items.add(s);
				}
				Collections.sort(items,new Comparator<String[]>() {
		            public int compare(String[] strings, String[] otherStrings) {
		                return otherStrings[1].compareTo(strings[1]);
		            }
		        });
				String type1="N/A", type2="N/A", type3="N/A", value1="0", value2="0", value3="0";
				if(items.size()>=1){
					type1=items.get(0)[0];
					value1=items.get(0)[1];
				}
				if(items.size()>=2){
					type2=items.get(1)[0];
					value2=items.get(1)[1];
				}
				if(items.size()>=3){
					type3=items.get(2)[0];
					value3=items.get(2)[1];
				}
				String update="insert into best_selling (report_id, item_or_user, type1, type2, type3, value1, value2, value3) values ('"+rid+"', 'user', '"+ type1 +"', '"+ type2 +"', '"+ type3 +"', '"+ value1 +"', '"+ value2 +"', '"+ value3 +"');";
				System.out.println(update);
				
				try {
					int i = stmt.executeUpdate(update);
					out.println("Successfully added earnings per end-user.");
					%><br><%
					out.println("Top 3 Buyers:");
					%><br><%
					out.println(type1 + " - " + value1);%><br><%
					out.println(type2 + " - " + value2);%><br><%
					out.println(type3 + " - " + value3);
				} catch (Exception e){
					out.println("Unable to generate earnings per end-user report. Please try again.");
				}
				%><br><%
			}
		}
}
catch(Exception e){
	out.print(e);
}%>
<body>
Administrator Login
<br>
	<form method="post" action="loginPage.jsp">
		<input name="return" type="submit" value="return to login page"/>
	</form>
	<br><br>
	Create Customer Representative:
	<br>
	<form method="post" action="newRep.jsp">
		Username
		<input type="text" name="rep_name" maxlength="50"/>
		<br>
		Password
		<input type="password" name="rep_password" maxlength="50"/>
		<br>
		<input name="create_rep" type="submit" value="register representative"/>	
	</form>
	<br>
	Generate Report:
	<br>
	<form method="post" action="adminLogin.jsp">
		Input
		<input type="text" name="report_input" maxlength="50"/>
		<br>
		<input name="button_clicked" type="submit" value="total earnings"/>	
		<input name="button_clicked" type="submit" value="best-selling items"/>
		<input name="button_clicked" type="submit" value="best buyers"/>
		<br>
		Earnings Per: 
		<input name="button_clicked" type="submit" value="item"/>
		<input name="button_clicked" type="submit" value="item-type"/>
		<input name="button_clicked" type="submit" value="end-user"/>
	</form>
</body>
</html>