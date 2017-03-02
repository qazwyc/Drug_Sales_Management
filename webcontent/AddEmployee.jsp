<%@ page language="java" import="java.util.*,java.sql.*,java.text.*"
contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8");%>
<%  String msg="";
	String name=request.getParameter("name");
	String phone=request.getParameter("phone");
	String connectString = "jdbc:mysql://localhost:3306/医药销售管理系统"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false";
	String user="root";
	String pwd="2333";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection(connectString, user, pwd);
	PreparedStatement ps=null;
	try{
    	con.setAutoCommit(false);//设置自动提交为false
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMddHHmm");
		java.util.Date currentTime = new java.util.Date();//得到当前系统时间
		String user_name = formatter.format(currentTime)+name; //将日期时间格式化 
		//注册员工事务
		//插入登陆用户
		ps = con.prepareStatement(String.format("insert into `登录用户`(用户名,密码,类别)values('%s','123',1);"
				,user_name));
		ps.executeUpdate();
		//获取插入的用户编号
	    int user_id=0;
      	ps = con.prepareStatement("select @@identity;");
      	ResultSet rs = ps.executeQuery();
  		if(rs.next()){
  			user_id=rs.getInt(1);
  		}
  		//插入员工
		ps = con.prepareStatement(String.format("insert into `员工`(员工姓名,联系电话,用户编号)values('%s','%s','%d');"
				,name,phone,user_id));
		ps.executeUpdate();
		//提交事务
      	con.commit();
		msg = "成功添加员工!";
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
	out.print(msg);
%>