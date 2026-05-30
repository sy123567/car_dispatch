package controller;

import entity.User;
import service.CarApplyService;
import service.CarService;
import service.DriverService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * 首页控制器
 */
public class IndexServlet extends HttpServlet {

    private CarApplyService carApplyService = new CarApplyService();
    private CarService carService = new CarService();
    private DriverService driverService = new DriverService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 统计信息
        int totalApply = carApplyService.getAllApplies().size();
        int pendingApply = carApplyService.getAppliesByStatus("待审批").size();
        int dispatchedApply = carApplyService.getAppliesByStatus("已派车").size();
        int availableCars = carService.getCarsByStatus(1).size(); // 假设1为空闲状态

        req.setAttribute("totalApply", totalApply);
        req.setAttribute("pendingApply", pendingApply);
        req.setAttribute("dispatchedApply", dispatchedApply);
        req.setAttribute("availableCars", availableCars);
        req.setAttribute("currentUser", currentUser);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
