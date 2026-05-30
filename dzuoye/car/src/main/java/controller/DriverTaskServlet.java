package controller;

import entity.CarDispatch;
import entity.CarRecord;
import entity.User;
import dao.CarDispatchDao;
import dao.CarRecordDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 司机任务控制器（司机查看接单 / 完成任务生成用车记录）
 */
public class DriverTaskServlet extends HttpServlet {

    private CarDispatchDao carDispatchDao = new CarDispatchDao();
    private CarRecordDao carRecordDao = new CarRecordDao();

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
        // 已生成用车记录(已完成)的派车单ID集合,供页面区分状态
        java.util.Set<Integer> completed = new java.util.HashSet<>();
        for (CarRecord r : carRecordDao.findAll()) {
            if (r.getDispatchId() != null) {
                completed.add(r.getDispatchId());
            }
        }
        req.setAttribute("completedDispatchIds", completed);
        req.getRequestDispatcher("/driver_tasks.jsp").forward(req, resp);
    }

    /**
     * 司机完成任务:提交实际里程/油耗,生成用车记录。
     * 插入用车记录会触发器自动将车辆、司机状态释放为"空闲"。
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (currentUser.getRoleId() != 4 && currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        String action = req.getParameter("action");
        if ("complete".equals(action)) {
            try {
                Integer dispatchId = Integer.parseInt(req.getParameter("dispatchId"));
                CarDispatch dispatch = carDispatchDao.findById(dispatchId);
                CarRecord record = new CarRecord();
                record.setDispatchId(dispatchId);
                record.setActualDepartTime(dispatch != null && dispatch.getUseDate() != null
                        ? dispatch.getUseDate() : LocalDateTime.now());
                record.setActualReturnTime(LocalDateTime.now());
                String mileage = req.getParameter("mileage");
                String fuel = req.getParameter("fuel");
                record.setActualMileage(mileage != null && !mileage.isEmpty() ? new BigDecimal(mileage) : BigDecimal.ZERO);
                record.setFuelConsumption(fuel != null && !fuel.isEmpty() ? new BigDecimal(fuel) : BigDecimal.ZERO);
                record.setCarStatusId(1); // 1 = 空闲
                carRecordDao.insert(record);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/driverTask");
    }
}
