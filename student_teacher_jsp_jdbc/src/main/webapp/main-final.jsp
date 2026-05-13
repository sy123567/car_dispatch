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
**学院学生信息管理
<%
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
	//准备执行数据库查询
	String sql="select * from user";
	//准备SQL执行;
	Statement stmt=conn.createStatement();
	//执行数据库查询，获取结果集
	ResultSet rs=stmt.executeQuery(sql);

%>	
<!-- 以下HTML代码段用于显示查询出来的数据 -->
<table border="1">
	<tr>
	<td>编号</td><td>帐号</td><td>密码</td><td>类型</td><td>姓名</td>
	<td>修改</td><td>删除</td>
	<tr/>
<%	while(rs!=null && rs.next()){ %>	
	<tr>
	<td><%=rs.getInt("ID") %></td><td><%=rs.getString("ACCOUNT") %></td>
	<td><%=rs.getString("PASSWORD") %></td><td><%=rs.getInt("TYPE") %></td>
	<td><%=rs.getString("NAME") %></td>
	
	<%String editURL="edit.jsp?action=1&id="+rs.getInt("ID")+"&ok=0"; %>
	<td><a href=<%=editURL %>>修改</a></td>
	<%String deleteURL="delete.jsp?action=2&id="+rs.getInt("ID")+"&ok=0"; %>	
	<td><a href=<%=deleteURL %>>删除</a></td>
	</tr>
<%  } //对应以上的while语句%>
</table>
<a href="add.jsp">新增用户</a>
			
<%
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
%>

</body>
</html>