package controller;

import entity.RepairApply;
import entity.User;
import dao.RepairApplyDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 维修管理控制器（司机查看维修事务）
 */
public class RepairServlet extends HttpServlet {

    private RepairApplyDao repairApplyDao = new RepairApplyDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        // 司机(4)或管理员(1)可访问
        if (currentUser.getRoleId() != 4 && currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        List<RepairApply> repairs = repairApplyDao.findAll();
        req.setAttribute("repairs", repairs);
        req.getRequestDispatcher("/repair_list.jsp").forward(req, resp);
    }
}
