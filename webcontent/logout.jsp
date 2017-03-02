<%@ page contentType="text/html" language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
   response.setHeader("refresh","3;URL=Login.jsp");
   session.invalidate();
%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>注销</title>
<style type="text/css">
	div{width:400px; margin:0 auto;}
</style>
</head>
  <body>
  	<div>
  	 <p>你已经成功退出本系统,3秒后会跳转到登陆页面</p>
     <p>如果没有跳转请点击<a href="Login.jsp">这里</a></p>
  	</div>
  </body>
</html>