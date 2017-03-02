<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");%>
<%  String msg="";
	String id=request.getParameter("id");
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false";
	String user="root";
	String pwd="2333";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		stmt.executeUpdate("delete from `登录用户` where 用户编号="+id+";");
		msg = "成功删除员工!";
		stmt.close(); 
		con.close();
	}catch(Exception e){
		msg = e.getMessage();
	}
	out.print(msg);
%>