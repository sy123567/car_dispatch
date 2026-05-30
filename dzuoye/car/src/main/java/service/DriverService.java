package service;

import dao.DriverDao;
import entity.Driver;
import java.util.List;

/**
 * 司机业务逻辑层
 */
public class DriverService {

    private DriverDao driverDao = new DriverDao();

    public List<Driver> getAllDrivers() {
        return driverDao.findAll();
    }

    public Driver getDriverById(Integer id) {
        return driverDao.findById(id);
    }

    public List<Driver> getDriversByStatus(Integer statusId) {
        return driverDao.findByStatus(statusId);
    }

    public boolean addDriver(Driver driver) {
        if (driver == null || driver.getName() == null) {
            return false;
        }
        return driverDao.insert(driver);
    }

    public boolean updateDriver(Driver driver) {
        if (driver == null || driver.getId() == null) {
            return false;
        }
        return driverDao.update(driver);
    }

    public boolean deleteDriver(Integer id) {
        return driverDao.delete(id);
    }
}
