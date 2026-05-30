<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 仪表盘</title>
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
            transition: transform 0.3s ease;
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

        /* 导航菜单 */
        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 6px;
        }

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

        .nav-icon {
            font-size: 17px;
            width: 20px;
            text-align: center;
        }

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

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

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

        .user-info:hover {
            background: #ffffff;
            transform: translateY(-1px);
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

        .user-name {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-primary);
        }

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

        /* 统计卡片 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 18px;
            padding: 24px;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            cursor: pointer;
            box-shadow: var(--glass-shadow);
        }

        .stat-card:hover {
            transform: translateY(-4px);
            background: #ffffff;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.04);
            border-color: rgba(99, 102, 241, 0.2);
        }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 16px;
        }

        .stat-icon.blue { background: rgba(59, 130, 246, 0.08); color: #3b82f6; }
        .stat-icon.green { background: rgba(34, 197, 94, 0.08); color: #22c55e; }
        .stat-icon.purple { background: rgba(168, 85, 247, 0.08); color: #a855f7; }
        .stat-icon.orange { background: rgba(249, 115, 22, 0.08); color: #f97316; }

        .stat-value {
            font-size: 30px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* 数据表格区域 */
        .data-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .section-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 26px;
            box-shadow: var(--glass-shadow);
            transition: all 0.4s ease;
        }

        .section-card:hover {
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.04);
            border-color: rgba(99, 102, 241, 0.15);
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
        }

        .section-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-primary);
            letter-spacing: -0.3px;
        }

        .view-all {
            font-size: 13px;
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .view-all:hover {
            color: var(--accent-hover);
        }

        /* 表格 */
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 13px 16px;
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

        /* 快速操作按钮 */
        .quick-actions {
            display: flex;
            gap: 14px;
            margin-bottom: 28px;
        }

        .action-btn {
            flex: 1;
            padding: 15px 22px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 14px;
            color: var(--text-primary);
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: var(--glass-shadow);
        }

        .action-btn:hover {
            background: #ffffff;
            border-color: rgba(99, 102, 241, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 15px 30px -5px rgba(0, 0, 0, 0.04);
        }

        .action-btn.primary {
            background: linear-gradient(135deg, var(--accent), #4f46e5);
            border-color: transparent;
            color: white;
            box-shadow: 0 10px 25px -5px rgba(99, 102, 241, 0.25);
        }

        .action-btn.primary:hover {
            background: linear-gradient(135deg, var(--accent-hover), #4338ca);
            box-shadow: 0 15px 30px -5px rgba(99, 102, 241, 0.35);
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
    <!-- 奢华缓缓流动的流体动态背景气泡 -->
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
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/index" class="nav-link active">
                    <span class="nav-icon">&#x1F4CA;</span>
                    <span>仪表盘</span>
                </a>
            </li>
            <% // 员工(2)、审批人(3)、管理员(1) 可以申请用车
               if (currentUser.getRoleId() == 2 || currentUser.getRoleId() == 3 || currentUser.getRoleId() == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/carApply?action=add" class="nav-link">
                    <span class="nav-icon">&#x1F4DD;</span>
                    <span>用车申请</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/carApply?action=myList" class="nav-link">
                    <span class="nav-icon">&#x1F4CB;</span>
                    <span>我的申请</span>
                </a>
            </li>
            <% } %>
            <% // 审批人(3)、管理员(1) 可以审批
               if (currentUser.getRoleId() == 3 || currentUser.getRoleId() == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/carApply?action=list" class="nav-link">
                    <span class="nav-icon">&#x2705;</span>
                    <span>审批申请</span>
                </a>
            </li>
            <% } %>
            <% // 司机(4)、管理员(1) 可以查看接单和维修
               if (currentUser.getRoleId() == 4 || currentUser.getRoleId() == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/driverTask" class="nav-link">
                    <span class="nav-icon">&#x1F697;</span>
                    <span>我的接单</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/repair" class="nav-link">
                    <span class="nav-icon">&#x1F527;</span>
                    <span>维修事务</span>
                </a>
            </li>
            <% } %>
            <% // 管理员(1) 可以管理车辆、司机、用户
               if (currentUser.getRoleId() == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/car" class="nav-link">
                    <span class="nav-icon">&#x1F698;</span>
                    <span>车辆管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/driver" class="nav-link">
                    <span class="nav-icon">&#x1F468;</span>
                    <span>司机管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/userManage" class="nav-link">
                    <span class="nav-icon">&#x1F464;</span>
                    <span>用户管理</span>
                </a>
            </li>
            <% } %>
        </ul>
    </aside>

    <!-- 头部 -->
    <header class="header">
        <div class="header-left">
            <h1 class="header-title">仪表盘</h1>
        </div>
        <div class="header-right">
            <div class="user-info">
                <div class="user-avatar"><%= currentUser.getName().charAt(0) %></div>
                <span class="user-name"><%= currentUser.getName() %></span>
            </div>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="margin:0;">
                <button type="submit" class="logout-btn">退出登录</button>
            </form>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
        <!-- 快速操作按钮 -->
        <div class="quick-actions">
            <% if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 2 || currentUser.getRoleId() == 3) { %>
            <button class="action-btn primary" onclick="location.href='<%= request.getContextPath() %>/carApply?action=add'">
                <span>📝</span>
                <span>新建用车申请</span>
            </button>
            <button class="action-btn" onclick="location.href='<%= request.getContextPath() %>/carApply?action=myList'">
                <span>📋</span>
                <span>我的申请</span>
            </button>
            <% } %>
            <% if (currentUser.getRoleId() == 1 || currentUser.getRoleId() == 3) { %>
            <button class="action-btn" onclick="location.href='<%= request.getContextPath() %>/carApply?action=list'">
                <span>✅</span>
                <span>审批申请</span>
            </button>
            <% } %>
            <% if (currentUser.getRoleId() == 4) { %>
            <button class="action-btn primary" onclick="location.href='<%= request.getContextPath() %>/driverTask'">
                <span>&#x1F697;</span>
                <span>查看我的接单</span>
            </button>
            <button class="action-btn" onclick="location.href='<%= request.getContextPath() %>/repair'">
                <span>🔧</span>
                <span>维修事务</span>
            </button>
            <% } %>
            <% if (currentUser.getRoleId() == 1) { %>
            <button class="action-btn" onclick="location.href='<%= request.getContextPath() %>/userManage'">
                <span>&#x1F464;</span>
                <span>用户管理</span>
            </button>
            <% } %>
        </div>

        <!-- 统计卡片 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue">📝</div>
                <div class="stat-value">128</div>
                <div class="stat-label">本月申请</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">✅</div>
                <div class="stat-value">96</div>
                <div class="stat-label">已审批</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple">🚙</div>
                <div class="stat-value">24</div>
                <div class="stat-label">可用车辆</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">👨‍✈️</div>
                <div class="stat-value">18</div>
                <div class="stat-label">在岗司机</div>
            </div>
        </div>

        <!-- 数据区域 -->
        <div class="data-section">
            <!-- 待审批申请 -->
            <div class="section-card">
                <div class="section-header">
                    <h2 class="section-title">待审批申请</h2>
                    <a href="<%= request.getContextPath() %>/carApply?action=list&status=待审批" class="view-all">查看全部 →</a>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>申请编号</th>
                            <th>申请人</th>
                            <th>用车日期</th>
                            <th>状态</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>CA-2024-001</td>
                            <td>张三</td>
                            <td>2024-06-15</td>
                            <td><span class="status-badge status-pending">待审批</span></td>
                        </tr>
                        <tr>
                            <td>CA-2024-002</td>
                            <td>李四</td>
                            <td>2024-06-16</td>
                            <td><span class="status-badge status-pending">待审批</span></td>
                        </tr>
                        <tr>
                            <td>CA-2024-003</td>
                            <td>王五</td>
                            <td>2024-06-17</td>
                            <td><span class="status-badge status-pending">待审批</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- 最近派车单 -->
            <div class="section-card">
                <div class="section-header">
                    <h2 class="section-title">最近派车</h2>
                    <a href="#" class="view-all">查看全部 →</a>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>派车单编号</th>
                            <th>车辆</th>
                            <th>司机</th>
                            <th>状态</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>PD-2024-001</td>
                            <td>京A-12345</td>
                            <td>张司机</td>
                            <td><span class="status-badge status-dispatched">已派车</span></td>
                        </tr>
                        <tr>
                            <td>PD-2024-002</td>
                            <td>京B-67890</td>
                            <td>李司机</td>
                            <td><span class="status-badge status-approved">执行中</span></td>
                        </tr>
                        <tr>
                            <td>PD-2024-003</td>
                            <td>京C-11111</td>
                            <td>王司机</td>
                            <td><span class="status-badge status-approved">执行中</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <!-- 深色鼠标光标 + 点击特效 -->
    <div id="cursor-dot"></div><div id="cursor-ring"></div>
    <script>
        // 深色流体光标
        const dot = document.getElementById('cursor-dot');
        const ring = document.getElementById('cursor-ring');
        let mouseX = -100, mouseY = -100, ringX = -100, ringY = -100;
        
        window.addEventListener('mousemove', e => { 
            mouseX = e.clientX; mouseY = e.clientY; 
            dot.style.transform = `translate(${mouseX}px, ${mouseY}px) translate(-50%, -50%)`;
        });
        
        const renderCursor = () => {
            ringX += (mouseX - ringX) * 0.12; 
            ringY += (mouseY - ringY) * 0.12;
            ring.style.transform = `translate(${ringX}px, ${ringY}px) translate(-50%, -50%)`;
            requestAnimationFrame(renderCursor);
        };
        requestAnimationFrame(renderCursor);

        // 悬停效果 - 按钮/链接变大光圈
        document.querySelectorAll('a, button, .btn, .nav-link, .action-btn, .user-info, input, textarea, select').forEach(el => {
            el.addEventListener('mouseenter', () => ring.classList.add('hover'));
            el.addEventListener('mouseleave', () => ring.classList.remove('hover'));
        });

        // 点击涟漪 + 粒子爆炸特效
        document.addEventListener('mousedown', e => {
            ring.classList.add('click');
            // 涟漪
            const ripple = document.createElement('div');
            ripple.className = 'click-ripple';
            ripple.style.left = e.clientX + 'px';
            ripple.style.top = e.clientY + 'px';
            document.body.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);
            // 粒子
            for (let i = 0; i < 6; i++) {
                const p = document.createElement('div');
                p.className = 'click-particle';
                p.style.left = e.clientX + 'px';
                p.style.top = e.clientY + 'px';
                const angle = (Math.PI * 2 / 6) * i + Math.random() * 0.5;
                const dist = 20 + Math.random() * 30;
                p.style.setProperty('--px', Math.cos(angle) * dist + 'px');
                p.style.setProperty('--py', Math.sin(angle) * dist + 'px');
                document.body.appendChild(p);
                setTimeout(() => p.remove(), 500);
            }
        });
        document.addEventListener('mouseup', () => ring.classList.remove('click'));
    </script>
</body>
</html>