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
	public String readAlerts(String mem_name)
	{
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			String alert_return = "";
			
			ResultSet result = stmt.executeQuery("SELECT * FROM alerts WHERE mem_name = '" + mem_name + "' and alerts.read = 0;");
			while (result.next()){
				alert_return = alert_return + "alert: " + result.getString("description") + "</br>";
			}
			String update = "UPDATE alerts SET alerts.read = 1 WHERE mem_name = '" + mem_name + "';";
			int i = stmt.executeUpdate(update);
			return alert_return;
		} catch (Exception e){
			return "No alerts found";
		}
	}
	%>
</body>
</html>