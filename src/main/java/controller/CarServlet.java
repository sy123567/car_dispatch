package controller;

import entity.Car;
import service.CarService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 车辆管理控制器
 */
public class CarServlet extends HttpServlet {

    private CarService carService = new CarService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("list".equals(action) || action == null) {
            listCars(req, resp);
        } else if ("delete".equals(action)) {
            deleteCar(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addCar(req, resp);
        } else if ("update".equals(action)) {
            updateCar(req, resp);
        }
    }

    private void listCars(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Car> cars = carService.getAllCars();
        req.setAttribute("cars", cars);
        req.getRequestDispatcher("/car_list.jsp").forward(req, resp);
    }

    private void addCar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Car car = new Car();
        car.setLicensePlate(req.getParameter("licensePlate"));
        car.setBrand(req.getParameter("brand"));
        car.setModel(req.getParameter("model"));
        car.setDisplacement(req.getParameter("displacement"));
        car.setDrivingLicenseNo(req.getParameter("drivingLicenseNo"));
        try {
            car.setCarStatusId(Integer.parseInt(req.getParameter("carStatusId")));
        } catch (Exception e) {
            car.setCarStatusId(1);
        }
        boolean success = carService.addCar(car);
        req.setAttribute("message", success ? "添加成功" : "添加失败");
        listCars(req, resp);
    }

    private void updateCar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Car car = new Car();
        car.setId(Integer.parseInt(req.getParameter("id")));
        car.setLicensePlate(req.getParameter("licensePlate"));
        car.setBrand(req.getParameter("brand"));
        car.setModel(req.getParameter("model"));
        car.setDisplacement(req.getParameter("displacement"));
        car.setDrivingLicenseNo(req.getParameter("drivingLicenseNo"));
        try {
            car.setCarStatusId(Integer.parseInt(req.getParameter("carStatusId")));
        } catch (Exception e) {
            car.setCarStatusId(1);
        }
        boolean success = carService.updateCar(car);
        req.setAttribute("message", success ? "更新成功" : "更新失败");
        listCars(req, resp);
    }

    private void deleteCar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        boolean success = carService.deleteCar(id);
        req.setAttribute("message", success ? "删除成功" : "删除失败");
        listCars(req, resp);
    }
}
