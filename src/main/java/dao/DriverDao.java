package dao;

import entity.Driver;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class DriverDao {

    public Driver findById(Integer id) {
        String sql = "SELECT * FROM `司机` WHERE `ID` = ?";
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

    public List<Driver> findAll() {
        String sql = "SELECT * FROM `司机`";
        List<Driver> list = new ArrayList<>();
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

    public List<Driver> findByStatus(Integer statusId) {
        String sql = "SELECT * FROM `司机` WHERE `司机状态` = ?";
        List<Driver> list = new ArrayList<>();
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

    public boolean insert(Driver driver) {
        String sql = "INSERT INTO `司机`(`用户ID`,`姓名`,`工号`,`联系方式`,`驾驶证号`,`驾驶证有效期`,`从业资格证号`,`资格证有效期`,`司机状态`) VALUES(?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, driver.getUserId());
            pstmt.setString(2, driver.getName());
            pstmt.setString(3, driver.getEmployeeNo());
            pstmt.setString(4, driver.getContact());
            pstmt.setString(5, driver.getDriverLicenseNo());
            pstmt.setDate(6, driver.getLicenseExpireDate() != null ? new java.sql.Date(driver.getLicenseExpireDate().getTime()) : null);
            pstmt.setString(7, driver.getQualificationNo());
            pstmt.setDate(8, driver.getQualificationExpireDate() != null ? new java.sql.Date(driver.getQualificationExpireDate().getTime()) : null);
            pstmt.setInt(9, driver.getDriverStatusId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(Driver driver) {
        String sql = "UPDATE `司机` SET `用户ID`=?,`姓名`=?,`工号`=?,`联系方式`=?,`驾驶证号`=?,`驾驶证有效期`=?,`从业资格证号`=?,`资格证有效期`=?,`司机状态`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, driver.getUserId());
            pstmt.setString(2, driver.getName());
            pstmt.setString(3, driver.getEmployeeNo());
            pstmt.setString(4, driver.getContact());
            pstmt.setString(5, driver.getDriverLicenseNo());
            pstmt.setDate(6, driver.getLicenseExpireDate() != null ? new java.sql.Date(driver.getLicenseExpireDate().getTime()) : null);
            pstmt.setString(7, driver.getQualificationNo());
            pstmt.setDate(8, driver.getQualificationExpireDate() != null ? new java.sql.Date(driver.getQualificationExpireDate().getTime()) : null);
            pstmt.setInt(9, driver.getDriverStatusId());
            pstmt.setInt(10, driver.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(Integer id) {
        String sql = "DELETE FROM `司机` WHERE `ID` = ?";
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

    private Driver mapResultSet(ResultSet rs) throws SQLException {
        Driver driver = new Driver();
        driver.setId(rs.getInt("ID"));
        driver.setUserId(rs.getInt("用户ID"));
        driver.setName(rs.getString("姓名"));
        driver.setEmployeeNo(rs.getString("工号"));
        driver.setContact(rs.getString("联系方式"));
        driver.setDriverLicenseNo(rs.getString("驾驶证号"));
        driver.setLicenseExpireDate(rs.getDate("驾驶证有效期"));
        driver.setQualificationNo(rs.getString("从业资格证号"));
        driver.setQualificationExpireDate(rs.getDate("资格证有效期"));
        driver.setDriverStatusId(rs.getInt("司机状态"));
        return driver;
    }
}
