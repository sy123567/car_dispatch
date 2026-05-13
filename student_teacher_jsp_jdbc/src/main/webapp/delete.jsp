<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String userid=request.getParameter("id");//取得传递过来的用户参数，用于查询和删除
	String userok=request.getParameter("ok");//为0：查询让用户确认；为1：用户确认，删除
	
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
		Statement stmt=null;//放在if或循环语句中，则只在语句段中有效
		ResultSet rs=null;//放在if或循环语句中，则只在语句段中有效
		if(userok.equals("0")){//查询要删除的数据，让用户确认
			//准备执行数据库查询
			String sql="select * from user where id='"+userid+"'";
			//准备SQL执行;
			stmt=conn.createStatement();
			//执行数据库查询，获取结果集
			rs=stmt.executeQuery(sql);
			if(rs!=null && rs.next()){//执行完sql语句后，rs指向第一条结果的前面，所以必须执行一次next()操作
				System.out.println("right");
			}
			else
			{	
				System.out.println("null");
			}
%>
	<form action="delete.jsp">
		将要删除的用户信息是：<br/>
		编号<input type="text" name="id" value=<%=rs.getInt("ID") %> readonly><br/>
		帐号<input type="text" name="account" value=<%=rs.getString("ACCOUNT") %> readonly><br/>
		密码<input type="text" name="password" value=<%=rs.getString("PASSWORD")%> readonly><br/>
		类型<input type="text" name="type" value=<%=rs.getInt("TYPE")%> readonly><br/>
		姓名<input type="text" name="name" value=<%=rs.getString("NAME")%> readonly><br/>
		<%String deleteURL="delete.jsp?action=1&id="+rs.getInt("ID")+"&ok=1"; %>
		<a href=<%=deleteURL %> >确定
		</a>
	</form>
<%
	}
	else{//用户已确认，删除用户
		String sql="delete from user where id='"+userid+"'";
		stmt=conn.createStatement();
		//执行数据库查询，获取结果集
		int result=stmt.executeUpdate(sql);
		System.out.println(result);
	}
	//关闭表达式对象
	stmt.close();			
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
	if(userok.equals("1")){//执行删除操作后，转回到主画面
		response.sendRedirect("main-final.jsp");
	}
%>

</body>
</html>