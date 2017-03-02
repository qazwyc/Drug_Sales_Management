<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");%>
<%  String msg="";
	String name=request.getParameter("name");
	String phone=request.getParameter("phone");
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false";
	String user="root";
	String pwd="2333";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, user, pwd);
		Statement stmt=con.createStatement();
		stmt.executeUpdate("insert into `会员`(客户姓名,联系方式)values('"+name+"','"+phone+"');");
		msg = "成功添加会员!";
		stmt.close(); 
		con.close();
	}catch(Exception e){
		msg = e.getMessage();
	}
	out.print(msg);
%>