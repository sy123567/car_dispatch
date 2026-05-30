package dao;

import entity.CarStatus;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class CarStatusDao {

    public CarStatus findById(Integer id) {
        String sql = "SELECT * FROM `车辆状态` WHERE `ID` = ?";
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

    public List<CarStatus> findAll() {
        String sql = "SELECT * FROM `车辆状态`";
        List<CarStatus> list = new ArrayList<>();
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

    private CarStatus mapResultSet(ResultSet rs) throws SQLException {
        CarStatus status = new CarStatus();
        status.setId(rs.getInt("ID"));
        status.setStatusName(rs.getString("车辆状态"));
        status.setStatusDesc(rs.getString("状态描述"));
        return status;
    }
}
