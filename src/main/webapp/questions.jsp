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
		boolean sorting = false;
		String[] keywords = null;
		if(status!=null){
			if (status.equals("post question")){
				String q = request.getParameter("question");
				String update = "INSERT INTO questions (question) VALUES ('" + q + "');";
				//Run the query against the database.
				try {
					int i = stmt.executeUpdate(update);
					out.println("Added new question.");
				} catch (Exception e){
					out.println("Failed to add question.");
				}
				%> <br> <%
			} else if (status.equals("sort questions")){
				sorting = true;
				keywords = request.getParameter("sort").trim().split("\\s+");
			}
		}

		out.println("Now Viewing previously asked questions.");
		%>
				
		<form method="post" action="loginPage.jsp">
		<input name="return" type="submit" value="return to Login page"/>
		</form>
				
		<form method="post" action="questions.jsp">
		<input name="button_clicked" type="submit" value="post question"/>
		<input type="text" name="question" maxlength="200"/>
		</form>
		
		<form method="post" action="questions.jsp">
		<input name="button_clicked" type="submit" value="sort questions"/>
		<input type="text" name="sort" maxlength="200"/>
		</form>

		<ul>
		<%
				
		result = stmt.executeQuery("SELECT * FROM questions");
				
		while (result.next()){
			if(sorting){
				boolean skip = true;
				for(int i = 0; i<keywords.length; i++){
					if (result.getString("question").contains(keywords[i])) skip = false;
					if(result.getString("reply")!=null){
						if (result.getString("reply").contains(keywords[i])) skip = false;
					}
				}
				if(skip) continue;
			}
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