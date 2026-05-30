package dao;

import entity.RepairApply;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class RepairApplyDao {

    /** 可空整型写入：值为 null 时写入 SQL NULL，避免 setInt 对 null 自动拆箱抛 NPE。 */
    private static void setNullableInt(PreparedStatement pstmt, int idx, Integer val) throws SQLException {
        if (val == null) {
            pstmt.setNull(idx, Types.INTEGER);
        } else {
            pstmt.setInt(idx, val);
        }
    }

    public RepairApply findById(String orderNo) {
        String sql = "SELECT * FROM `维修申请` WHERE `工单号` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderNo);
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

    public List<RepairApply> findAll() {
        String sql = "SELECT * FROM `维修申请`";
        List<RepairApply> list = new ArrayList<>();
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

    public boolean insert(RepairApply apply) {
        String sql = "INSERT INTO `维修申请`(`工单号`,`申请人ID`,`车ID`,`申请时间`,`故障描述`,`维修单位名`,`维修项目`,`维修总费用`,`审批人工号`,`审批状态`) VALUES(?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, apply.getWorkOrderNo());
            setNullableInt(pstmt, 2, apply.getApplicantId());
            setNullableInt(pstmt, 3, apply.getCarId());
            pstmt.setTimestamp(4, apply.getApplyTime() != null ? Timestamp.valueOf(apply.getApplyTime()) : null);
            pstmt.setString(5, apply.getFaultDesc());
            pstmt.setString(6, apply.getRepairUnitName());
            setNullableInt(pstmt, 7, apply.getRepairProjectId());
            pstmt.setBigDecimal(8, apply.getTotalCost());
            setNullableInt(pstmt, 9, apply.getApproverId());
            pstmt.setString(10, apply.getApproveStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(RepairApply apply) {
        String sql = "UPDATE `维修申请` SET `申请人ID`=?,`车ID`=?,`申请时间`=?,`故障描述`=?,`维修单位名`=?,`维修项目`=?,`维修总费用`=?,`审批人工号`=?,`审批状态`=? WHERE `工单号`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            setNullableInt(pstmt, 1, apply.getApplicantId());
            setNullableInt(pstmt, 2, apply.getCarId());
            pstmt.setTimestamp(3, apply.getApplyTime() != null ? Timestamp.valueOf(apply.getApplyTime()) : null);
            pstmt.setString(4, apply.getFaultDesc());
            pstmt.setString(5, apply.getRepairUnitName());
            setNullableInt(pstmt, 6, apply.getRepairProjectId());
            pstmt.setBigDecimal(7, apply.getTotalCost());
            setNullableInt(pstmt, 8, apply.getApproverId());
            pstmt.setString(9, apply.getApproveStatus());
            pstmt.setString(10, apply.getWorkOrderNo());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(String orderNo) {
        String sql = "DELETE FROM `维修申请` WHERE `工单号` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderNo);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    private RepairApply mapResultSet(ResultSet rs) throws SQLException {
        RepairApply apply = new RepairApply();
        apply.setWorkOrderNo(rs.getString("工单号"));
        apply.setApplicantId(rs.getInt("申请人ID"));
        apply.setCarId(rs.getInt("车ID"));
        Timestamp ts = rs.getTimestamp("申请时间");
        if (ts != null) apply.setApplyTime(ts.toLocalDateTime());
        apply.setFaultDesc(rs.getString("故障描述"));
        apply.setRepairUnitName(rs.getString("维修单位名"));
        apply.setRepairProjectId(rs.getInt("维修项目"));
        apply.setTotalCost(rs.getBigDecimal("维修总费用"));
        apply.setApproverId(rs.getInt("审批人工号"));
        apply.setApproveStatus(rs.getString("审批状态"));
        return apply;
    }
}
