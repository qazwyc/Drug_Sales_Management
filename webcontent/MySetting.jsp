<%@ page language="java" import="java.util.*,java.lang.*,java.sql.*,java.net.*"  contentType="text/html; charset=gb2312"
    pageEncoding="utf-8"%>
<%  request.setCharacterEncoding("utf-8");
    response.setContentType("text/html; charset=utf-8");
    String user_name="";
	user_name = (String)session.getAttribute("username");
	if(user_name==null||user_name.equals("")){
		user_name="张三";
	}
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
	String pwd="";
	String phone="";
	int user_id = 0;
	int employee_id = 0;
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "root", "2333");
	  Statement stmt=con.createStatement();	
	  ResultSet rs=stmt.executeQuery("select `登录用户`.用户编号,员工编号,密码,联系电话 from `登录用户` natural join `员工` where 用户名='"+user_name+"';");
	  if(rs.next()){
	     user_id = rs.getInt("用户编号");
		 pwd = rs.getString("密码");
		 if(user_type==1){  //员工有联系电话
			 phone = rs.getString("联系电话")==null?"":rs.getString("联系电话");
			 employee_id = rs.getInt("员工编号"); 
		 }
	  }
	  rs.close();
	  if(request.getMethod().toUpperCase().equals("POST")){
		String username=request.getParameter("user_name");
		String pwd1=request.getParameter("pwd")==null||request.getParameter("pwd")==""?pwd:request.getParameter("pwd");
		String phone1=request.getParameter("phone")==null||request.getParameter("phone")==""?phone:request.getParameter("phone");
		if(username==null || username==""){
			out.print("<script type='text/javascript'>alert('请输入用户名')</script>");
		}else{
			ResultSet rs1=stmt.executeQuery("select * from `登录用户` where 用户名='"+username+"';");
			if(!username.equals(user_name) && rs1.next()){
				out.print("<script type='text/javascript'>alert('用户名已被占用')</script>");
			}
			else{
				//更新个人信息（员工、经理）
				if(user_type == 1){
				  	stmt.executeUpdate(String.format("UPDATE `员工` SET `联系电话`='%s' WHERE `员工编号`='%d';",
				  			phone1,employee_id));
				}
				Statement stmt1=con.createStatement();
				stmt1.executeUpdate(String.format("UPDATE `登录用户` SET `用户名`='%s',`密码`='%s' WHERE `用户编号`='%d';",
			  			username,pwd1,user_id));
				//session.setAttribute("username", username);
				response.sendRedirect("MySetting.jsp");
			}
			rs1.close();
		}
	}
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
	function test(which){
		switch(which){
			case 0: 		
				var username=document.getElementById('user_name').value;
				var tint=document.getElementById('usernameTint')
				if(username.length<=0){
					tint.style.color="red";
					tint.innerText="用户名不能为空";
					document.getElementById("sub").setAttribute("disabled",true);
				}else{
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}
				break;
			case 1: 		
				var password=document.getElementById('pwd').value;
				var tint=document.getElementById('pwdTint')
				if(password != null && password!="" && (password.length<=0)){
					tint.style.color="red";
					tint.innerText="密码不得为空";
					document.getElementById("sub").setAttribute("disabled",true);
				}else{
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}
				break;
			case 2: 		
				var password=document.getElementById('pwd').value;
			    var repassword=document.getElementById('repwd').value;
				var tint=document.getElementById('repwdTint');
				if(repassword==password){
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}else{
					tint.style.color="red";
					tint.innerText="两次输入密码不一致";
					document.getElementById("sub").setAttribute("disabled",true);
				}				
				break;
			case 3: 		
				var phone=document.getElementById('phone').value;
				var tint=document.getElementById('phoneTint');
				if(phone=="" || (/^1[34578]\d{9}$/.test(phone))){
					tint.innerText="";
					tint.style.color='gray';
					document.getElementById("sub").removeAttribute("disabled");
				}else{
					tint.style.color="red";
					tint.innerText="手机格式不正确";
					document.getElementById("sub").setAttribute("disabled",true);
				}				
				break;
			default: break;
		}
	}
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
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
<title>个人设置</title>
	<style >
		html body, html input, html textarea, html select, html button {
			font-family: '.SFNSText-Regular', 'Helvetica Neue', Helvetica, Arial, "Hiragino Sans GB", "Microsoft YaHei", "WenQuanYi Micro Hei", sans-serif;
			text-rendering: optimizeLegibility;
		}
		body{
			margin: 0 0;
			background: #D1EEEE;
		}
		a{
			text-decoration:none;
			color:black;
		}
		#content{width:760px;padding:20px 20px 0 20px;margin:20px auto;border-radius: 5px;box-sizing: border-box;background:white;box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;}
		.rfm{margin:20px auto;width:760px;border-bottom:1px dotted #CDCDCD;}
		.rfm th,.rfm td{padding:10px 2px;vertical-align:top;line-height:24px;}
		.rfm th{padding-right:10px;width:13em;text-align:right;}
		.rfm .px{width:220px;}
		.rq{color:red;}
		.pnc{border-color:#235994;background-color:#06C;background-position:0 -48px;color:#FFF !important;}
		.pnc:active{background-position:0 -71px;}
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
<div id="content">
<form method="post"  class="cl">
<div class="rfm">
<table>
<tr>
<th>用户名:</th>
<td><input id="user_name" type="text"  name="user_name" class="px" 
	onblur="test(0)" value=<%=user_name%> >
 <label id="usernameTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>新密码:</th>
<td><input id="pwd" type="password"  name="pwd"  class="px" 
	onfocus="document.getElementById('pwdTint').innerText='请输入新密码';"
	onblur="test(1)"  value="">
<label id="pwdTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<div class="rfm">
<table>
<tr>
<th>确认密码:</th>
<td><input id="repwd" type="password"  name="repwd" class="px"
	onfocus="document.getElementById('repwdTint').innerText='请确认密码';"
	onblur="test(2)"  value="">
<label id="repwdTint" style="color:gray;"></label></td>
</tr>
</table>
</div>

<% if(user_type==1){%>
<div class="rfm">
<table>
<tr>
<th>联系方式:</th>
<td><input id="phone" type="text"  name="phone" class="px" 
	onfocus="document.getElementById('phoneTint').innerText='请输入11位手机号码';"
	onblur="test(3)" value="<%=phone%>">
<label id="phoneTint" style="color:gray;"></label></td>
</tr>
</table>
</div>
<%} %>
<div class="rfm">
<table width="100%">
<tr>
<th>&nbsp;</th>
<td>
<span>
<em>&nbsp;</em><button id="sub" class="pnc"  type="submit" value="true" name="sub"><strong>提交</strong></button>
</span>

</td>
</tr>
</table>
</div>
</form>
</div>
</body>
</html>