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
    String type = request.getParameter("member_type");
    if(type==null || type=="") type="1";
	int member_type = Integer.parseInt(type);
	
	String member_types[]= {"","",""};
	member_types[member_type-1] = "selected";
    //分页
    Integer pgno = 0; //当前页号
    String param = request.getParameter("pgno");
    if(param != null && !param.isEmpty()){
    	pgno = Integer.parseInt(param);
    }
	int count=0;  //记录总个数
	int pgcnt=10;
	String message="";
	StringBuilder table=new StringBuilder();
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
				+ "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8&useSSL=false"; 
		try{
  			Class.forName("com.mysql.jdbc.Driver");
  			Connection con=DriverManager.getConnection(connectString, 
                 "root", "2333");
  			Statement stmt=con.createStatement();
  			if(member_type==1){
  				//查看会员
  	  			ResultSet rs=stmt.executeQuery(
  	    	  			"select * from 会员 limit "+pgno*10+","+"10;");
  	    		table.append("<div class=\"th\"><table><tr><th>客户编号</th><th>客户姓名</th><th>联系方式</th>"
  	    				);
  	    		if(user_type == 2)  table.append("<th>操作</th>");  //经理有权删除
  	    		table.append("</tr>");
  	    		
  	    		while(rs.next()){
  	    			table.append(String.format(
  	    					"<tr><th>%d</th><th>%s</th><th>%s</th>",
  	    					rs.getInt("客户编号"),rs.getString("客户姓名"),
  	    					rs.getString("联系方式")
  	    			));
  	  	    		if(user_type == 2)  table.append("<th><Button id='deleteEmployee' onclick='delete_member("+rs.getInt("客户编号")+")'>删除</Button></th>");
  	  	    		table.append("</tr>");
  	    		}
  	    		table.append("</table>");
  	  			rs.close();
  	  		  	rs=stmt.executeQuery("select count(*) from 会员"); 
  	  		  	if(rs.next()) count = rs.getInt(1); 
  	    		rs.close();
  			}else if(member_type==2){
  				//查看供应商
  	  			ResultSet rs=stmt.executeQuery(
  	    	  			"select * from 供应商 limit "+pgno*10+","+"10;");
  	    		table.append("<div class=\"th\"><table><tr><th>供应商编号</th><th>供应商名称</th><th>联系人</th><th>联系方式</th><th>所在城市</th>"
  	    				);
  	    		if(user_type == 2)  table.append("<th>操作</th>"); //经理有权删除
  	    		table.append("</tr>");
  	    		while(rs.next()){
  	    			table.append(String.format(
  	    					"<tr><th>%d</th><th>%s</th><th>%s</th><th>%s</th><th>%s</th>",
  	    					rs.getInt("供应商编号"),rs.getString("供应商名称"),
  	    					rs.getString("联系人"),rs.getString("联系方式"),rs.getString("所在城市")
  	    			));
  	  	    		if(user_type == 2)  table.append("<th><Button id='deleteEmployee' onclick='delete_member("+rs.getInt("供应商编号")+")'>删除</Button></th>");
  	  	    		table.append("</tr>");
  	    		}
  	    		table.append("</table>");
  	    		rs.close();
  	  		  	rs=stmt.executeQuery("select count(*) from 供应商"); 
  	  		  	if(rs.next()) count = rs.getInt(1); 
  	  			rs.close();
  			}else if(member_type==3 && user_type==2){  //经理有权查看员工信息和删除
  	  			ResultSet rs=stmt.executeQuery(
  	    	  			"select * from employee_info limit "+pgno*10+","+"10;");
  	    		table.append("<div class=\"th\"><table><tr><th>员工编号</th><th>员工姓名</th><th>联系电话</th><th>登陆用户编号</th><th>登录名</th><th>操作</th></tr>"
  	    				);
  	    		
  	    		while(rs.next()){
  	    			table.append(String.format(
  	    					"<tr><th>%d</th><th>%s</th><th>%s</th><th>%s</th><th>%s</th><th><Button id='deleteEmployee' onclick='delete_member(%s)'>删除</Button></th></tr>",
  	    					rs.getInt("员工编号"),rs.getString("员工姓名"),
  	    					rs.getString("联系电话"),rs.getInt("用户编号"),rs.getString("用户名"),rs.getInt("用户编号")
  	    			));
  	    		}
  	    		table.append("</table>");
  	    		rs.close();
  	  		  	rs=stmt.executeQuery("select count(*) from 员工"); 
  	  		  	if(rs.next()) count = rs.getInt(1); 
  	  			rs.close();
  			}
  			stmt.close();
  			con.close();
  			
		}
		catch (Exception e){
  			message = "连接数据库失败";
		}		
	StringBuilder page_show = new StringBuilder();
	int all_page = (count > 10)?(count-1)/pgcnt:0;
	if(all_page <= 0){page_show.append("<span>1</span>");}
	else{
	if(pgno == 0){
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
		page_show.append("<span>1</span>");
		int i = 1;
		while(i < 9 && i <= all_page){
			page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",i,i+1));
			i++;
		}
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>下一页</a></span>",pgnext));
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>尾页</a></span>",all_page));
	}else if(pgno == all_page){
		int pgprev = (pgno>0)?pgno-1:0;
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>上一页</a>",pgprev));
		//尾页大于10
		if(pgno >= 9){
			int i = 8;
			while(i > 0){
				page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",pgno-i,pgno-i+1));
				i--;
			}
		}
		//尾页小于10
		else{
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
		}
		page_show.append(String.format("<span>%d</span>",pgno+1));	
	}else{
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>上一页</a>",pgprev));
		if(pgno < 5){
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w <= all_page){
					page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>尾页</a>",all_page));
		}
		else{
			int i = pgno - 4; 
			while(i < pgno){
				page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w < all_page){
					page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&search_title=%s&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&search_title=%s&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&search_title=%s&pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='MemberManage.jsp?member_type="+member_type+"&search_title=%s&pgno=%d'>尾页</a>",all_page));
		}
	}}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script>
	function select(){
		var type=document.getElementById("member_type");
		var index=type.selectedIndex;//所选下拉选框索引值
		window.location.href="MemberManage.jsp?member_type="+(index+1);  
	}
	function add(){
		var member_type=<%=member_type%>;
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status >= 200 && 
						(xmlhttp.status < 300 || xmlhttp.status >= 304)){
					alert(xmlhttp.responseText);
					window.location.reload();
				} else {
					alert("Server error");
				}
			};
		};
		if(member_type==1){
			var name=prompt("请输入会员姓名","");//将输入的内容赋给变量 name ，
		    //这里需要注意的是，prompt有两个参数，前面是提示的话，后面是当对话框出来后，在对话框里的默认值
		    if(name!=null){//如果返回的有内容
			    while(name=="")
			    {
					alert("会员姓名不能为空");
					name=prompt("请输入会员姓名","");
					if(name==null)  return;
			    }
				var phone=prompt("请输入会员联系方式","");
				if(phone==null)  return;
				var param = "name="+encodeURIComponent(name)+"&phone="+encodeURIComponent(phone);//汉字需要编码
				xmlhttp.open("post", "AddVIP.jsp", true);
				xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				xmlhttp.send(param); // 没有参数就用null		
		    }
		}else if(member_type==2){
			var name=prompt("请输入供应商名称","");//将输入的内容赋给变量 name ，
		    //这里需要注意的是，prompt有两个参数，前面是提示的话，后面是当对话框出来后，在对话框里的默认值
		    if(name!=null){//如果返回的有内容
		    	while(name=="")
			    {
					alert("供应商名称不能为空");
					name=prompt("请输入供应商名称","");
					if(name==null)  return;
			    }
				var contact_person=prompt("请输入联系人","");
				if(contact_person==null)  return;
				var phone=prompt("请输入联系方式","");
				if(phone==null)  return;
				var city=prompt("请输入所在城市","");
				if(city==null)	return;
				var param = "name="+encodeURIComponent(name)+"&contact_person="+encodeURIComponent(contact_person)
					+"&phone="+encodeURIComponent(phone)+"&city="+encodeURIComponent(city);//汉字需要编码
				xmlhttp.open("post", "AddSupplier.jsp", true);
				xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				xmlhttp.send(param); // 没有参数就用null		
		    }
		}else if(member_type==3){
			var name=prompt("请输入员工姓名","");//将输入的内容赋给变量 name ，
		    //这里需要注意的是，prompt有两个参数，前面是提示的话，后面是当对话框出来后，在对话框里的默认值
		    if(name!=null){
			    while(name==""){
					alert("员工姓名不能为空");
					name=prompt("请输入员工姓名","");
					if(name==null)  return;
				}
				var phone=prompt("请输入联系电话","");
			    if(phone!=null){
					var param = "name="+encodeURIComponent(name)+"&phone="+encodeURIComponent(phone);//汉字需要编码
					xmlhttp.open("post", "AddEmployee.jsp", true);
					xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
					xmlhttp.send(param); // 没有参数就用null	
			    }
		    }
		}
	}
	function delete_member(which){
		var member_type=<%=member_type%>;
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status >= 200 && 
						(xmlhttp.status < 300 || xmlhttp.status >= 304)){
					alert(xmlhttp.responseText);
					window.location.reload();
				} else {
					alert("Server error");
				}
			};
		};
		var param = "id="+which;//汉字需要编码
		if(member_type==1){
			xmlhttp.open("post", "DeleteVIP.jsp", true);
		}else if(member_type==2){
			xmlhttp.open("post", "DeleteSupplier.jsp", true);
		}else if(member_type==3){
			xmlhttp.open("post", "DeleteEmployee.jsp", true);
		}
		xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		xmlhttp.send(param); // 没有参数就用null	
	}
</script>
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
</style>
<title>人员管理</title>
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
		#login:hover,#sign-up:hover{
			color: 	#2C93EE;
		}
		#content{
			width: 800px;
			margin: 0 auto;
			margin-top: 20px;
		}
		#topiclist{
			width:100%;
		}
		.th{
			width:800px;		
		}
		#page_show{
		    border: none;
    		width: 100%;
    		position: relative;
    		margin: 0;
    		padding: 0;
    		height: 45px;
    		background-color: rgba(0,0,0,.02);
    		border-bottom: 1px solid rgba(0,0,0,.1);
    		color: #666;
		}
		#page_num{
		    padding-top: 10px;
    		padding-left: 20px;
    		float:right;
    		margin-right:20px;
		}
		#page_num a{
		    float: none !important;
    		display: inline-block !important;
    		text-align: center;
    		min-width: 13px;
    		line-height: 25px;
    		height: 25px;
    		padding: 0 10px;
    		margin: 0 0 0 8px;
    		color: inherit;
    		background-color: rgba(0, 0, 0, .05);
    		border-radius: 12.5px;	
		}
		#page_num span{
			display: inline-block !important;
    		text-align: center;
    		min-width: 13px;
    		line-height: 25px;
    		padding: 0 10px;
    		height: 25px;
		    color: #fff;
    		background-color: rgba(0, 0, 0, .3);
    		width: auto !important;
    		border-radius: 12.5px;
    		margin: 0 0 0 8px;
		}
		.td tr:hover{
			box-shadow: 1px 1px 2px #D4D4D4,  1px -1px 2px #D4D4D4;
		}
		th{
			width:150px;
		}
		#page_num a:hover{
		background:rgb(201,202,187);
	}
		#content{
			width:1000px;
			padding:20px 0 0 0;
			margin:20px auto;
			border-radius: 5px;
			box-sizing: border-box;
			background:white;
			box-shadow: 1px 1px 2px #D4D4D4,  -1px -1px 2px #D4D4D4;
			
		}
		.time{ font-size:0.6em;}
		.page{ float: right;}
		.pageinput{ width: 30px;}
		#error { color: red; text-align: center;}
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
	<div>
		<select id="member_type" name="member_types" onchange="select()"> 
           <option value="会员" <%=member_types[0] %>>会员</option>
           <option value="供应商" <%=member_types[1] %>>供应商</option>
           <%if(user_type==2){ %>
           <option value="员工" <%=member_types[2] %>>员工</option>
           <%} %>
    	</select>
	</div>
	<div id="topiclist">
		<div>
			<p id="error"> <%=message%> </p>
		</div>
		<div class="td">
			<%=table%>
		</div>
		<div>
			<br/>
			<Button id="add" onclick="add()">添加</Button>
		</div>
		<div id="page_show" >
		<div id="page_num">
			<%=page_show %>
		</div>
	</div>
	</div>
</div>

</body>
</html>