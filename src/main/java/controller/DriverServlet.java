package controller;

import entity.Driver;
import service.DriverService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 司机管理控制器
 */
public class DriverServlet extends HttpServlet {

    private DriverService driverService = new DriverService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("list".equals(action) || action == null) {
            listDrivers(req, resp);
        } else if ("delete".equals(action)) {
            deleteDriver(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addDriver(req, resp);
        } else if ("update".equals(action)) {
            updateDriver(req, resp);
        }
    }

    private void listDrivers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Driver> drivers = driverService.getAllDrivers();
        req.setAttribute("drivers", drivers);
        req.getRequestDispatcher("/driver_list.jsp").forward(req, resp);
    }

    private void addDriver(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Driver driver = new Driver();
        driver.setName(req.getParameter("name"));
        driver.setEmployeeNo(req.getParameter("employeeNo"));
        driver.setContact(req.getParameter("contact"));
        driver.setDriverLicenseNo(req.getParameter("driverLicenseNo"));
        driver.setQualificationNo(req.getParameter("qualificationNo"));
        try {
            driver.setDriverStatusId(Integer.parseInt(req.getParameter("driverStatusId")));
            driver.setUserId(Integer.parseInt(req.getParameter("userId")));
        } catch (Exception e) {
            driver.setDriverStatusId(1);
        }
        boolean success = driverService.addDriver(driver);
        req.setAttribute("message", success ? "添加成功" : "添加失败");
        listDrivers(req, resp);
    }

    private void updateDriver(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Driver driver = new Driver();
        driver.setId(Integer.parseInt(req.getParameter("id")));
        driver.setName(req.getParameter("name"));
        driver.setEmployeeNo(req.getParameter("employeeNo"));
        driver.setContact(req.getParameter("contact"));
        driver.setDriverLicenseNo(req.getParameter("driverLicenseNo"));
        driver.setQualificationNo(req.getParameter("qualificationNo"));
        try {
            driver.setDriverStatusId(Integer.parseInt(req.getParameter("driverStatusId")));
        } catch (Exception e) {
            driver.setDriverStatusId(1);
        }
        boolean success = driverService.updateDriver(driver);
        req.setAttribute("message", success ? "更新成功" : "更新失败");
        listDrivers(req, resp);
    }

    private void deleteDriver(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        boolean success = driverService.deleteDriver(id);
        req.setAttribute("message", success ? "删除成功" : "删除失败");
        listDrivers(req, resp);
    }
}
