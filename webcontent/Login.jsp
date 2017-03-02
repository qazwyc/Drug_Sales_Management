<%@ page language="java" import="java.util.*,java.sql.*,java.net.*"
contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>登录</title>
<style>
body{
  background-color:#2E2E2E;
  margin:0 40%;
}
.header{
  width:320px;
  margin-top:57%;
  margin-left:20%;
}
.middle{
  background-color:#FFFFFF;
  width:320px;
  height:150px;
  margin-top:10%;

}
h1{
  color:white;
  margin-left:35px; 
}
#user{
  float:left;
  margin-top:45px;
  margin-left:40px;
}
#psw{
  float:left;
  margin-top:20px;
  margin-left:40px;
}
#sub{
  float:right;
  margin-top:47px;
  margin-right:30px;
}
input{
  background-color:#EDEDED;
  box-shadow: 1px 1px 3px #cccccc;
}
</style>
</head>
<body>   
   <%StringBuilder table=new StringBuilder("");
    ResultSet rs = null;%>
   <% request.setCharacterEncoding("utf-8");
    String user = "";
    String psw = "";
    String psw1 = "";
    String msg = "";
    String type = "";
    String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
				+ "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8"
				+"&useSSL=true";
    if(request.getMethod().equalsIgnoreCase("post")){
    	try{   		
    		Class.forName("com.mysql.jdbc.Driver");
          	Connection con = DriverManager.getConnection(connectString,"root", "2333");
          	Statement stmt = con.createStatement();
    		user = request.getParameter("user");
          	psw = request.getParameter("psw");         	
          	if(user==""){
         		 msg="请输入您的用户名!";%>
         		<script>
              alert("请输入你的用户名!");
              </script>
         	 <%}
          	 else if(psw==""){
          		msg = "请输入你的密码!";%>
          		<script>
               alert("请输入你的密码!");
               </script>
          	 <%}
          	 else{          		
          		rs=stmt.executeQuery("select *  from 登录用户  where 用户名='"+user+"'"); 
              	if(!rs.next()){
         			 msg = "用户名不存在,请核查!";%>
         			 <script>
                   alert("用户名不存在!");
                   </script>
         		 <%}
              	else{             		
              		rs.beforeFirst();  //复位结果集
              		while(rs.next()){
                   		psw1 = rs.getString("密码");    
                   		type = rs.getString("类别");    
                   	 }              		
              		if(!psw1.equals(psw)){
            			 msg = "密码错误,请重新输入!";%>
            			 <script>
                       alert("密码错误,请重新输入!");
                      </script>
            		 <%}
            		 else{
            			 msg = "登录成功!";
     					 session.setAttribute("username", user);
     					 session.setAttribute("type", type);
            			 //使用servlet实现
            			 response.sendRedirect("HomePage.jsp");
            		 }
              	}             	
          	 }         	
    	}catch (Exception e){   	
    		
    	}
    }
    %>
    
    
    
   <div class="header">
   <h1>用户登录</h1>
   </div>
   <div class="middle">
   <form action="Login.jsp" method="post" name="f">
   <input id="user" name="user" type="text" placeholder="用户名" style="width:180px;"></p>   
   <input id ="sub" name="sub" type="submit" value="OK." style="width:50px;height:50px" /> 
   <input id="psw" name="psw" type="password" placeholder="登录密码" style="width:180px;"></p>
   </form>
   </div>
</body>
</html>