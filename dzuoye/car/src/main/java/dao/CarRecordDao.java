package dao;

import entity.CarRecord;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class CarRecordDao {

    public CarRecord findById(Integer id) {
        String sql = "SELECT * FROM `用车记录` WHERE `ID` = ?";
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

    public List<CarRecord> findAll() {
        String sql = "SELECT * FROM `用车记录`";
        List<CarRecord> list = new ArrayList<>();
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

    public boolean insert(CarRecord record) {
        String sql = "INSERT INTO `用车记录`(`实际出车时间`,`实际回车时间`,`实际里程`,`油耗`,`车辆状态`,`派车单ID`) VALUES(?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, record.getActualDepartTime() != null ? Timestamp.valueOf(record.getActualDepartTime()) : null);
            pstmt.setTimestamp(2, record.getActualReturnTime() != null ? Timestamp.valueOf(record.getActualReturnTime()) : null);
            pstmt.setBigDecimal(3, record.getActualMileage());
            pstmt.setBigDecimal(4, record.getFuelConsumption());
            pstmt.setInt(5, record.getCarStatusId());
            pstmt.setInt(6, record.getDispatchId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(CarRecord record) {
        String sql = "UPDATE `用车记录` SET `实际出车时间`=?,`实际回车时间`=?,`实际里程`=?,`油耗`=?,`车辆状态`=?,`派车单ID`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, record.getActualDepartTime() != null ? Timestamp.valueOf(record.getActualDepartTime()) : null);
            pstmt.setTimestamp(2, record.getActualReturnTime() != null ? Timestamp.valueOf(record.getActualReturnTime()) : null);
            pstmt.setBigDecimal(3, record.getActualMileage());
            pstmt.setBigDecimal(4, record.getFuelConsumption());
            pstmt.setInt(5, record.getCarStatusId());
            pstmt.setInt(6, record.getDispatchId());
            pstmt.setInt(7, record.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(Integer id) {
        String sql = "DELETE FROM `用车记录` WHERE `ID` = ?";
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

    private CarRecord mapResultSet(ResultSet rs) throws SQLException {
        CarRecord record = new CarRecord();
        record.setId(rs.getInt("ID"));
        Timestamp ts1 = rs.getTimestamp("实际出车时间");
        if (ts1 != null) record.setActualDepartTime(ts1.toLocalDateTime());
        Timestamp ts2 = rs.getTimestamp("实际回车时间");
        if (ts2 != null) record.setActualReturnTime(ts2.toLocalDateTime());
        record.setActualMileage(rs.getBigDecimal("实际里程"));
        record.setFuelConsumption(rs.getBigDecimal("油耗"));
        record.setCarStatusId(rs.getInt("车辆状态"));
        record.setDispatchId(rs.getInt("派车单ID"));
        return record;
    }
}
