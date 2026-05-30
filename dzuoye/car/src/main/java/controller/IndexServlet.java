package controller;

import entity.User;
import entity.CarApply;
import entity.CarDispatch;
import service.CarApplyService;
import service.CarService;
import service.DriverService;
import dao.CarDispatchDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;

/**
 * 首页控制器
 */
public class IndexServlet extends HttpServlet {

    private CarApplyService carApplyService = new CarApplyService();
    private CarService carService = new CarService();
    private DriverService driverService = new DriverService();
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

        // 统计信息（全部来自数据库实时统计）
        List<CarApply> allApplies = carApplyService.getAllApplies();
        List<CarApply> pendingApplies = carApplyService.getAppliesByStatus("待审批");
        int totalApply = allApplies.size();
        int pendingApply = pendingApplies.size();
        int rejectedApply = carApplyService.getAppliesByStatus("已拒绝").size();
        int approvedApply = totalApply - pendingApply - rejectedApply; // 已处理（通过/派车）
        int availableCars = carService.getCarsByStatus(1).size(); // 1=空闲
        int onDutyDrivers = driverService.getAllDrivers().size();

        // 待审批申请（最多展示 5 条）
        List<CarApply> pendingTop = pendingApplies.stream().limit(5).collect(Collectors.toList());

        // 最近派车（按派车单号倒序，最多展示 5 条），解析为可读的车辆/司机信息
        List<String[]> recentDispatches = carDispatchDao.findAll().stream()
                .sorted(Comparator.comparing(CarDispatch::getId, Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(5)
                .map(d -> {
                    String no = "PD-" + String.format("%06d", d.getId());
                    entity.Car car = d.getCarId() != null ? carService.getCarById(d.getCarId()) : null;
                    String carText = car != null ? car.getLicensePlate() : (d.getCarId() != null ? "车辆#" + d.getCarId() : "-");
                    entity.Driver drv = d.getDriverId() != null ? driverService.getDriverById(d.getDriverId()) : null;
                    String drvText = (drv != null && drv.getName() != null) ? drv.getName() : (d.getDriverId() != null ? "司机#" + d.getDriverId() : "-");
                    return new String[]{no, carText, drvText, "已派车"};
                })
                .collect(Collectors.toList());

        req.setAttribute("totalApply", totalApply);
        req.setAttribute("pendingApply", pendingApply);
        req.setAttribute("approvedApply", approvedApply);
        req.setAttribute("availableCars", availableCars);
        req.setAttribute("onDutyDrivers", onDutyDrivers);
        req.setAttribute("pendingApplies", pendingTop);
        req.setAttribute("recentDispatches", recentDispatches);
        req.setAttribute("currentUser", currentUser);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
