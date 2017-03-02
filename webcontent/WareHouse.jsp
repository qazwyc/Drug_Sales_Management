<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%><%
	request.setCharacterEncoding("utf-8");
	String msg ="";
    String user_name=(String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false"; 
%>
<!DOCTYPE HTML>
<html>
<head>
<title>仓库</title>
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
<style>
  .container{width:900px;margin:0 auto}
	h1 {text-align:center}
	table {border-collapse:collapse;text-align:center;margin:0 auto}
  table,td {border:solid 1px black;}
  td {height:25px;}
  p {text-align:center}
</style>
</head>
<body>
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
  <div class="container">
	  <h1>仓库</h1>  
	  <table>
	  	<tr>
	  		<td>药品编号</td>
	  		<td>药品名称</td>
	  		<td>供应商编号</td>
	  		<td>生产批号</td>
	  		<td>产地</td>
	  		<td>类别</td>
			<td>进价</td>
			<td>单价</td>
			<td>会员折扣</td>
			<td>库存</td>
			<td>包装规格</td>
			<td>生产日期</td>
			<td>有效期</td>
	  	</tr>
	  	<%
	  	try{
  	    	Class.forName("com.mysql.jdbc.Driver");
  	    	Connection con=DriverManager.getConnection(connectString,"root", "2333");
	      	Statement stmt=con.createStatement();
  	    	ResultSet rs=stmt.executeQuery("select * from warehouse;");
        	while(rs.next()){ 
      	%>
	    	<tr>
	    	<td><%=rs.getString("药品编号")%></td>
	    	<td><%=rs.getString("药品名称")%></td>
	  	  	<td><%=rs.getString("供应商名称")%></td>
	  	  	<td><%=rs.getString("生产批号")%></td>
	  	  	<td><%=rs.getString("产地")%></td>
	  	  	<td><%=rs.getString("所属类别")%></td>
	  	  	<td><%=rs.getString("进价")%></td>
	  	  	<td><%=rs.getString("单价")%></td>
	  	  	<td><%=rs.getString("会员折扣")%></td>
	  	  	<td><%=rs.getString("库存")%></td>
	  	  	<td><%=rs.getString("包装规格")%></td>
	  	  	<td><%=rs.getString("生产日期")%></td>
	  	  	<td><%=rs.getString("有效期")%></td>
	   	  	</tr>
	    <%}	    
	      rs.close();
  	      stmt.close();
	      con.close();
	    }
	    catch (Exception e){
	      msg = e.getMessage();
	    }
	  	%>
	  
	  </table>
	<br><br>
	 <div style="float:left">
          <a href='AddDrugs.jsp'>新增</a>
	</div>
  </div>
</body>
</html>

