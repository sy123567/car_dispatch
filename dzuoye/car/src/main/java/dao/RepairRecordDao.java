package dao;

import entity.RepairRecord;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class RepairRecordDao {

    public RepairRecord findById(String orderNo) {
        String sql = "SELECT * FROM `维修记录` WHERE `工单号` = ?";
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

    public List<RepairRecord> findAll() {
        String sql = "SELECT * FROM `维修记录`";
        List<RepairRecord> list = new ArrayList<>();
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

    public boolean insert(RepairRecord record) {
        String sql = "INSERT INTO `维修记录`(`工单号`,`申请人ID`,`车ID`,`申请时间`,`故障描述`,`维修单位名`,`维修项目`,`维修总费用`,`审批人工号`) VALUES(?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, record.getWorkOrderNo());
            pstmt.setInt(2, record.getApplicantId());
            pstmt.setInt(3, record.getCarId());
            pstmt.setTimestamp(4, record.getApplyTime() != null ? Timestamp.valueOf(record.getApplyTime()) : null);
            pstmt.setString(5, record.getFaultDesc());
            pstmt.setString(6, record.getRepairUnitName());
            pstmt.setInt(7, record.getRepairProjectId());
            pstmt.setBigDecimal(8, record.getTotalCost());
            pstmt.setInt(9, record.getApproverId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(RepairRecord record) {
        String sql = "UPDATE `维修记录` SET `申请人ID`=?,`车ID`=?,`申请时间`=?,`故障描述`=?,`维修单位名`=?,`维修项目`=?,`维修总费用`=?,`审批人工号`=? WHERE `工单号`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, record.getApplicantId());
            pstmt.setInt(2, record.getCarId());
            pstmt.setTimestamp(3, record.getApplyTime() != null ? Timestamp.valueOf(record.getApplyTime()) : null);
            pstmt.setString(4, record.getFaultDesc());
            pstmt.setString(5, record.getRepairUnitName());
            pstmt.setInt(6, record.getRepairProjectId());
            pstmt.setBigDecimal(7, record.getTotalCost());
            pstmt.setInt(8, record.getApproverId());
            pstmt.setString(9, record.getWorkOrderNo());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(String orderNo) {
        String sql = "DELETE FROM `维修记录` WHERE `工单号` = ?";
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

    private RepairRecord mapResultSet(ResultSet rs) throws SQLException {
        RepairRecord record = new RepairRecord();
        record.setWorkOrderNo(rs.getString("工单号"));
        record.setApplicantId(rs.getInt("申请人ID"));
        record.setCarId(rs.getInt("车ID"));
        Timestamp ts = rs.getTimestamp("申请时间");
        if (ts != null) record.setApplyTime(ts.toLocalDateTime());
        record.setFaultDesc(rs.getString("故障描述"));
        record.setRepairUnitName(rs.getString("维修单位名"));
        record.setRepairProjectId(rs.getInt("维修项目"));
        record.setTotalCost(rs.getBigDecimal("维修总费用"));
        record.setApproverId(rs.getInt("审批人工号"));
        return record;
    }
}
