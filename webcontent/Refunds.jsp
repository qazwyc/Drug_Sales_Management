<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>退货</title>
<style>
h1{text-align:center}
table, td {border:solid 1px black}
table {border-collapse:collapse;text-align:center;margin:0 auto;width: 600px;}
td {height:30px}
td{width:100px}
</style>
</head>
<style>
body{
      margin:0 15%;
}
#container {
      width: 70em;   
      margin:0 auto;
      margin-bottom:40px;
}
#box0 {
      position: relative;
      text-align: center;
      height: 4em;
      background:url(https://github.com/14353032/ES2016_14353032/blob/master/db.png?raw=true);
}
#menu {
      background: #E7E7E7;
      height:50px;
      z-index: 1;
}
#menu >li{
      width:auto 0;
      margin-left:80px;
      position:relative;
      margin-top:15px;
      display: inline-block; 	     
}
#menu>li:hover{
	  background-color:blue;
      box-shadow:2px 0px 5px gray,-2px 0px 5px gray;
	  box-sizing:border-box;
}	
#menu>a{
      color:#000000;
} 
#menu>li:hover>a{
	  color:white;
}
</style>  
<body>
<h1>销售记录</h1>
 <%StringBuilder table=new StringBuilder("");
    ResultSet rs = null;%>
    <% request.setCharacterEncoding("utf-8");
    String user_name=(String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
    String customer_id=request.getParameter("customer_id");
    String sell_id=request.getParameter("sell_id");
    String msg="";
    String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8"
			+"&useSSL=true";
    Class.forName("com.mysql.jdbc.Driver");
  	Connection con = DriverManager.getConnection(connectString,"root", "2333");
  	Statement stmt = con.createStatement();
  	try{
  		//查看视图销售记录
  		rs=stmt.executeQuery("select * from sales_records where 销售编号="+sell_id);
  	}catch (Exception e){
  		
  	}
    %>
       <div class="header">
   <%if(user_type==1){%>
   <div id="container">
        <div id="box0">
        </div>
        <span> 员工: <%= user_name %>
            <a href="logout.jsp">注销</a></span>
        <ul id="menu">
        	<li><a href="HomePage.jsp">主页</a></li>
            <li><a href="WareHouse.jsp">仓库</a></li>
            <li><a href="Records.jsp">入库/销售/退货记录</a></li>
            <li><a href="MemberManage.jsp">客户/供应商</a></li>
            <li><a href="MySetting.jsp">个人设置</a></li>  
        </ul>
    </div>
    <%}else{%>
   <div id="container">
        <div id="box0">
        </div>
        <span> 经理: <%= user_name %>
        <a href="logout.jsp">注销</a></span>
        <ul id="menu">
        	<li><a href="HomePage.jsp">主页</a></li>
            <li><a href="WareHouse.jsp">仓库</a></li>
            <li><a href="Records.jsp">入库/销售/退货记录</a></li>
            <li><a href="MemberManage.jsp">客户/供应商/员工</a></li>
            <li><a href="MySetting.jsp">个人设置</a></li>
            <li><a href="Financial_Statistics.jsp">财务统计</a></li>
        </ul>
    </div>
	<%}%> 
   </div>
   <table>
      <tr>
      <td>销售编号</td><td>药品编号</td><td>员工编号</td><td>客户编号</td><td>销售日期</td><td>销售数量</td><td>总价</td><td>---</td>
      </tr>
       <%while(rs.next()){%>
        <tr>
        <td><%=rs.getString("销售编号")%></td>
        <td><%=rs.getString("药品名称")%></td>
        <td><%=rs.getString("员工姓名")%></td>
        <td><%=rs.getString("客户姓名")%></td>
        <td><%=rs.getString("日期")%></td>
        <td><%=rs.getString("数量")%></td>
        <td><%=rs.getString("总额")%></td>
        <td><a href="RefundsDetail.jsp?sell_id=<%=sell_id%>">退货</a> 
        </td>
        </tr>
        <%}%>
   </table>      
</body>
</html>