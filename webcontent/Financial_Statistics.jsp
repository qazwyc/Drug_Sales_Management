<%@ page language="java" import="java.util.*,java.lang.*,java.sql.*,java.net.*,java.text.*"  contentType="text/html; charset=gb2312"
    pageEncoding="utf-8"%>
<%  request.setCharacterEncoding("utf-8");
    response.setContentType("text/html; charset=utf-8");
    String user_name=(String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
    String type = request.getParameter("statistics_type");
    if(type==null || type=="") type="1";
	int statistics_type = Integer.parseInt(type);
	
	String statistics_types[]= {"","",""};
	statistics_types[statistics_type-1] = "selected";
    //分页
    Integer pgno = 0; //当前页号
    String param = request.getParameter("pgno");
    if(param != null && !param.isEmpty()){
    	pgno = Integer.parseInt(param);
    }
	int count=0;  //记录总个数
	String allIn = "";//总收入
	String allOut = "";//总支出
	String all = "";//盈亏
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
	    	table.append("<div class=\"th\"><table><tr><th>类型</th><th>药品名称</th><th>数量</th><th>时间</th><th>收支</th>"
  	    		 );
	    	
			String date = "";
			if(statistics_type==2){
				SimpleDateFormat formatter = new SimpleDateFormat("yy-MM-dd");
	  			java.util.Date currentTime = new java.util.Date();//得到当前系统年月日
	  			date = formatter.format(currentTime); //将日期时间格式化 
			}else if(statistics_type==3){
				SimpleDateFormat formatter = new SimpleDateFormat("yy-MM");
	  			java.util.Date currentTime = new java.util.Date();//得到当前系统年月
	  			date = formatter.format(currentTime); //将日期时间格式化 
			}
			//查出匹配日期的财政收支记录,按日期降序排列
  	  		ResultSet rs=stmt.executeQuery(
  	    	  		"select * from financial_records where `日期` like '%"+date+"%' order by `日期` desc limit "+pgno*10+","+"10;");
  	    	while(rs.next()){
  	    		table.append(String.format(
  	    				"<tr><th>%s</th><th>%s</th><th>%s</th><th>%s</th><th>%s</th></tr>",
  	    				rs.getString("类型"),rs.getString("药品名称"),rs.getString("数量"),rs.getString("日期"),
  	    				rs.getString("总额")
  	    		));
  	    	}
  	    	table.append("</table>");
  	  		rs.close();
  	  		//调用过程  -- 统计盈亏、收入、支出
  	  		CallableStatement cStmt = con.prepareCall("{call payments_statistics(?)}");
			cStmt.setString(1,"%"+date+"%");
			cStmt.execute();
			rs = cStmt.getResultSet();
  	  		if(rs.next()){
  	  		  	count = rs.getInt(1);
  	  		  	all = rs.getString(2);
  	  		  	allOut = rs.getString(3);
  	  		  	allIn = rs.getString(4);
  	  		}
  	    	rs.close();
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
			page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",i,i+1));
			i++;
		}
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>下一页</a></span>",pgnext));
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>尾页</a></span>",all_page));
	}else if(pgno == all_page){
		int pgprev = (pgno>0)?pgno-1:0;
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>上一页</a>",pgprev));
		//尾页大于10
		if(pgno >= 9){
			int i = 8;
			while(i > 0){
				page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",pgno-i,pgno-i+1));
				i--;
			}
		}
		//尾页小于10
		else{
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
		}
		page_show.append(String.format("<span>%d</span>",pgno+1));	
	}else{
		int pgprev = (pgno>0)?pgno-1:0;
		int pgnext = pgno+1;
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>首页</a>",0));
		page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>上一页</a>",pgprev));
		if(pgno < 5){
			int i = 0;
			while(i < pgno){
				page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w <= all_page){
					page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>尾页</a>",all_page));
		}
		else{
			int i = pgno - 4; 
			while(i < pgno){
				page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&pgno=%d'>%d</a>",i,i+1));
				i++;
			}
			page_show.append(String.format("<span>%d</span>",pgno+1));
			if(all_page - pgno <= 4){
				int w = pgno+1;
				while(w < all_page){
					page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&search_title=%s&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}else{
				int w = pgno+1;
				while(w < pgno + 5){
					page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&search_title=%s&pgno=%d'>%d</a>",w,w+1));
					w++;
				}
			}
			page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&search_title=%s&pgno=%d'>下一页</a>",pgnext));
			page_show.append(String.format("<a href='Financial_Statistics.jsp?statistics_type="+statistics_type+"&search_title=%s&pgno=%d'>尾页</a>",all_page));
		}
	}}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
<head>
<script>
	function select(){
		var type=document.getElementById("statistics_type");
		var index=type.selectedIndex;//所选下拉选框索引值
		window.location.href="Financial_Statistics.jsp?statistics_type="+(index+1);  
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css" />
<title>财务统计</title>
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
		<select id="statistics_type" name="statistics_types" onchange="select()"> 
           <option value="全部" <%=statistics_types[0] %>>全部</option>
           <option value="当日" <%=statistics_types[1] %>>当日</option>
           <option value="当月" <%=statistics_types[2] %>>当月</option>
    	</select>  	
    	<span>数目： <%=count %></span>
    	<span>收入： <%=allIn %></span>
    	<span>支出： <%=allOut %></span>
    	<span>盈亏： <%=all %></span>
	</div>
	<div id="topiclist">
		<div>
			<p id="error"> <%=message%> </p>
		</div>
		<div class="td">
			<%=table%>
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