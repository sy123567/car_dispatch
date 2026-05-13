<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %><!-- 数据库操作需要 -->        
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
		//获取参数，转换为相应的类型
		String id=request.getParameter("id");
		int idInt=Integer.parseInt(id);
		String account=request.getParameter("account");
		String password=request.getParameter("password");
		String type=request.getParameter("type");
		int typeInt=Integer.parseInt(type);
		String name=request.getParameter("name");
		
		//第一个java代码段查询数据
		try{
			Class.forName("org.h2.Driver");//加载驱动
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return;
		}
		String url="jdbc:h2:d:/temp/test";//此处与H2控制台中的数据文件存放位置一致
		Connection conn=null;

	//数据库连接与查询过程中可能会引发sql异常
	try {
		//获取数据库连接(url,username,password)			
		conn = DriverManager.getConnection(url,"sa","");
		//准备执行数据库插入，此处使用了?方式，比拼接字符串更清晰
		String sql="insert into user values(?,?,?,?,?)";
		//准备SQL执行;注意此处与Statement的不同
		PreparedStatement pstmt=conn.prepareStatement(sql);
		pstmt.setInt(1,idInt);
		pstmt.setString(2,account);
		pstmt.setString(3,password);
		pstmt.setInt(4,typeInt);
		pstmt.setString(5,name);
		
		//执行数据库插入，获取结果集
		int result=pstmt.executeUpdate();
		System.out.println(result);
		//关闭表达式对象
		pstmt.close();			
		//关闭数据库			
		conn.close();			
		
	} catch (SQLException e) {
		e.printStackTrace();
	} finally{
		//防止数据库未正常关闭
		try{
			if (conn!=null && (!conn.isClosed())){
				conn.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	response.sendRedirect("main-final.jsp");
%>
</body>
</html>