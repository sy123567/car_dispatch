<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
**学院学生信息管理
<table border="1">
	<tr>
	<td>编号</td><td>帐号</td><td>密码</td><td>类型</td><td>姓名</td>
	<td>修改</td><td>删除</td>
	<tr/>
	<tr>
	<td>1</td><td>张三</td><td>张三</td><td>0</td><td>张三</td>
	<td><a href="edit.jsp">修改</a></td>
	<td><a href="delete.jsp">删除</a></td>
	<tr/>
	<tr>
	<td>2</td><td>李四</td><td>李四</td><td>0</td><td>李四</td>
	<td><a href="edit.jsp">修改</a></td>
	<td><a href="delete.jsp">删除</a></td>
	<tr/>
</table>
<a href="add.jsp">新增用户</a>
</body>
</html>