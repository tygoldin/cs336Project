<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>FAQ</title>
</head>
<body>
<% try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
	%> 
	
	<%
   		String status = request.getParameter("button_clicked");
		
		ResultSet result = null;

		if(status!=null){
			if (status.equals("reply to question")){
				String qid = request.getParameter("question number");
				String r = request.getParameter("reply");
				String update = "update questions set reply='"+r+"' where qid=" + qid + ";";
				//Run the query against the database.
				try {
					int i = stmt.executeUpdate(update);
					out.println("Updated question "+qid+".");
				} catch (Exception e){
					out.println("Invalid question id.");
				}
				%> <br> <%
			}
		}

				out.println("Now Viewing previously asked questions.");
				%>
				
				<form method="post" action="loginPage.jsp">
				<input name="return" type="submit" value="return to Login page"/>
				</form>
				
				<form method="post" action="replies.jsp">
				<input name="button_clicked" type="submit" value="reply to question"/>
				<input type="text" name="question number" maxlength="10"/>
				<input type="text" name="reply" maxlength="200"/>
				</form>

				<ul>
				<%
				
				result = stmt.executeQuery("SELECT * FROM questions");
				
				while (result.next()){
					String qid = result.getString("qid");
					out.println(qid + " - " + result.getString("question"));
					%> <br> <%
					if(result.getString("reply")!=null){
						out.println(result.getString("reply"));
					} else {
						out.println("No reply yet.");
					}
					%> <br> <%
				}
				%>
				</ul>
	
	<%} catch (Exception e) {
			out.print(e);
	}%>
</body>
</html>