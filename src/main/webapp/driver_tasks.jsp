<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.CarDispatch" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    int roleId = currentUser.getRoleId();
    List<CarDispatch> tasks = (List<CarDispatch>) request.getAttribute("tasks");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 我的接单</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/driver_tasks.css">
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
            <% if (roleId == 1 || roleId == 2 || roleId == 3) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=add" class="nav-link"><span class="nav-icon">📝</span><span>用车申请</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=myList" class="nav-link"><span class="nav-icon">📋</span><span>我的申请</span></a></li>
            <% } %>
            <% if (roleId == 1 || roleId == 3) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=list" class="nav-link"><span class="nav-icon">✅</span><span>审批申请</span></a></li>
            <% } %>
            <% if (roleId == 4 || roleId == 1) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driverTask" class="nav-link active"><span class="nav-icon">🚗</span><span>我的接单</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/repair" class="nav-link"><span class="nav-icon">🔧</span><span>维修事务</span></a></li>
            <% } %>
            <% if (roleId == 1) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/car" class="nav-link"><span class="nav-icon">🚙</span><span>车辆管理</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driver" class="nav-link"><span class="nav-icon">👨‍✈️</span><span>司机管理</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/userManage" class="nav-link"><span class="nav-icon">👤</span><span>用户管理</span></a></li>
            <% } %>
        </nav>
    </aside>

    <header class="header">
        <div class="header-left">
            <h1 class="header-title">我的接单</h1>
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
        <div class="data-card">
            <% if (tasks != null && !tasks.isEmpty()) { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>派车单ID</th>
                        <th>申请ID</th>
                        <th>车辆ID</th>
                        <th>用车日期</th>
                        <th>还车日期</th>
                        <th>状态</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CarDispatch task : tasks) { %>
                    <tr>
                        <td>PD-<%= String.format("%06d", task.getId()) %></td>
                        <td>CA-<%= String.format("%06d", task.getApplyId()) %></td>
                        <td><%= task.getCarId() %></td>
                        <td><%= task.getUseDate() != null ? task.getUseDate().toLocalDate() : "-" %></td>
                        <td><%= task.getReturnDate() != null ? task.getReturnDate().toLocalDate() : "-" %></td>
                        <td><span class="status-badge">已派车</span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="icon">🚗</div>
                <p>暂无派车任务</p>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>
