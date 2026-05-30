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
    <title>公司用车管理系统 - 新建用车申请</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/car_apply_add.css">
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
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/index" class="nav-link">
                    <span class="nav-icon">&#x1F4CA;</span>
                    <span>仪表盘</span>
                </a>
            </li>
            <% int roleId = currentUser.getRoleId();
               if (roleId == 2 || roleId == 3 || roleId == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/carApply?action=add" class="nav-link active">
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
            <% if (roleId == 3 || roleId == 1) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/carApply?action=list" class="nav-link">
                    <span class="nav-icon">&#x2705;</span>
                    <span>审批申请</span>
                </a>
            </li>
            <% } %>
            <% if (roleId == 4 || roleId == 1) { %>
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
            <% if (roleId == 1) { %>
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

    <header class="header">
        <div class="header-left">
            <h1 class="header-title">新建用车申请</h1>
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

    <main class="main-content">
        <div class="form-card">
            <div class="form-header">
                <h2>填写用车申请信息</h2>
                <p>请完整填写以下信息，提交后将等待审批</p>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error" style="background: #fee2e2; color: #dc2626; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success" style="background: #dcfce7; color: #166534; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
                        <%= request.getAttribute("message") %>
                    </div>
                <% } %>
            </div>

            <form action="<%= request.getContextPath() %>/carApply?action=submit" method="post">
                <div class="form-group">
                    <label>往返类型</label>
                    <div style="display: flex; gap: 20px;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                            <input type="radio" name="tripType" value="单程" checked> 单程
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                            <input type="radio" name="tripType" value="往返"> 往返
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label>用车原因</label>
                    <select class="form-control" name="reason" id="reasonSelect" onchange="updateReasonInput()" style="margin-bottom: 8px;">
                        <option value="">-- 选择用车原因模板 --</option>
                        <option value="客户拜访">客户拜访</option>
                        <option value="商务出差">商务出差</option>
                        <option value="机场接送">机场接送</option>
                        <option value="会议活动">会议活动</option>
                        <option value="考察调研">考察调研</option>
                        <option value="其他">其他（自定义）</option>
                    </select>
                    <input type="text" class="form-control" name="reason" id="reasonInput" placeholder="请输入用车原因，如：客户拜访、商务出差等" required>
                </div>

                <div class="form-group">
                    <label>目的地（南昌地区）</label>
                    <input type="text" class="form-control" name="destination" list="destinationList" placeholder="请输入目的地或从列表选择" required>
                    <datalist id="destinationList">
                        <option value="南昌市政府">
                        <option value="红谷滩区行政中心">
                        <option value="南昌昌北机场">
                        <option value="南昌火车站">
                        <option value="南昌西站">
                        <option value="高新区管委会">
                        <option value="经开区管委会">
                        <option value="青山湖区政务中心">
                        <option value="西湖区政务中心">
                        <option value="东湖区政务中心">
                        <option value="青云谱区政务中心">
                        <option value="南昌大学">
                        <option value="江西师范大学">
                        <option value="南昌工程学院">
                        <option value="江西财经大学">
                        <option value="南昌航空大学">
                        <option value="华东交通大学">
                        <option value="江西省人民医院">
                        <option value="南昌大学第一附属医院">
                        <option value="江西省妇幼保健院">
                        <option value="南昌国际展览中心">
                        <option value="江西省会议中心">
                        <option value="南昌万达广场">
                        <option value="南昌铜锣湾广场">
                        <option value="八一广场">
                        <option value="滕王阁">
                        <option value="秋水广场">
                    </datalist>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>用车日期</label>
                        <input type="datetime-local" class="form-control" name="useDate" required>
                    </div>
                    <div class="form-group">
                        <label>预计还车日期</label>
                        <input type="datetime-local" class="form-control" name="returnDate" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>乘车人数</label>
                    <input type="number" class="form-control" name="passengerCount" min="1" max="20" placeholder="请输入乘车人数" required>
                </div>

                <div class="form-group">
                    <label>备注说明（选填）</label>
                    <textarea class="form-control" name="remark" placeholder="如有特殊需求，请在此说明"></textarea>
                </div>

                <div class="btn-group">
                    <button type="button" class="btn btn-secondary" onclick="location.href='<%= request.getContextPath() %>/carApply?action=list'">取消</button>
                    <button type="submit" class="btn btn-primary">提交申请</button>
                </div>
            </form>
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
        document.querySelectorAll('a, button, .btn, .nav-link, .user-info, input, textarea, select').forEach(el => {
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

        // 用车原因模板选择功能
        function updateReasonInput() {
            const select = document.getElementById('reasonSelect');
            const input = document.getElementById('reasonInput');
            const selectedValue = select.value;
            if (selectedValue && selectedValue !== '其他') {
                input.value = selectedValue;
            } else if (selectedValue === '其他') {
                input.value = '';
                input.focus();
            }
        }
    </script>

</body>
</html>