package dao;

import entity.CarApply;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class CarApplyDao {

    public CarApply findById(Integer applyId) {
        String sql = "SELECT * FROM `用车申请` WHERE `申请ID` = ?";
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

    public List<CarApply> findAll() {
        String sql = "SELECT * FROM `用车申请` ORDER BY `申请ID` DESC";
        List<CarApply> list = new ArrayList<>();
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

    public List<CarApply> findByEmployeeId(Integer employeeId) {
        String sql = "SELECT * FROM `用车申请` WHERE `员工ID` = ? ORDER BY `申请ID` DESC";
        List<CarApply> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, employeeId);
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

    public List<CarApply> findByStatus(String status) {
        String sql = "SELECT * FROM `用车申请` WHERE `申请状态` = ? ORDER BY `申请ID` DESC";
        List<CarApply> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
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

    public List<CarApply> search(String keyword) {
        String sql = "SELECT * FROM `用车申请` WHERE `申请ID` LIKE ? OR `员工ID` LIKE ? OR `目的地` LIKE ? OR `用车原因` LIKE ? ORDER BY `申请ID` DESC";
        List<CarApply> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
            pstmt.setString(3, pattern);
            pstmt.setString(4, pattern);
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

    public boolean insert(CarApply apply) {
        String sql = "INSERT INTO `用车申请`(`员工ID`,`申请日期`,`用车日期`,`还车日期`,`用车原因`,`目的地`,`乘车人数`,`申请状态`,`往返类型`,`备注`) VALUES(?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, apply.getEmployeeId());
            pstmt.setTimestamp(2, apply.getApplyDate() != null ? Timestamp.valueOf(apply.getApplyDate()) : Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setTimestamp(3, apply.getUseDate() != null ? Timestamp.valueOf(apply.getUseDate()) : null);
            pstmt.setTimestamp(4, apply.getReturnDate() != null ? Timestamp.valueOf(apply.getReturnDate()) : null);
            pstmt.setString(5, apply.getReason());
            pstmt.setString(6, apply.getDestination());
            pstmt.setInt(7, apply.getPassengerCount() != null ? apply.getPassengerCount() : 1);
            pstmt.setString(8, apply.getApplyStatus());
            pstmt.setString(9, apply.getTripType());
            pstmt.setString(10, apply.getRemark());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(CarApply apply) {
        String sql = "UPDATE `用车申请` SET `员工ID`=?,`用车日期`=?,`还车日期`=?,`用车原因`=?,`目的地`=?,`乘车人数`=?,`申请状态`=?,`审批人ID`=?,`审批意见`=?,`审批时间`=?,`往返类型`=?,`备注`=? WHERE `申请ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, apply.getEmployeeId());
            pstmt.setTimestamp(2, apply.getUseDate() != null ? Timestamp.valueOf(apply.getUseDate()) : null);
            pstmt.setTimestamp(3, apply.getReturnDate() != null ? Timestamp.valueOf(apply.getReturnDate()) : null);
            pstmt.setString(4, apply.getReason());
            pstmt.setString(5, apply.getDestination());
            pstmt.setInt(6, apply.getPassengerCount());
            pstmt.setString(7, apply.getApplyStatus());
            pstmt.setObject(8, apply.getApproverId());
            pstmt.setString(9, apply.getApproveComment());
            pstmt.setTimestamp(10, apply.getApproveTime() != null ? Timestamp.valueOf(apply.getApproveTime()) : null);
            pstmt.setString(11, apply.getTripType());
            pstmt.setString(12, apply.getRemark());
            pstmt.setInt(13, apply.getApplyId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(Integer applyId) {
        String sql = "DELETE FROM `用车申请` WHERE `申请ID` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, applyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    private CarApply mapResultSet(ResultSet rs) throws SQLException {
        CarApply apply = new CarApply();
        apply.setApplyId(rs.getInt("申请ID"));
        apply.setEmployeeId(rs.getInt("员工ID"));
        Timestamp ts1 = rs.getTimestamp("申请日期");
        if (ts1 != null) apply.setApplyDate(ts1.toLocalDateTime());
        Timestamp ts2 = rs.getTimestamp("用车日期");
        if (ts2 != null) apply.setUseDate(ts2.toLocalDateTime());
        Timestamp ts3 = rs.getTimestamp("还车日期");
        if (ts3 != null) apply.setReturnDate(ts3.toLocalDateTime());
        apply.setReason(rs.getString("用车原因"));
        apply.setDestination(rs.getString("目的地"));
        apply.setPassengerCount(rs.getInt("乘车人数"));
        apply.setApplyStatus(rs.getString("申请状态"));
        apply.setApproverId(rs.getInt("审批人ID"));
        apply.setApproveComment(rs.getString("审批意见"));
        Timestamp ts4 = rs.getTimestamp("审批时间");
        if (ts4 != null) apply.setApproveTime(ts4.toLocalDateTime());
        apply.setTripType(rs.getString("往返类型"));
        apply.setRemark(rs.getString("备注"));
        return apply;
    }
}
