<%@ page language="java" import="java.util.*,java.sql.*,java.net.*,java.text.*"
contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>购买信息</title>
<style>
h1{
  margin-left:70px;
}
.middle{
  margin:0 40%;
  width:50em;
}
#sub{
  margin-left:70px;
}
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
    String customer_id=request.getParameter("customer_id");//客户编号
    String drug_id=request.getParameter("drug_id");//药品编号
    String user_name= (String)session.getAttribute("username");
    int user_type = Integer.parseInt((String)session.getAttribute("type"));
    String msg="";
    String drug_name="";//药品名称
    double drug_price=0;//药品单价
    double VIP_price=0;//会员价
    double VIP_discount=1;//会员折扣
    int drug_rest=0;//库存
    int employee_id=0;//员工编号
    String count="";
    int pcount=0;
    String money="";
    int pmoney=0;
    int financial_id=0;//财政收支编号
    String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8"
			+"&useSSL=true";
    Class.forName("com.mysql.jdbc.Driver");
  	Connection con = DriverManager.getConnection(connectString,"root", "2333");
  	Statement stmt = con.createStatement();
  	PreparedStatement ps=null;
  	//从员工信息视图获取员工编号
  	rs=stmt.executeQuery("select 员工编号 from employee_info where 用户名='"+user_name+"';");
	if(rs.next()){
		employee_id = rs.getInt(1);
	}
	rs.close();
	//获取药品信息
	rs=stmt.executeQuery("select 药品名称,单价,会员折扣,库存 from `药品` where 药品编号="+drug_id);
	if(rs.next()){
		drug_name = rs.getString("药品名称");
		drug_price = rs.getDouble("单价");
		if(!customer_id.equals("null")){
			VIP_discount = rs.getDouble("会员折扣");	
		}
		drug_rest = rs.getInt("库存");
	}
	rs.close();
  	if(request.getMethod().equalsIgnoreCase("post")){
     try{
  		count = request.getParameter("count");
  		money = request.getParameter("money");
  		if(count==null||count.equals("")||count.equals("0")){
     		 msg="请输入购买数量!";%>
     		<script>
          alert("请输入购买数量!");
          </script>
     	 <%}
  		else if(pcount > drug_rest){%>
 			<script>
        	alert("库存不足!");
        	</script>
   	 	<%}else{
  			msg="这里";
  	    	 con.setAutoCommit(false);//设置自动提交为false
  			pcount=Integer.parseInt(count);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  		java.util.Date currentTime = new java.util.Date();//得到当前系统时间
	  		String today = formatter.format(currentTime); //将日期时间格式化 
	  		//销售事务
	  		//更新库存
	  		String fmt1="update 药品  set `库存`='%d' where `药品编号`='%s'";
	  		String sql1 = String.format(fmt1,drug_rest-pcount,drug_id); 
	  		ps = con.prepareStatement(sql1);
	      	ps.executeUpdate();
	      	//插入财政收支记录
	  		String fmt2="INSERT INTO `财政收支` (`药品编号`,`员工编号`,`数量`,`日期`,`总额`,`类型`) VALUES ('%s','%d','%d','%s','%s','销售')";
	  		String sql2 = String.format(fmt2,drug_id,employee_id,pcount,today,money); 
	  		ps = con.prepareStatement(sql2);
	      	ps.executeUpdate(); 
	      	//获取插入的财政收支编号
	      	ps = con.prepareStatement("select @@identity;");
	  		rs = ps.executeQuery();
	  		if(rs.next()){
	  			financial_id=rs.getInt(1);
	  		}
	  		rs.close();
	  		//插入销售记录
  			String fmt3="insert into 销售管理(客户编号,收支编号) values(%s,'%d')";
        	String sql3 = String.format(fmt3,customer_id,financial_id); 
	  		ps = con.prepareStatement(sql3);
	      	ps.executeUpdate();
	      	//提交事务
	      	con.commit();
        	msg="成功";
        	%><script>
           alert("销售成功!");
           window.location.href="HomePage.jsp";
           </script><%
  		}
  	  }catch(Exception e){
 		 try {
             con.rollback();
         } catch (Exception e1) {
        	 e1.printStackTrace();
    	 }
  		 msg = e.getMessage();
 	}finally{
        try {
           //设置事务提交方式为自动提交：
           con.setAutoCommit(true);
        } catch (Exception e) {
           e.printStackTrace();
        }
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
    <form  method="post" name="f">
    <h1>购买信息</h1>
    <p> 药品名称：<%=drug_name %></p>
    <p> 价格: <span style="text-decoration:line-through"> <%=drug_price %></span>  <%out.print(new DecimalFormat("###0.00").format(drug_price*VIP_discount));%></p>
    <p> 库存: <%=drug_rest %></p>
    <p> 销售数量： <input id="count" name="count" type="text" placeholder="输入销售数量" onblur="calculate()" value="<%=pcount%>" ></p>
    <script>
    	window.onload=function(){
    		calculate();
    	}
    	function calculate(){
    		var  a = document.getElementById('count').value*<%=drug_price*VIP_discount%>;
    		document.getElementById('money').value = a.toFixed(2);
    	}
    </script>
    <p> 销售总价： <input id="money" name="money" type="text" placeholder="输入总价"  readonly="readonly" value="<%=pmoney%>"></p>
    <input id ="sub" name="sub" type="submit" value="确认销售" />   
    </form>     
</div>
<%=msg %>
</body>
</html>