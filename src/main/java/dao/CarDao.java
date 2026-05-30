package dao;

import entity.Car;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class CarDao {

    public Car findById(Integer id) {
        String sql = "SELECT * FROM `车辆` WHERE `ID` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    public List<Car> findAll() {
        String sql = "SELECT * FROM `车辆`";
        List<Car> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    public List<Car> findByStatus(Integer statusId) {
        String sql = "SELECT * FROM `车辆` WHERE `车辆状态` = ?";
        List<Car> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, statusId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    public boolean insert(Car car) {
        String sql = "INSERT INTO `车辆`(`车牌号`,`品牌`,`车型`,`购置日期`,`排量`,`行驶证号`,`车辆状态`,`年检到期日`,`保险到期日`) VALUES(?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, car.getLicensePlate());
            pstmt.setString(2, car.getBrand());
            pstmt.setString(3, car.getModel());
            pstmt.setDate(4, car.getPurchaseDate() != null ? new java.sql.Date(car.getPurchaseDate().getTime()) : null);
            pstmt.setString(5, car.getDisplacement());
            pstmt.setString(6, car.getDrivingLicenseNo());
            pstmt.setInt(7, car.getCarStatusId());
            pstmt.setDate(8, car.getInspectionExpireDate() != null ? new java.sql.Date(car.getInspectionExpireDate().getTime()) : null);
            pstmt.setDate(9, car.getInsuranceExpireDate() != null ? new java.sql.Date(car.getInsuranceExpireDate().getTime()) : null);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(Car car) {
        String sql = "UPDATE `车辆` SET `车牌号`=?,`品牌`=?,`车型`=?,`购置日期`=?,`排量`=?,`行驶证号`=?,`车辆状态`=?,`年检到期日`=?,`保险到期日`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, car.getLicensePlate());
            pstmt.setString(2, car.getBrand());
            pstmt.setString(3, car.getModel());
            pstmt.setDate(4, car.getPurchaseDate() != null ? new java.sql.Date(car.getPurchaseDate().getTime()) : null);
            pstmt.setString(5, car.getDisplacement());
            pstmt.setString(6, car.getDrivingLicenseNo());
            pstmt.setInt(7, car.getCarStatusId());
            pstmt.setDate(8, car.getInspectionExpireDate() != null ? new java.sql.Date(car.getInspectionExpireDate().getTime()) : null);
            pstmt.setDate(9, car.getInsuranceExpireDate() != null ? new java.sql.Date(car.getInsuranceExpireDate().getTime()) : null);
            pstmt.setInt(10, car.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(Integer id) {
        String sql = "DELETE FROM `车辆` WHERE `ID` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    private Car mapResultSet(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("ID"));
        car.setLicensePlate(rs.getString("车牌号"));
        car.setBrand(rs.getString("品牌"));
        car.setModel(rs.getString("车型"));
        car.setPurchaseDate(rs.getDate("购置日期"));
        car.setDisplacement(rs.getString("排量"));
        car.setDrivingLicenseNo(rs.getString("行驶证号"));
        car.setCarStatusId(rs.getInt("车辆状态"));
        car.setInspectionExpireDate(rs.getDate("年检到期日"));
        car.setInsuranceExpireDate(rs.getDate("保险到期日"));
        return car;
    }
}
