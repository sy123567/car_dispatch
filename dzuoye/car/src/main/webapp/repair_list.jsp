<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.RepairApply" %>
<%@ page import="entity.Car" %>
<%@ page import="entity.RepairUnit" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    int roleId = currentUser.getRoleId();
    List<RepairApply> repairs = (List<RepairApply>) request.getAttribute("repairs");
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    List<RepairUnit> units = (List<RepairUnit>) request.getAttribute("units");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 维修事务</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/repair_list.css">
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
            <li class="nav-item"><a href="${pageContext.request.contextPath}/driverTask" class="nav-link"><span class="nav-icon">🚗</span><span>我的接单</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/repair" class="nav-link active"><span class="nav-icon">🔧</span><span>维修事务</span></a></li>
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
            <h1 class="header-title">维修事务</h1>
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
        <% if (request.getAttribute("message") != null) { %>
            <div style="margin:0 0 16px; padding:12px 16px; background:rgba(52,199,89,.15); border:1px solid rgba(52,199,89,.4); border-radius:10px; color:#1f8a3b;"><%= request.getAttribute("message") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div style="margin:0 0 16px; padding:12px 16px; background:#fee2e2; border:1px solid #fca5a5; border-radius:10px; color:#dc2626;"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (roleId == 4) { %>
        <div style="margin-bottom:16px;">
            <button class="btn-primary" onclick="openRepairModal()" style="padding:10px 20px;"><span>🔧</span> 新增报修</button>
        </div>
        <% } %>

        <div class="data-card">
            <% if (repairs != null && !repairs.isEmpty()) { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>工单号</th>
                        <th>车辆ID</th>
                        <th>故障描述</th>
                        <th>维修单位</th>
                        <th>维修总费用</th>
                        <th>申请时间</th>
                        <th>审批状态</th>
                        <% if (roleId == 4) { %><th>操作</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (RepairApply repair : repairs) { %>
                    <tr>
                        <td><%= repair.getWorkOrderNo() %></td>
                        <td><%= repair.getCarId() %></td>
                        <td><%= repair.getFaultDesc() %></td>
                        <td><%= repair.getRepairUnitName() != null ? repair.getRepairUnitName() : "—" %></td>
                        <td><%= repair.getTotalCost() != null ? "￥" + repair.getTotalCost() : "—" %></td>
                        <td><%= repair.getApplyTime() != null ? repair.getApplyTime().toString().replace("T", " ") : "—" %></td>
                        <td>
                            <span class="status-badge <%= "待审批".equals(repair.getApproveStatus()) ? "status-pending" : 
                                                         "已通过".equals(repair.getApproveStatus()) ? "status-approved" : "status-rejected" %>">
                                <%= repair.getApproveStatus() %>
                            </span>
                        </td>
                        <% if (roleId == 4) { %>
                        <td>
                            <% if ("待审批".equals(repair.getApproveStatus())) { %>
                            <form action="${pageContext.request.contextPath}/repair" method="post" style="margin:0;" onsubmit="return confirm('确认取消该报修申请？');">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="workOrderNo" value="<%= repair.getWorkOrderNo() %>">
                                <button type="submit" style="padding:6px 14px; border:1px solid #fca5a5; background:#fff; color:#dc2626; border-radius:8px; cursor:pointer;">取消</button>
                            </form>
                            <% } else { %>—<% } %>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="icon">🔧</div>
                <p>暂无维修事务记录</p>
            </div>
            <% } %>
        </div>
    </main>

    <!-- 新增报修 弹窗 -->
    <div id="repairModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:9999; align-items:center; justify-content:center;">
        <div style="background:#fff; border-radius:16px; padding:28px; width:460px; max-width:92vw; box-shadow:0 20px 60px rgba(0,0,0,.3);">
            <h3 style="margin:0 0 18px; color:#1d1d1f;">新增报修申请</h3>
            <form action="${pageContext.request.contextPath}/repair" method="post">
                <input type="hidden" name="action" value="submit">
                <div style="display:flex; flex-direction:column; gap:12px;">
                    <label>报修车辆
                        <select name="carId" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; margin-top:4px;">
                            <option value="">请选择车辆</option>
                            <% if (cars != null) { for (Car c : cars) { %>
                            <option value="<%= c.getId() %>"><%= c.getLicensePlate() %><%= c.getBrand() != null ? " - " + c.getBrand() : "" %></option>
                            <% } } %>
                        </select>
                    </label>
                    <label>故障描述<textarea name="faultDesc" required rows="3" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; margin-top:4px;" placeholder="请描述车辆故障情况"></textarea></label>
                    <label>维修单位（选填）
                        <select name="repairUnitName" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; margin-top:4px;">
                            <option value="">不指定</option>
                            <% if (units != null) { for (RepairUnit u : units) { %>
                            <option value="<%= u.getUnitName() %>"><%= u.getUnitName() %></option>
                            <% } } %>
                        </select>
                    </label>
                    <label>维修总费用（选填）<input name="totalCost" type="number" step="0.01" min="0" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; margin-top:4px;"></label>
                </div>
                <div style="display:flex; gap:12px; justify-content:flex-end; margin-top:22px;">
                    <button type="button" onclick="closeRepairModal()" style="padding:10px 20px; border:1px solid #ddd; background:#fff; border-radius:8px; cursor:pointer;">取消</button>
                    <button type="submit" class="btn-primary" style="padding:10px 20px;">提交报修</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        function openRepairModal() { document.getElementById('repairModal').style.display = 'flex'; }
        function closeRepairModal() { document.getElementById('repairModal').style.display = 'none'; }
    </script>
</body>
</html>
