<%@ page language="java" import="java.util.*,java.sql.*,java.net.*"
contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>主页</title>
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
input[type="submit"] {
	-webkit-appearance: none;
}
.btn {
  cursor: pointer;
  background-color:transparent;
  margin-top: 20px;
  font-size: 20px;
  display: inline-block;
  padding: 15px 30px;
  border: 2px solid #f76d02;
  text-transform: uppercase;
  letter-spacing: 0.015em;
  font-weight: 700;
  line-height: 1;
  width: 100%;
  color: black;
  text-decoration: none;
  -webkit-transition: all 0.4s;
     -moz-transition: all 0.4s;
       -o-transition: all 0.4s;
          transition: all 0.4s;
}
.btn:hover {
  color: #f76d02;
  border-color: #f76d02;
}

.main {
  width: 300px;
  border-radius: 2px;
  margin: 0 auto;
}

.group-input {
  position: relative;
  width: 257px;
}

input[type="text"],input[type="password"]{
  padding:20px;
  width: 100%;
  font-family: "myFont";
}

#index-login {
  font-family: "myFont";
  width: 100%;
  cursor:pointer;
  font-size: 20px;
  display: inline-block;
  padding: 15px 30px;
  border:none;
  background: #f76d02;
  text-transform: uppercase;
  letter-spacing: 0.015em;
  font-weight: 700;
  line-height: 1;
  color: black;
  text-decoration: none;
  -webkit-transition: all 0.7s;
     -moz-transition: all 0.7s;
       -o-transition: all 0.7s;
          transition: all 0.7s;
}

input {
  font-size: 20px;
}

#index-signup {
  font-family: "myFont";
  width: 100%;
  cursor:pointer;
  font-size: 20px;
  display: inline-block;
  padding: 15px 30px;
  border:none;
  background: rgba(0,0,0,0);
  text-transform: uppercase;
  letter-spacing: 0.015em;
  font-weight: 700;
  line-height: 1;
  color: black;
  text-decoration: none;
  -webkit-transition: all 0.7s;
     -moz-transition: all 0.7s;
       -o-transition: all 0.7s;
          transition: all 0.7s;
}

.login-nav {
  display: inline-block;
  float: left;
  width: 50%;
}

.signup-nav {
  display: inline-block;
  width: 50%;
}

.index-nav {
  text-align: left;
  border: 1px solid white;
}
                        
</style>
</head>
<body>   
   <%StringBuilder table=new StringBuilder("");
    ResultSet rs = null;%>
    <script>
    function clicklog(id) {
    	var bnt1 = document.getElementById(id);
    	var bnt2 = document.getElementById('index-signup');
    	bnt1.className = "activate";
    	bnt2.className = '';

    	bnt1.style.background = "#f76d02";
    	bnt2.style.background = "rgba(0,0,0,0)";

    	document.getElementById('login-form').style.display = 'block';
    	document.getElementById('signup-form').style.display = 'none';

    }

    function clicksign(id) {
    	var bnt1 = document.getElementById(id);
    	var bnt2 = document.getElementById('index-login');
    	bnt1.className = "activate";
    	bnt2.className = '';
    	bnt1.style.background = "#f76d02";
    	bnt2.style.background = "rgba(0,0,0,0)";

    	document.getElementById('login-form').style.display = 'none';
    	document.getElementById('signup-form').style.display = 'block';
    }
    </script>
   <% request.setCharacterEncoding("utf-8");
    String username1 = "";
    String user_name = (String)session.getAttribute("username");
    String user_type = (String)session.getAttribute("type");
    String username2 = "";
    String psw1 = "";
    String psw2 = "";
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
          	if(request.getParameter("sub1") == null){   //退货
          		psw2 = request.getParameter("password2");
          		if(psw2==""){
               		msg = "请输入销售编号!";%>
               		<script>
                    alert("请输入销售编号!");
                    </script>
               	 <%}
          		else{
          			rs=stmt.executeQuery("select *  from 销售管理  where 销售编号="+psw2);
          			if(!rs.next()){
             			 msg = "无此销售记录,请重新查询!";%>
             			 <script>
                       alert("无此销售记录,请重新查询!");
                       </script>
             		 <%}
          			else{
          			//使用servlet实现
             	    response.sendRedirect("Refunds.jsp?sell_id="+psw2);
          			}
          		}
           	 }
          	else{  //销售
          		username1 = request.getParameter("username1");
          		if(username1==""){
             		username1=null;
             	}
             	response.sendRedirect("Sell.jsp?customer_id="+username1);
          	}
    	}catch (Exception e){
    		msg="输入错误,请重新输入!";
    	}
    }
    %>
    
    
    <p><%=msg%></p>
   <div class="header">
   <%if(user_type.equals("1")){ // 权限判断 %>
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
   </div>
      <div class="main">
   <div class="index-nav">
      <div class="login-nav"> <input type="button" value="销售" id="index-login" onclick="clicklog(this.id)"> </div>
      <div class="signup-nav"> <input type="button" value="退货" id="index-signup" onclick="clicksign(this.id)"> </div>     
    </div> 
    <form action="HomePage.jsp"  method="post" id="login-form">
	   <input type="hidden" name="formtype" value="login"/>
       <div class="group-input">
        <div id="account-input"> <input type="text" id="username1" name="username1" placeholder="客户编号"> </div>
       </div>
       <input id="sub1" name="sub1" type="submit" class="btn" value="查询" />
      </form>
      <form action="HomePage.jsp"  method="post" id="signup-form"  style="display: none">
        <input type="hidden" name="formtype" value="signup"/>
        <div class="group-input">
          <div id="password-sign-input"> <input type="text" id="password2" name="password2" placeholder="销售编号"> </div>  
        </div>
        <input id="sub2" name="sub2" type="submit" class="btn" value="查询"/>
      </form>
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
    </div>
	<%}%> 
</body>
</html>