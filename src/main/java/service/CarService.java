package service;

import dao.CarDao;
import entity.Car;
import java.util.List;

/**
 * 车辆业务逻辑层
 */
public class CarService {

    private CarDao carDao = new CarDao();

    public List<Car> getAllCars() {
        return carDao.findAll();
    }

    public Car getCarById(Integer id) {
        return carDao.findById(id);
    }

    public List<Car> getCarsByStatus(Integer statusId) {
        return carDao.findByStatus(statusId);
    }

    public boolean addCar(Car car) {
        if (car == null || car.getLicensePlate() == null) {
            return false;
        }
        return carDao.insert(car);
    }

    public boolean updateCar(Car car) {
        if (car == null || car.getId() == null) {
            return false;
        }
        return carDao.update(car);
    }

    public boolean deleteCar(Integer id) {
        return carDao.delete(id);
    }
}
