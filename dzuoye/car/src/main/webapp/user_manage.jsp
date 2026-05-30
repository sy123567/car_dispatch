<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || currentUser.getRoleId() != 1) {
        response.sendRedirect(request.getContextPath() + "/index");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 用户管理</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_manage.css">
</head>
<body>
    <div class="bg-gradient">
        <div class="fluid-blob blob-1"></div>
        <div class="fluid-blob blob-2"></div>
        <div class="fluid-blob blob-3"></div>
    </div>

    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-circle">🚗</div>
            <span class="logo-text">用车管理</span>
        </div>
        <nav class="nav-menu">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/index" class="nav-link"><span class="nav-icon">📊</span><span>仪表盘</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=add" class="nav-link"><span class="nav-icon">📝</span><span>用车申请</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=myList" class="nav-link"><span class="nav-icon">📋</span><span>我的申请</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=list" class="nav-link"><span class="nav-icon">✅</span><span>审批申请</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driverTask" class="nav-link"><span class="nav-icon">🚗</span><span>我的接单</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/repair" class="nav-link"><span class="nav-icon">🔧</span><span>维修事务</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/car" class="nav-link"><span class="nav-icon">🚙</span><span>车辆管理</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driver" class="nav-link"><span class="nav-icon">👨‍✈️</span><span>司机管理</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/userManage" class="nav-link active"><span class="nav-icon">👤</span><span>用户管理</span></a></li>
        </nav>
    </aside>

    <header class="header">
        <div class="header-left">
            <h1 class="header-title">用户管理</h1>
        </div>
        <div class="header-right">
            <div class="user-info">
                <div class="user-avatar"><%= currentUser.getName().charAt(0) %></div>
                <span class="user-name"><%= currentUser.getName() %></span>
            </div>
            <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:0;">
                <button type="submit" class="logout-btn">退出登录</button>
            </form>
        </div>
    </header>

    <main class="main-content">
        <% if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
        <% } %>
        <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <div class="form-card">
            <h2>添加新用户</h2>
            <form action="${pageContext.request.contextPath}/userManage" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label>姓名</label>
                        <input type="text" class="form-control" name="name" placeholder="请输入姓名" required>
                    </div>
                    <div class="form-group">
                        <label>账号</label>
                        <input type="text" class="form-control" name="account" placeholder="请输入登录账号" required>
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" class="form-control" name="password" placeholder="请输入密码" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>部门</label>
                        <input type="text" class="form-control" name="department" placeholder="请输入部门">
                    </div>
                    <div class="form-group">
                        <label>角色类型</label>
                        <select class="form-control" name="roleId" required>
                            <option value="2">员工</option>
                            <option value="3">审批人</option>
                            <option value="4">司机</option>
                            <option value="1">管理员</option>
                        </select>
                    </div>
                    <div class="form-group" style="justify-content: flex-end;">
                        <button type="submit" class="btn-submit">添加用户</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="data-card">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>姓名</th>
                        <th>账号</th>
                        <th>部门</th>
                        <th>角色</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null && !users.isEmpty()) { %>
                        <% for (User u : users) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getName() %></td>
                            <td><%= u.getAccount() %></td>
                            <td><%= u.getDepartment() != null ? u.getDepartment() : "-" %></td>
                            <td>
                                <% if (u.getRoleId() == 1) { %>
                                    <span class="role-badge role-admin">管理员</span>
                                <% } else if (u.getRoleId() == 2) { %>
                                    <span class="role-badge role-employee">员工</span>
                                <% } else if (u.getRoleId() == 3) { %>
                                    <span class="role-badge role-approver">审批人</span>
                                <% } else if (u.getRoleId() == 4) { %>
                                    <span class="role-badge role-driver">司机</span>
                                <% } %>
                            </td>
                            <td>
                                <% if (u.getId() != currentUser.getId()) { %>
                                <a href="${pageContext.request.contextPath}/userManage?action=delete&id=<%= u.getId() %>" 
                                   class="btn-delete" onclick="return confirm('确定删除该用户？');">删除</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="6" style="text-align:center; color: var(--text-secondary); padding: 40px;">暂无用户数据</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
