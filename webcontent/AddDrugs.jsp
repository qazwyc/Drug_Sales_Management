<%@ page language="java" import="java.util.*,java.sql.*,java.text.*"
         contentType="text/html; charset=utf-8"
%>
<% 
  request.setCharacterEncoding("utf-8");
  String msg = "";
  String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false"; 
  String user = "root"; String pwd="2333";  //本地数据库用户名密码
  String user_name = (String)session.getAttribute("username");  //登陆用户名
  if(request.getMethod().equalsIgnoreCase("post")){
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection(connectString,user, pwd);
    Statement stmt = con.createStatement();
	PreparedStatement ps=null;
    try{
    	con.setAutoCommit(false);//设置自动提交为false
    	String drug_name = request.getParameter("drug_name");//药品名
    	String supplier_id = request.getParameter("supplier_id");//供应商编号
    	String batch_num = request.getParameter("batch_num");//生产批号
    	String where = request.getParameter("where");//产地
    	String type = request.getParameter("type");//类型
    	String cost = request.getParameter("cost");//采购总额
    	String price = request.getParameter("price");//销售单价
    	String discount = request.getParameter("discount");//会员折扣
    	String count = request.getParameter("count");//数量
    	String pack_spec = request.getParameter("pack_spec");//包装规格
    	String product_date = request.getParameter("product_date");//生产日期
    	String expiry_date = request.getParameter("expiry_date");//有效期
    	int employee_id=0;//员工编号
    	int drug_id = 0;//药品编号
    	int financial_id=0;//财政编号
    	double mcost= Double.parseDouble(cost);
    	int mcount=Integer.parseInt(count);
    	//根据登录名获取员工编号
    	ResultSet rs=stmt.executeQuery("select 员工编号 from employee_info where 用户名='"+user_name+"';");
    	if(rs.next()){
    		employee_id = rs.getInt(1); 
    	}
    	String a_cost = new DecimalFormat("###0.00").format(mcost/mcount);//保留两位小数
    	//入库事务
    	//插入药品记录
      	String fmt1="insert into `药品`(药品名称,供应商编号,生产批号,产地,所属类别,进价,单价,会员折扣,库存,包装规格,生产日期,有效期)values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');";
      	String sql1 = String.format(fmt1,drug_name,supplier_id,batch_num,where,type,a_cost,price,discount,count,pack_spec,product_date,expiry_date);
      	ps = con.prepareStatement(sql1);
      	ps.executeUpdate();
      	//获取刚插入的药品编号
      	ps = con.prepareStatement("select @@identity;");
  		rs = ps.executeQuery();
  		if(rs.next()){
  			drug_id=rs.getInt(1);
  		}
  		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  		java.util.Date currentTime = new java.util.Date();//得到当前系统时间
  		String today = formatter.format(currentTime); //将日期时间格式化 
  		//插入财政收支记录
      	String fmt2="insert into `财政收支`(药品编号,员工编号,数量,日期,总额,类型)values(%d,%d,'%s','%s','%s','入货');";
      	String sql2 = String.format(fmt2,drug_id,employee_id,count,today,"-"+cost);
      	ps = con.prepareStatement(sql2);
      	ps.executeUpdate();
      	//获取插入的财政收支编号
      	ps = con.prepareStatement("select @@identity;");
  		rs = ps.executeQuery();
  		if(rs.next()){
  			financial_id=rs.getInt(1);
  		}
  		rs.close();
  		//插入入库记录
		String fmt3="insert into `入库记录`(供应商编号,收支编号)values('%s',%d);";
    	String sql3 = String.format(fmt3,supplier_id,financial_id); 
      	ps = con.prepareStatement(sql3);
      	int cnt = ps.executeUpdate();
      	//提交事务
      	con.commit();
      	if(cnt>0){
    	  out.print("<script>alert('新增成功!');window.location.href='WareHouse.jsp';</script>");
      	}
      	stmt.close();
      	ps.close();
      	con.close();
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
<!DOCTYPE HTML>
<html>
<head>
<title>新增入库</title>
<style>
  a:link,a:visited {color:blue;}
  .container{
    margin:0 auto;
    width:500px;
    text-align:center;
  }
</style>
</head>
<body>
  <div class="container">
    <h1>新增入库</h1>
    <form method="post" name="f">
      <p>药品名称:<input name="drug_name" type="text" ><p>
      <p>供应商编号:<input name="supplier_id" type="text" ><p>
      <p>生产批号:<input name="batch_num" type="text" ><p>
      <p>产地:<input name="where" type="text" ><p>
      <p>所属类别:<input name="type" type="text" ><p>
      <p>总额:<input name="cost" type="text" ><p>
      <p>单价:<input name="price" type="text" ><p>
      <p>会员折扣:<input name="discount" type="text" ><p>
      <p>数量:<input name="count" type="text" ><p>
      <p>包装规格:<input name="pack_spec" type="text" ><p>
      <p>生产日期:<input name="product_date" type="text" ><p>
      <p>有效期:<input  name="expiry_date" type="text" ><p>
      <input type="submit" name="sub" value="保存">
    </form>
    <p><%=msg%><p>
    <br><p><a href='WareHouse.jsp'>返回</a><p>
  </div>
</body>
</html>