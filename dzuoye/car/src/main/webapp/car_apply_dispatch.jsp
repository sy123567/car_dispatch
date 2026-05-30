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
    <title>用车申请与调度管理</title>
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

        .user-info:hover { background: rgba(255, 255, 255, 0.1); }

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

        .logout-btn:hover { background: rgba(239, 68, 68, 0.25); }

        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--header-height);
            padding: 32px;
            min-height: calc(100vh - var(--header-height));
            position: relative;
            z-index: 10;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
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

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .panel {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 26px;
            margin-bottom: 24px;
            box-shadow: var(--glass-shadow);
            transition: all 0.4s ease;
        }

        .panel:hover {
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.04);
            border-color: rgba(99, 102, 241, 0.15);
        }

        .panel-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .panel-title h2 {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .badge {
            padding: 4px 12px;
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            font-size: 11px;
            color: var(--accent);
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(0, 0, 0, 0.07);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background: #ffffff;
            border-color: var(--accent);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.08);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--accent), #4f46e5);
            color: white;
            margin-right: 12px;
            box-shadow: 0 10px 25px -5px rgba(99, 102, 241, 0.25);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent-hover), #4338ca);
            transform: translateY(-2px);
            box-shadow: 0 15px 30px -5px rgba(99, 102, 241, 0.35);
        }

        .btn-light {
            background: rgba(255, 255, 255, 0.45);
            color: var(--text-primary);
            border: 1px solid rgba(0, 0, 0, 0.07);
        }

        .btn-light:hover {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.15);
        }

        .btn-success {
            background: rgba(16, 185, 129, 0.05);
            color: #059669;
            border: 1px solid rgba(16, 185, 129, 0.15);
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-danger {
            background: rgba(239, 68, 68, 0.05);
            color: #dc2626;
            border: 1px solid rgba(239, 68, 68, 0.15);
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 600;
        }

        .timeline {
            position: relative;
            padding-left: 24px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 4px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: rgba(0, 0, 0, 0.05);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 24px;
            padding-left: 20px;
        }

        .timeline-item:last-child { margin-bottom: 0; }

        .timeline-item .dot {
            position: absolute;
            left: -24px;
            top: 4px;
            width: 10px;
            height: 10px;
            background: var(--accent);
            border-radius: 50%;
            border: 2px solid #ffffff;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .timeline-item h3 {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .timeline-item p {
            font-size: 13px;
            color: var(--text-secondary);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th, .data-table td {
            padding: 13px 14px;
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

        .status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }

        .status.pending { background: rgba(245, 158, 11, 0.08); color: #d97706; border: 1px solid rgba(245, 158, 11, 0.15); }
        .status.approved { background: rgba(16, 185, 129, 0.08); color: #059669; border: 1px solid rgba(16, 185, 129, 0.15); }
        .status.rejected { background: rgba(239, 68, 68, 0.08); color: #dc2626; border: 1px solid rgba(239, 68, 68, 0.15); }
        .status.dispatching { background: rgba(59, 130, 246, 0.08); color: #2563eb; border: 1px solid rgba(59, 130, 246, 0.15); }

        .dispatch-card {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .resource-card {
            background: rgba(255, 255, 255, 0.45);
            border-radius: 12px;
            padding: 16px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .resource-card:hover {
            background: #ffffff;
            box-shadow: 0 10px 20px -5px rgba(0, 0, 0, 0.03);
            transform: translateY(-1px);
        }

        .resource-card h3 {
            font-size: 12px;
            font-weight: 600;
            color: var(--accent);
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .resource-card p {
            font-size: 13px;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .resource-card p:last-child { margin-bottom: 0; }
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

    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-circle">🚗</div>
            <span class="logo-text">用车管理</span>
        </div>
        <nav class="nav-menu">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/index" class="nav-link"><span class="nav-icon">📊</span>仪表盘</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=list" class="nav-link"><span class="nav-icon">📝</span>用车申请</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/car" class="nav-link"><span class="nav-icon">🚙</span>车辆管理</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driver" class="nav-link"><span class="nav-icon">👨‍✈️</span>司机管理</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/carApply?action=dispatch" class="nav-link active"><span class="nav-icon">📋</span>派车单管理</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><span class="nav-icon">🔧</span>维修管理</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><span class="nav-icon">📈</span>统计报表</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><span class="nav-icon">⚙️</span>系统设置</a></li>
        </nav>
    </aside>

    <header class="header">
        <div class="header-left">
            <h1 class="header-title">用车申请与自动调度管理</h1>
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
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">18</div>
                <div class="stat-label">今日申请</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">6</div>
                <div class="stat-label">待审批</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">12</div>
                <div class="stat-label">已派车</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">9</div>
                <div class="stat-label">可用车辆</div>
            </div>
        </div>

        <div class="content-grid">
            <div>
                <section class="panel">
                    <div class="panel-title">
                        <h2>提交用车申请</h2>
                        <span class="badge">员工端</span>
                    </div>
                    <form action="${pageContext.request.contextPath}/carApply?action=submit" method="post">
                        <div class="form-group">
                            <label>用车原因</label>
                            <input class="form-control" name="reason" placeholder="请输入用车原因">
                        </div>
                        <div class="form-group">
                            <label>目的地</label>
                            <input class="form-control" name="destination" placeholder="请输入目的地">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>用车日期</label>
                                <input class="form-control" type="datetime-local" name="useTime">
                            </div>
                            <div class="form-group">
                                <label>还车日期</label>
                                <input class="form-control" type="datetime-local" name="returnTime">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>乘车人数</label>
                            <input class="form-control" type="number" name="passengerCount" placeholder="请输入乘车人数">
                        </div>
                        <button type="submit" class="btn btn-primary">提交申请</button>
                        <button type="reset" class="btn btn-light">重置</button>
                    </form>
                </section>

                <section class="panel">
                    <div class="panel-title">
                        <h2>流程状态</h2>
                        <span class="badge">自动流转</span>
                    </div>
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="dot"></div>
                            <div>
                                <h3>员工提交申请</h3>
                                <p>系统生成申请单，状态为待审批。</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="dot"></div>
                            <div>
                                <h3>审批人审核</h3>
                                <p>审批通过后进入自动调度环节。</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="dot"></div>
                            <div>
                                <h3>系统自动派车</h3>
                                <p>自动匹配车辆与司机，生成派车单。</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="dot"></div>
                            <div>
                                <h3>司机执行任务</h3>
                                <p>任务完成后生成用车记录。</p>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <div>
                <section class="panel">
                    <div class="panel-title">
                        <h2>申请与审批列表</h2>
                        <span class="badge">car_apply</span>
                    </div>
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>申请ID</th>
                            <th>申请人</th>
                            <th>目的地</th>
                            <th>用车时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>A20260506001</td>
                            <td>张三</td>
                            <td>高铁站</td>
                            <td>2026-05-06 14:00</td>
                            <td><span class="status pending">待审批</span></td>
                            <td>
                                <button class="btn btn-success">同意</button>
                                <button class="btn btn-danger">驳回</button>
                            </td>
                        </tr>
                        <tr>
                            <td>A20260506002</td>
                            <td>李四</td>
                            <td>客户公司</td>
                            <td>2026-05-06 16:30</td>
                            <td><span class="status approved">审批通过</span></td>
                            <td><button class="btn btn-light">查看</button></td>
                        </tr>
                        <tr>
                            <td>A20260506003</td>
                            <td>王五</td>
                            <td>机场</td>
                            <td>2026-05-07 09:00</td>
                            <td><span class="status dispatching">已派车</span></td>
                            <td><button class="btn btn-light">查看</button></td>
                        </tr>
                        </tbody>
                    </table>
                </section>

                <section class="panel">
                    <div class="panel-title">
                        <h2>自动派车结果</h2>
                        <span class="badge">car_dispatch</span>
                    </div>
                    <div class="dispatch-card">
                        <div class="resource-card">
                            <h3>申请信息</h3>
                            <p>申请单号：A20260506003</p>
                            <p>目的地：机场</p>
                            <p>乘车人数：3人</p>
                        </div>
                        <div class="resource-card">
                            <h3>匹配车辆</h3>
                            <p>车牌号：粤A·88888</p>
                            <p>车型：商务车</p>
                            <p>状态：空闲</p>
                        </div>
                        <div class="resource-card">
                            <h3>匹配司机</h3>
                            <p>司机：赵师傅</p>
                            <p>状态：在岗</p>
                            <p>任务冲突：无</p>
                        </div>
                    </div>
                </section>

                <section class="panel">
                    <div class="panel-title">
                        <h2>司机任务与用车记录</h2>
                        <span class="badge">car_record</span>
                    </div>
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>派车单</th>
                            <th>司机</th>
                            <th>车辆</th>
                            <th>任务状态</th>
                            <th>实际里程</th>
                            <th>油耗</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>D20260506001</td>
                            <td>赵师傅</td>
                            <td>粤A·88888</td>
                            <td><span class="status dispatching">已出发</span></td>
                            <td>--</td>
                            <td>--</td>
                        </tr>
                        <tr>
                            <td>D20260505008</td>
                            <td>陈师傅</td>
                            <td>粤A·66666</td>
                            <td><span class="status approved">已完成</span></td>
                            <td>68km</td>
                            <td>7.5L</td>
                        </tr>
                        </tbody>
                    </table>
                </section>
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