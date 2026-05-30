package dao;

import entity.DriverStatus;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class DriverStatusDao {

    public DriverStatus findById(Integer id) {
        String sql = "SELECT * FROM `司机状态` WHERE `ID` = ?";
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

    public List<DriverStatus> findAll() {
        String sql = "SELECT * FROM `司机状态`";
        List<DriverStatus> list = new ArrayList<>();
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

    private DriverStatus mapResultSet(ResultSet rs) throws SQLException {
        DriverStatus status = new DriverStatus();
        status.setId(rs.getInt("ID"));
        status.setStatusName(rs.getString("司机状态"));
        status.setStatusDesc(rs.getString("状态描述"));
        return status;
    }
}
