package dao;

import entity.RepairProject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class RepairProjectDao {

    public RepairProject findById(Integer id) {
        String sql = "SELECT * FROM `维修项目` WHERE `项目ID` = ?";
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

    public List<RepairProject> findAll() {
        String sql = "SELECT * FROM `维修项目`";
        List<RepairProject> list = new ArrayList<>();
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

    private RepairProject mapResultSet(ResultSet rs) throws SQLException {
        RepairProject project = new RepairProject();
        project.setProjectId(rs.getInt("项目ID"));
        project.setProjectType(rs.getString("项目类型"));
        project.setUnitPrice(rs.getBigDecimal("单价"));
        return project;
    }
}
