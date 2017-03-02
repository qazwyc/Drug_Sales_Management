<%@ page language="java" import="java.util.*,java.sql.*"
contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>药品查询</title>
<style>
.middle{
  margin:0 35%;
  width:50em;
}
h1{
  margin-left:120px;
}
form{
  padding:20px;
}
.tail{
  margin-top:50px;
}
.tail h1{
  text-align:center;
  margin:0 42%;
  width: 200px;
}
table, td {border:solid 1px black}
table {border-collapse:collapse;text-align:center;margin:0 auto;width: 1000px;}
td {height:30px}
td{width:100px}
</style>
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
</head>
<body>
 <%StringBuilder table=new StringBuilder("");
    ResultSet rs = null;%>
    <% request.setCharacterEncoding("utf-8");
    String user_name=(String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
    String customer_id=request.getParameter("customer_id");
    String msg="";
    String number="";
    String name="";
    String type=""; 
    String pnumber="";
    String pname="";
    String ptype="";
    String result="";
    boolean login = false;
    String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8"
			+"&useSSL=true";
    Class.forName("com.mysql.jdbc.Driver");
  	Connection con = DriverManager.getConnection(connectString,"root", "2333");
  	Statement stmt = con.createStatement();
  	if(request.getMethod().equalsIgnoreCase("post")){
  		try{
  			if(request.getParameter("sub1") != null){
  				msg="1";
  				number = request.getParameter("number");
  				pnumber=number;
  				if(number=="")
  				{
  					msg="请输入药品编号!";%>
  		     		<script>
  		            alert("请输入药品编号!");
  		          </script><%
  				}
  				else{
  					//根据药品编号查询药品
  					rs=stmt.executeQuery("select * from 药品  where 药品编号='"+number+"'");
  	      			if(!rs.next()){
  	         			 msg = "无此药品编号,请重新查询!";%>
  	         			 <script>
  	                   alert("无此药品编号,请重新查询!");
  	                   </script>
  	         		 <%}
  	      			else{
  	      			    rs.beforeFirst();  //复位结果集
  	      			    result="1";
  	      			}
  				}  				
  			}
  			else if(request.getParameter("sub2") != null){
  				msg="2";
  				name = request.getParameter("name");
  				pname=name;
  				if(name=="")
  				{
  					msg="请输入药品名称!";%>
  		     		<script>
  		            alert("请输入药品名称!");
  		          </script><%
  				}
  				else{
  					//根据药品名称查询药品
  					rs=stmt.executeQuery("select * from 药品  where 药品名称  like '%"+name+"%'");
  	      			if(!rs.next()){
  	         			 msg = "无此药品名称,请重新查询!";%>
  	         			 <script>
  	                   alert("无此药品名称,请重新查询!");
  	                   </script>
  	         		 <%}
  	      			else{
  	      			   rs.beforeFirst();  //复位结果集
  	      			   result="1";
  	      			}
  				}
  			}
  			else
  			{
  				msg="3";
  				type = request.getParameter("type");
  				ptype = type;
  				if(type=="")
  				{
  					msg="请输入药品类别!";%>
  		     		<script>
  		            alert("请输入药品类别!");
  		          </script><%
  				}
  				else{
  					//根据药品类别查询药品
  					rs=stmt.executeQuery("select * from 药品  where 所属类别  like '%"+type+"%'");
  	      			if(!rs.next()){
  	         			 msg = "无此药品类别,请重新查询!";%>
  	         			 <script>
  	                   alert("无此药品类别,请重新查询!");
  	                   </script>
  	         		 <%}
  	      			else{
  	      			    rs.beforeFirst();  //复位结果集
  	      			    result="1";
  	      			    
  	      			}
  				}
  			}
  	    }catch (Exception e){
  			msg="输入错误,请重新输入!";
  		}
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
<div class="middle">
	<h1>药品查询</h1> 
	<div>
		<form  method="post">
			药品编号:<input class="number" name="number" type="text" style="width:180px;height:23px" value="<%=pnumber%>"/>
			<input id="sub1" name="sub1" type="submit" class="btn" value="按药品编号查询"/>
		</form>
		<form  method="post">
			药品名称:<input class="name" name="name" type="text" style="width:180px;height:23px" value="<%=pname%>"/>
			<input id="sub2" name="sub2" type="submit" class="btn" value="按药品名称查询"/>
		</form>
		<form  method="post">
			药品类别:<input class="type" name="type" type="text" style="width:180px;height:23px" value="<%=ptype%>"/>
			<input id="sub3" name="sub3" type="submit" class="btn" value="按药品类别查询"/>
		</form>
	</div>
</div>
<%if(result.equals("1")){%>
<div class="tail">
<h1>查询结果</h1>
<table>    
      <tr>
      <td>药品编号</td><td>药品名称</td><td>生产批号</td><td>产地</td><td>所属类别</td><td>单价</td><td>会员折扣</td><td>库存</td><td>包装规格</td><td>生产日期</td><td>有效期</td><td>---</td>
      </tr>
       <%while(rs.next()){%>
        <tr>
        <td><%=rs.getString("药品编号")%></td>
        <td><%=rs.getString("药品名称")%></td>
        <td><%=rs.getString("生产批号")%></td>
        <td><%=rs.getString("产地")%></td>
        <td><%=rs.getString("所属类别")%></td>
        <td><%=rs.getString("单价")%></td>
        <td><%=rs.getString("会员折扣")%></td>
        <td><%=rs.getString("库存")%></td>
        <td><%=rs.getString("包装规格")%></td>
        <td><%=rs.getString("生产日期")%></td>
        <td><%=rs.getString("有效期")%></td>
        <td><a href="SellDetail.jsp?customer_id=<%=customer_id %>&drug_id=<%=rs.getString("药品编号")%>">购买</a> 
        </td>
        </tr>
        <%}%>
</table>
</div>  
<%}%>
</body>
</html>