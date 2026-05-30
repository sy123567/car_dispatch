<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.CarApply" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<CarApply> applyList = (List<CarApply>) request.getAttribute("applies");
    String status = (String) request.getAttribute("status");
    int roleId = currentUser.getRoleId();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 用车申请列表</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(255, 255, 255, 0.65);
            --glass-shadow: 0 15px 35px -10px rgba(0, 0, 0, 0.03);
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --accent: #6366f1;
            --accent-hover: #4f46e5;
            --sidebar-width: 260px;
            --header-height: 70px;
        }

        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            overflow-x: hidden;
            position: relative;
        }

        /* 奢华缓缓流动的流体动态背景气泡 */
        .bg-gradient {
            position: fixed;
            width: 100%;
            height: 100%;
            overflow: hidden;
            top: 0;
            left: 0;
            pointer-events: none;
            z-index: 1;
        }

        .fluid-blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(100px);
            mix-blend-mode: multiply;
            animation: fluid-dance 25s infinite ease-in-out;
            opacity: 0.5;
        }

        .blob-1 {
            width: 600px;
            height: 600px;
            background: rgba(165, 180, 252, 0.35);
            top: -10%;
            left: -5%;
            animation-delay: 0s;
        }

        .blob-2 {
            width: 700px;
            height: 700px;
            background: rgba(244, 143, 177, 0.2);
            bottom: -10%;
            right: -5%;
            animation-delay: 5s;
        }

        .blob-3 {
            width: 500px;
            height: 500px;
            background: rgba(103, 232, 249, 0.3);
            top: 35%;
            left: 40%;
            animation-delay: 10s;
        }

        @keyframes fluid-dance {
            0%, 100% {
                transform: translate(0, 0) scale(1) rotate(0deg);
            }
            33% {
                transform: translate(30px, -50px) scale(1.1) rotate(120deg);
            }
            66% {
                transform: translate(-20px, 40px) scale(0.95) rotate(240deg);
            }
        }

        /* 侧边栏 */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: var(--sidebar-width);
            height: 100vh;
            background: rgba(255, 255, 255, 0.55);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-right: 1px solid var(--glass-border);
            padding: 24px;
            z-index: 100;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 14px;
            padding-bottom: 24px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            margin-bottom: 24px;
        }

        .logo-circle {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--accent), #818cf8);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            box-shadow: 0 8px 20px -5px rgba(99, 102, 241, 0.3);
            color: white;
        }

        .logo-text {
            font-size: 17px;
            font-weight: 600;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }

        .nav-menu { list-style: none; }

        .nav-item { margin-bottom: 6px; }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 16px;
            border-radius: 10px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .nav-link:hover {
            background: rgba(0, 0, 0, 0.03);
            color: var(--text-primary);
        }

        .nav-link.active {
            background: #ffffff;
            color: var(--accent);
            box-shadow: 0 4px 15px -3px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--glass-border);
        }

        .nav-icon { font-size: 17px; width: 20px; text-align: center; }

        /* 头部 */
        .header {
            position: fixed;
            left: var(--sidebar-width);
            top: 0;
            right: 0;
            height: var(--header-height);
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-bottom: 1px solid var(--glass-border);
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 90;
        }

        .header-title { font-size: 18px; font-weight: 600; color: var(--text-primary); letter-spacing: -0.5px; }

        .header-right { display: flex; align-items: center; gap: 20px; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 7px 14px;
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            background: linear-gradient(135deg, var(--accent), #818cf8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: 600;
        }

        .user-name { font-size: 13px; font-weight: 500; color: var(--text-primary); }

        .logout-btn {
            padding: 7px 16px;
            background: rgba(239, 68, 68, 0.05);
            border: 1px solid rgba(239, 68, 68, 0.15);
            border-radius: 8px;
            color: #dc2626;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.1);
            transform: translateY(-1px);
        }

        /* 主内容区 */
        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--header-height);
            padding: 32px;
            min-height: calc(100vh - var(--header-height));
            position: relative;
            z-index: 10;
        }

        /* 操作栏 */
        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .btn-primary {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--accent), #4f46e5);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 25px -5px rgba(99, 102, 241, 0.25);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent-hover), #4338ca);
            transform: translateY(-2px);
            box-shadow: 0 15px 30px -5px rgba(99, 102, 241, 0.35);
        }

        .search-box {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-input {
            padding: 11px 16px;
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(0, 0, 0, 0.07);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
            width: 250px;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            background: #ffffff;
            border-color: var(--accent);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.08);
        }

        .filter-select {
            padding: 11px 16px;
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(0, 0, 0, 0.07);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
            cursor: pointer;
            outline: none;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            background: #ffffff;
            border-color: var(--accent);
        }

        /* 数据卡片 */
        .data-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 26px;
            box-shadow: var(--glass-shadow);
            transition: all 0.4s ease;
        }

        .data-card:hover {
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.04);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th, .data-table td {
            padding: 14px 16px;
            text-align: left;
            font-size: 13px;
        }

        .data-table th {
            color: var(--text-secondary);
            font-weight: 600;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            background: rgba(0, 0, 0, 0.01);
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.5px;
        }

        .data-table td {
            color: var(--text-primary);
            border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            transition: background 0.2s ease;
        }

        .data-table tbody tr:hover td {
            background: rgba(0, 0, 0, 0.015);
        }

        /* 状态标签 */
        .status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending { background: rgba(245, 158, 11, 0.08); color: #d97706; border: 1px solid rgba(245, 158, 11, 0.15); }
        .status-approved { background: rgba(16, 185, 129, 0.08); color: #059669; border: 1px solid rgba(16, 185, 129, 0.15); }
        .status-rejected { background: rgba(239, 68, 68, 0.08); color: #dc2626; border: 1px solid rgba(239, 68, 68, 0.15); }
        .status-dispatched { background: rgba(59, 130, 246, 0.08); color: #2563eb; border: 1px solid rgba(59, 130, 246, 0.15); }

        /* 操作按钮 */
        .action-btns { display: flex; gap: 8px; }

        .action-btn {
            padding: 6px 12px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .action-btn.view {
            color: var(--accent);
            background: rgba(99, 102, 241, 0.05);
            border-color: rgba(99, 102, 241, 0.1);
        }

        .action-btn.view:hover {
            background: var(--accent);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        }

        .action-btn.approve {
            color: #059669;
            background: rgba(16, 185, 129, 0.05);
            border-color: rgba(16, 185, 129, 0.1);
        }

        .action-btn.approve:hover {
            background: #10b981;
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }

        .action-btn.reject {
            color: #dc2626;
            background: rgba(239, 68, 68, 0.05);
            border-color: rgba(239, 68, 68, 0.1);
        }

        .action-btn.reject:hover {
            background: #ef4444;
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }

        .action-btn:hover { transform: translateY(-1px); }

        /* 分页 */
        .pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 24px;
        }

        .page-btn {
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            color: var(--text-secondary);
            font-weight: 500;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .page-btn.active {
            background: var(--accent);
            border-color: transparent;
            color: white;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        }

        .page-btn:hover:not(.active) {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.1);
            color: var(--text-primary);
        }
        /* =========================================
           UI/UX PRO MAX ENGINE (Apple Vision / Magnetic)
           ========================================= */
        .pro-glass {
            position: relative; 
            overflow: hidden;
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.4s ease;
            will-change: transform, box-shadow;
            transform-style: preserve-3d;
        }
        .pro-glass::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(800px circle at var(--mouse-x, 0) var(--mouse-y, 0), rgba(255,255,255,0.8), transparent 40%);
            opacity: 0; transition: opacity 0.5s; pointer-events: none; z-index: 1;
        }
        .pro-glass:hover::before { opacity: 1; }
        .pro-glass:hover {
            box-shadow: 0 30px 60px -10px rgba(99, 102, 241, 0.3), 0 0 20px rgba(255, 255, 255, 0.6) inset;
            z-index: 50;
        }
        
        /* Custom Fluid Cursor */
        #cursor-dot, #cursor-ring {
            position: fixed; top: 0; left: 0; pointer-events: none; z-index: 99999;
            transform: translate(-50%, -50%); border-radius: 50%;
        }
        #cursor-dot { 
            width: 8px; height: 8px; background: var(--accent); 
            transition: background 0.3s, transform 0.1s, width 0.3s, height 0.3s; 
            box-shadow: 0 0 15px var(--accent); 
        }
        #cursor-ring { 
            width: 40px; height: 40px; border: 2px solid rgba(99, 102, 241, 0.4); 
            transition: transform 0.15s ease-out, border-color 0.3s, width 0.3s, height 0.3s; 
        }
        
        /* Apple VisionOS Floating Layout */
        .sidebar { 
            left: 16px !important; top: 16px !important; height: calc(100vh - 32px) !important; 
            border-radius: 24px !important; box-shadow: 0 20px 50px rgba(0,0,0,0.08) !important; 
            border: 1px solid rgba(255,255,255,0.8) !important;
        }
        .header { 
            left: calc(var(--sidebar-width) + 32px) !important; top: 16px !important; right: 16px !important; 
            border-radius: 24px !important; box-shadow: 0 10px 30px rgba(0,0,0,0.05) !important; 
            border: 1px solid rgba(255,255,255,0.8) !important; width: auto !important; transition: all 0.3s !important; 
        }
        .main-content { 
            margin-left: calc(var(--sidebar-width) + 16px) !important; 
            margin-top: calc(var(--header-height) + 16px) !important; 
        }
        
        /* Micro-interactions */
        input:focus, select:focus { 
            transform: scale(1.02); box-shadow: 0 10px 25px rgba(99,102,241,0.15); 
        }
        tbody tr { transition: transform 0.3s ease, background 0.3s ease, box-shadow 0.3s ease; }
        tbody tr:hover { 
            transform: scale(1.01) translateY(-2px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            border-radius: 12px;
            background: #ffffff !important;
            z-index: 10; position: relative;
        }
        
        
    </style>
</head>
<body>
    <!-- 奢华流体背景气泡 -->
    <div class="bg-gradient">
        <div class="fluid-blob blob-1"></div>
        <div class="fluid-blob blob-2"></div>
        <div class="fluid-blob blob-3"></div>
    </div>

    <!-- 侧边栏 -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-circle">🚗</div>
            <span class="logo-text">用车管理</span>
        </div>
        <nav class="nav-menu">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/index" class="nav-link"><span class="nav-icon">📊</span>仪表盘</a></li>
            <% if (roleId == 1 || roleId == 2 || roleId == 3) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=add" class="nav-link"><span class="nav-icon">📝</span>用车申请</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=myList" class="nav-link"><span class="nav-icon">📋</span>我的申请</a></li>
            <% } %>
            <% if (roleId == 1 || roleId == 3) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=list" class="nav-link active"><span class="nav-icon">✅</span>审批申请</a></li>
            <% } %>
            <% if (roleId == 4 || roleId == 1) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driverTask" class="nav-link"><span class="nav-icon">🚗</span>我的接单</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/repair" class="nav-link"><span class="nav-icon">🔧</span>维修事务</a></li>
            <% } %>
            <% if (roleId == 1) { %>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/car" class="nav-link"><span class="nav-icon">🚙</span>车辆管理</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driver" class="nav-link"><span class="nav-icon">👨‍✈️</span>司机管理</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/userManage" class="nav-link"><span class="nav-icon">👤</span>用户管理</a></li>
            <% } %>
        </nav>
    </aside>

    <!-- 头部 -->
    <header class="header">
        <div class="header-left">
            <h1 class="header-title">用车申请列表</h1>
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

    <!-- 主内容区 -->
    <main class="main-content">
        <div class="toolbar">
            <button class="btn-primary" onclick="location.href='<%= request.getContextPath() %>/carApply?action=add'">
                <span>📝</span>新建申请
            </button>
            <form method="get" action="<%= request.getContextPath() %>/carApply" style="display: flex; gap: 10px; flex: 1; max-width: 600px;">
                <input type="hidden" name="action" value="list">
                <input type="text" name="keyword" class="search-input" placeholder="搜索申请编号/申请人/目的地/原因" 
                    value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>" 
                    style="flex: 1; padding: 10px 15px; border: 1px solid #e2e8f0; border-radius: 8px;">
                <select name="status" class="filter-select" style="padding: 10px 15px; border: 1px solid #e2e8f0; border-radius: 8px;">
                    <option value="">全部状态</option>
                    <option value="待审批" <%= "待审批".equals(request.getAttribute("status")) ? "selected" : "" %>>待审批</option>
                    <option value="已通过" <%= "已通过".equals(request.getAttribute("status")) ? "selected" : "" %>>已通过</option>
                    <option value="已拒绝" <%= "已拒绝".equals(request.getAttribute("status")) ? "selected" : "" %>>已拒绝</option>
                    <option value="已派车" <%= "已派车".equals(request.getAttribute("status")) ? "selected" : "" %>>已派车</option>
                </select>
                <button type="submit" class="btn-secondary" style="padding: 10px 20px;">搜索</button>
                <a href="<%= request.getContextPath() %>/carApply?action=list" class="btn-secondary" style="padding: 10px 20px; text-decoration: none; display: inline-flex; align-items: center;">重置</a>
            </form>
        </div>

        <div class="data-card">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>申请编号</th>
                        <th>申请人</th>
                        <th>用车日期</th>
                        <th>目的地</th>
                        <th>乘车人数</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (applyList != null && !applyList.isEmpty()) { %>
                        <% for (CarApply apply : applyList) { %>
                        <tr>
                            <td>CA-<%= String.format("%06d", apply.getApplyId()) %></td>
                            <td><%= apply.getEmployeeId() %></td>
                            <td><%= apply.getUseDate() != null ? apply.getUseDate().toLocalDate() : "-" %></td>
                            <td><%= apply.getDestination() != null ? apply.getDestination() : "-" %></td>
                            <td><%= apply.getPassengerCount() %></td>
                            <td>
                                <span class="status-badge 
                                    <%= apply.getApplyStatus().equals("待审批") ? "status-pending" : 
                                       apply.getApplyStatus().equals("已通过") || apply.getApplyStatus().equals("审批通过") ? "status-approved" :
                                       apply.getApplyStatus().equals("已拒绝") ? "status-rejected" : "status-dispatched" %>">
                                    <%= apply.getApplyStatus() %>
                                </span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <button class="action-btn view">查看</button>
                                    <% if ((roleId == 3 || roleId == 1) && "待审批".equals(apply.getApplyStatus())) { %>
                                    <form action="${pageContext.request.contextPath}/carApply" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="applyId" value="<%= apply.getApplyId() %>">
                                        <input type="hidden" name="status" value="已通过">
                                        <input type="hidden" name="comment" value="同意">
                                        <button type="submit" class="action-btn approve">通过</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/carApply" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="applyId" value="<%= apply.getApplyId() %>">
                                        <input type="hidden" name="status" value="已拒绝">
                                        <input type="hidden" name="comment" value="驳回">
                                        <button type="submit" class="action-btn reject">拒绝</button>
                                    </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="7" style="text-align:center; color: var(--text-secondary); padding: 40px;">暂无数据</td></tr>
                    <% } %>
                </tbody>
            </table>

            <div class="pagination">
                <% 
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    String keyword = (String) request.getAttribute("keyword");
                    String status = (String) request.getAttribute("status");
                    if (currentPage == null) currentPage = 1;
                    if (totalPages == null) totalPages = 1;
                %>
                <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath() %>/carApply?action=list&page=<%= currentPage - 1 %>&keyword=<%= keyword != null ? keyword : "" %>&status=<%= status != null ? status : "" %>" class="page-btn">上一页</a>
                <% } else { %>
                    <span class="page-btn disabled">上一页</span>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="<%= request.getContextPath() %>/carApply?action=list&page=<%= i %>&keyword=<%= keyword != null ? keyword : "" %>&status=<%= status != null ? status : "" %>" 
                       class="page-btn <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                <% } %>
                <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath() %>/carApply?action=list&page=<%= currentPage + 1 %>&keyword=<%= keyword != null ? keyword : "" %>&status=<%= status != null ? status : "" %>" class="page-btn">下一页</a>
                <% } else { %>
                    <span class="page-btn disabled">下一页</span>
                <% } %>
                <span style="margin-left: 15px; color: var(--text-secondary);">
                    共 <%= request.getAttribute("totalCount") %> 条记录，第 <%= currentPage %> / <%= totalPages %> 页
                </span>
            </div>
        </div>
    </main>
    <!-- =========================================
         UI/UX PRO MAX ENGINE SCRIPTS
         ========================================= -->
    <div id="cursor-dot"></div><div id="cursor-ring"></div>
    <script>
        // 1. Fluid Custom Cursor
        const dot = document.getElementById('cursor-dot');
        const ring = document.getElementById('cursor-ring');
        let mouseX = -100, mouseY = -100, ringX = -100, ringY = -100, isHover = false;
        
        window.addEventListener('mousemove', e => { 
            mouseX = e.clientX; mouseY = e.clientY; 
            dot.style.transform = `translate(${mouseX}px, ${mouseY}px) translate(-50%, -50%) ${isHover ? 'scale(1.5)' : 'scale(1)'}`; 
        });
        
        const renderCursor = () => {
            ringX += (mouseX - ringX) * 0.15; 
            ringY += (mouseY - ringY) * 0.15;
            ring.style.transform = `translate(${ringX}px, ${ringY}px) translate(-50%, -50%) ${isHover ? 'scale(1.5)' : 'scale(1)'}`;
            requestAnimationFrame(renderCursor);
        };
        requestAnimationFrame(renderCursor);

        // 2. Apple Vision 3D Tilt & Dynamic Glare
        document.querySelectorAll('.glass-card, .stat-card, .panel, .resource-card, .data-card, .section-card').forEach(el => {
            el.classList.add('pro-glass');
            el.addEventListener('mousemove', e => {
                const rect = el.getBoundingClientRect();
                const x = e.clientX - rect.left; 
                const y = e.clientY - rect.top;
                el.style.setProperty('--mouse-x', `${x}px`); 
                el.style.setProperty('--mouse-y', `${y}px`);
                
                const rotX = ((y - rect.height / 2) / rect.height) * -10;
                const rotY = ((x - rect.width / 2) / rect.width) * 10;
                el.style.transform = `perspective(1200px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale3d(1.02, 1.02, 1.02)`;
            });
            el.addEventListener('mouseleave', () => { 
                el.style.transform = `perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)`; 
            });
        });

        // 3. Magnetic Hover Physics
        document.querySelectorAll('.btn-primary, .action-btn, .nav-link, .user-info').forEach(btn => {
            btn.addEventListener('mousemove', e => {
                const rect = btn.getBoundingClientRect();
                const x = e.clientX - rect.left - rect.width / 2;
                const y = e.clientY - rect.top - rect.height / 2;
                btn.style.transform = `translate(${x * 0.25}px, ${y * 0.25}px) scale(1.05)`;
            });
            btn.addEventListener('mouseleave', () => { 
                btn.style.transform = `translate(0px, 0px) scale(1)`; 
                isHover = false; 
                dot.style.background = 'var(--accent)'; 
                ring.style.borderColor = 'rgba(99, 102, 241, 0.4)';
                dot.style.width = '8px'; dot.style.height = '8px';
            });
            btn.addEventListener('mouseenter', () => { 
                isHover = true; 
                dot.style.background = '#f48fb1'; 
                ring.style.borderColor = '#f48fb1'; 
                dot.style.width = '12px'; dot.style.height = '12px';
            });
        });
    </script>
</body>
</html>