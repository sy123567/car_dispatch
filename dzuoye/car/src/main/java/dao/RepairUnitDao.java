package dao;

import entity.RepairUnit;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class RepairUnitDao {

    public RepairUnit findByName(String name) {
        String sql = "SELECT * FROM `维修单位` WHERE `单位名` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
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

    public List<RepairUnit> findAll() {
        String sql = "SELECT * FROM `维修单位`";
        List<RepairUnit> list = new ArrayList<>();
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

    private RepairUnit mapResultSet(ResultSet rs) throws SQLException {
        RepairUnit unit = new RepairUnit();
        unit.setUnitName(rs.getString("单位名"));
        unit.setUnitAddress(rs.getString("单位地址"));
        unit.setContact(rs.getString("联系方式"));
        return unit;
    }
}
