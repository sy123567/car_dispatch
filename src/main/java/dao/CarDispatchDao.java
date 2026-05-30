package dao;

import entity.CarDispatch;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class CarDispatchDao {

    public CarDispatch findById(Integer id) {
        String sql = "SELECT * FROM `派车单` WHERE `ID` = ?";
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

    public List<CarDispatch> findAll() {
        String sql = "SELECT * FROM `派车单`";
        List<CarDispatch> list = new ArrayList<>();
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

    public CarDispatch findByApplyId(Integer applyId) {
        String sql = "SELECT * FROM `派车单` WHERE `申请ID` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, applyId);
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

    public boolean insert(CarDispatch dispatch) {
        String sql = "INSERT INTO `派车单`(`申请ID`,`车辆ID`,`司机ID`,`用车日期`,`还车日期`) VALUES(?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dispatch.getApplyId());
            pstmt.setInt(2, dispatch.getCarId());
            pstmt.setInt(3, dispatch.getDriverId());
            pstmt.setTimestamp(4, dispatch.getUseDate() != null ? Timestamp.valueOf(dispatch.getUseDate()) : null);
            pstmt.setTimestamp(5, dispatch.getReturnDate() != null ? Timestamp.valueOf(dispatch.getReturnDate()) : null);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(CarDispatch dispatch) {
        String sql = "UPDATE `派车单` SET `申请ID`=?,`车辆ID`=?,`司机ID`=?,`用车日期`=?,`还车日期`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dispatch.getApplyId());
            pstmt.setInt(2, dispatch.getCarId());
            pstmt.setInt(3, dispatch.getDriverId());
            pstmt.setTimestamp(4, dispatch.getUseDate() != null ? Timestamp.valueOf(dispatch.getUseDate()) : null);
            pstmt.setTimestamp(5, dispatch.getReturnDate() != null ? Timestamp.valueOf(dispatch.getReturnDate()) : null);
            pstmt.setInt(6, dispatch.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public List<CarDispatch> findByDriverUserId(Integer userId) {
        String sql = "SELECT d.* FROM `派车单` d INNER JOIN `司机` s ON d.`司机ID` = s.`ID` WHERE s.`用户ID` = ?";
        List<CarDispatch> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
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

    public boolean delete(Integer id) {
        String sql = "DELETE FROM `派车单` WHERE `ID` = ?";
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

    private CarDispatch mapResultSet(ResultSet rs) throws SQLException {
        CarDispatch dispatch = new CarDispatch();
        dispatch.setId(rs.getInt("ID"));
        dispatch.setApplyId(rs.getInt("申请ID"));
        dispatch.setCarId(rs.getInt("车辆ID"));
        dispatch.setDriverId(rs.getInt("司机ID"));
        Timestamp ts1 = rs.getTimestamp("用车日期");
        if (ts1 != null) dispatch.setUseDate(ts1.toLocalDateTime());
        Timestamp ts2 = rs.getTimestamp("还车日期");
        if (ts2 != null) dispatch.setReturnDate(ts2.toLocalDateTime());
        return dispatch;
    }
}
