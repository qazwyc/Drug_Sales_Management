<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%><%
	request.setCharacterEncoding("utf-8");
	String msg ="";
    String user_name=(String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
    String type = request.getParameter("type"); //查询类型
    if(type==null || type=="") type="1";
	int types = Integer.parseInt(type);
	String mtypes[]= {"","",""};
	mtypes[types-1] = "selected";
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false"; 
%>
<!DOCTYPE HTML>
<html>
<head>
<title>入库记录</title>
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
 	<script>
		function select(){
			var type=document.getElementById("statistics_type");
			var index=type.selectedIndex;//所选下拉选框索引值
			window.location.href="Records.jsp?type="+(index+1);  
		}
	</script>
	<div>
		<select id="statistics_type" name="statistics_types" onchange="select()"> 
           <option value="入库" <%=mtypes[0] %>>入库</option>
           <option value="销售" <%=mtypes[1] %>>销售</option>
           <option value="退货" <%=mtypes[2] %>>退货</option>
    	</select>  	
	</div>
	<%if(types==1){ %>
  <div class="container">
	  <h1>入库记录</h1>  
	  <table>
	  	<tr>
	  		<td>入库记录编号</td>
	  		<td>供应商名称</td>
	  		<td>药品名称</td>
	  		<td>员工姓名</td>
			<td>入货数量</td>
			<td>入货日期</td>
			<td>总金额</td>
	  	</tr>
	  	<%
	  	try{
  	    	Class.forName("com.mysql.jdbc.Driver");
  	    	Connection con=DriverManager.getConnection(connectString,"root", "2333");
	      	Statement stmt=con.createStatement();
	      	//查看视图入库记录
  	    	ResultSet rs=stmt.executeQuery("select * from InDrug_records;");
        	while(rs.next()){ 
      	%>
	    	<tr>
	    	<td><%=rs.getString("入库记录编号")%></td>
	  	  	<td><%=rs.getString("供应商名称")%></td>
	  	  	<td><%=rs.getString("药品名称")%></td>
	  	  	<td><%=rs.getString("员工姓名")%></td>
	  	  	<td><%=rs.getString("数量")%></td>
	  	  	<td><%=rs.getString("日期")%></td>
	  	  	<td><%=rs.getString("总额")%></td>
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
  </div>
  <%}else if(types==2){ %>
    <div class="container">
	  <h1>销售记录</h1>  
	  <table>
	  	<tr>
	  		<td>销售记录编号</td>
	  		<td>客户姓名</td>
	  		<td>药品名称</td>
	  		<td>员工姓名</td>
			<td>销售数量</td>
			<td>销售日期</td>
			<td>总金额</td>
	  	</tr>
	  	<%
	  	try{
  	    	Class.forName("com.mysql.jdbc.Driver");
  	    	Connection con=DriverManager.getConnection(connectString,"root", "2333");
	      	Statement stmt=con.createStatement();
	      	//查看视图销售记录
  	    	ResultSet rs=stmt.executeQuery("select * from sales_records;");
        	while(rs.next()){ 
      	%>
	    	<tr>
	    	<td><%=rs.getString("销售编号")%></td>
	  	  	<td><%=rs.getString("客户姓名")%></td>
	  	  	<td><%=rs.getString("药品名称")%></td>
	  	  	<td><%=rs.getString("员工姓名")%></td>
	  	  	<td><%=rs.getString("数量")%></td>
	  	  	<td><%=rs.getString("日期")%></td>
	  	  	<td><%=rs.getString("总额")%></td>
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
	  </div>
	 <%}else if(types==3){ %>
	     <div class="container">
	  <h1>退货记录</h1>  
	  <table>
	  	<tr>
	  		<td>退货编号</td>
	  		<td>销售编号</td>
	  		<td>药品名称</td>
	  		<td>客户姓名</td>
	  		<td>员工姓名</td>
			<td>退货数量</td>
			<td>退货日期</td>
			<td>总金额</td>
	  	</tr>
	  	<%
	  	try{
  	    	Class.forName("com.mysql.jdbc.Driver");
  	    	Connection con=DriverManager.getConnection(connectString,"root", "2333");
	      	Statement stmt=con.createStatement();
	      	//查看视图退货记录
  	    	ResultSet rs=stmt.executeQuery("select * from reject_records;");
        	while(rs.next()){ 
      	%>
	    	<tr>
	    	<td><%=rs.getString("退货编号")%></td>
	  	  	<td><%=rs.getString("销售编号")%></td>
	  	  	<td><%=rs.getString("药品名称")%></td>
	  	  	<td><%=rs.getString("客户姓名")%></td>
	  	  	<td><%=rs.getString("员工姓名")%></td>
	  	  	<td><%=rs.getString("数量")%></td>
	  	  	<td><%=rs.getString("日期")%></td>
	  	  	<td><%=rs.getString("总额")%></td>
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
	  </div>
	  <%} %>
</body>
</html>

