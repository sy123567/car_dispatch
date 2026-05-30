package controller;

import entity.CarDispatch;
import entity.User;
import dao.CarDispatchDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 司机任务控制器（司机查看接单）
 */
public class DriverTaskServlet extends HttpServlet {

    private CarDispatchDao carDispatchDao = new CarDispatchDao();

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

        List<CarDispatch> tasks = carDispatchDao.findByDriverUserId(currentUser.getId());
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/driver_tasks.jsp").forward(req, resp);
    }
}
