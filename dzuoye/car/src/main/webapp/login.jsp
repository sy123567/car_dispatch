<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公司用车管理系统 - 登录</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
</head>
<body>
    <!-- 奢华流体背景气泡 -->
    <div class="fluid-bg">
        <div class="fluid-blob blob-1"></div>
        <div class="fluid-blob blob-2"></div>
        <div class="fluid-blob blob-3"></div>
    </div>

    <!-- 浮游粒子层 -->
    <div class="fluid-particles">
        <div class="fluid-particle" style="width: 8px; height: 8px; left: 15%; animation-duration: 18s; animation-delay: 0s;"></div>
        <div class="fluid-particle" style="width: 12px; height: 12px; left: 35%; animation-duration: 22s; animation-delay: -3s;"></div>
        <div class="fluid-particle" style="width: 6px; height: 6px; left: 65%; animation-duration: 15s; animation-delay: -7s;"></div>
        <div class="fluid-particle" style="width: 10px; height: 10px; left: 85%; animation-duration: 25s; animation-delay: -2s;"></div>
        <div class="fluid-particle" style="width: 14px; height: 14px; left: 50%; animation-duration: 20s; animation-delay: -5s;"></div>
    </div>

    <!-- SVG 粘性流体融合滤镜 -->
    <svg style="position: absolute; width: 0; height: 0; pointer-events: none;">
        <defs>
            <filter id="gooey-filter">
                <feGaussianBlur in="SourceGraphic" stdDeviation="18" result="blur" />
                <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 25 -10" result="gooey" />
                <feBlend in="SourceGraphic" in2="gooey" />
            </filter>
        </defs>
    </svg>

    <div class="glass-card">
        <div class="logo-section">
            <div class="logo-icon">🚗</div>
            <h1 class="title">公司用车管理</h1>
            <p class="subtitle">Corporate Vehicle Management System</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>账号 / Account</label>
                <input type="text" class="form-control" name="account" placeholder="请输入您的账号" required>
            </div>
            <div class="form-group">
                <label>密码 / Password</label>
                <input type="password" class="form-control" name="password" placeholder="请输入您的密码" required>
            </div>
            <button type="submit" class="btn-primary">登 录</button>
        </form>

        <div class="footer-info">
            <p>建议使用 Chrome / Firefox / Safari / Edge 浏览器</p>
        </div>
    </div>
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
             
        });
        
        const renderCursor = () => {
            ringX += (mouseX - ringX) * 0.15; 
            ringY += (mouseY - ringY) * 0.15;
            ring.style.transform = `translate(${ringX}px, ${ringY}px) translate(-50%, -50%) ${isHover ? 'scale(1.8)' : 'scale(1)'}`;
            requestAnimationFrame(renderCursor);
        };
        requestAnimationFrame(renderCursor);

        // 2. Apple Vision 3D Tilt & Dynamic Glare
        document.querySelectorAll('.form-card, .glass-card, .data-card, .stat-card, .pro-glass, .section-card, .panel, .resource-card').forEach(el => {
            el.classList.add('pro-glass');
            el.addEventListener('mousemove', e => {
                const rect = el.getBoundingClientRect();
                const x = e.clientX - rect.left; 
                const y = e.clientY - rect.top;
                el.style.setProperty('--mouse-x', `${x}px`); 
                el.style.setProperty('--mouse-y', `${y}px`);
                
                const rotX = ((y - rect.height / 2) / rect.height) * -25;
                const rotY = ((x - rect.width / 2) / rect.width) * 25;
                el.style.transform = `perspective(1500px) rotateX(${rotX}deg) rotateY(${rotY}deg) translateZ(40px) scale3d(1.05, 1.05, 1.05)`;
            });
            el.addEventListener('mouseleave', () => { 
                el.style.transform = `perspective(1500px) rotateX(0deg) rotateY(0deg) translateZ(0px) scale3d(1, 1, 1)`; 
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
                 
                ring.style.borderColor = 'rgba(99, 102, 241, 0.4)';
                
            });
            btn.addEventListener('mouseenter', () => { 
                isHover = true; 
                 
                ring.style.borderColor = '#f48fb1'; 
                
            });
        });
    </script>
</body>
</html>