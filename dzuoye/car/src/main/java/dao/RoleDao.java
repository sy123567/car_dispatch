package dao;

import entity.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

public class RoleDao {

    public Role findById(Integer id) {
        String sql = "SELECT * FROM `角色` WHERE `ID` = ?";
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

    public List<Role> findAll() {
        String sql = "SELECT * FROM `角色`";
        List<Role> list = new ArrayList<>();
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

    public boolean insert(Role role) {
        String sql = "INSERT INTO `角色`(`角色名`,`权限描述`) VALUES(?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role.getRoleName());
            pstmt.setString(2, role.getPermissionDesc());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean update(Role role) {
        String sql = "UPDATE `角色` SET `角色名`=?,`权限描述`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role.getRoleName());
            pstmt.setString(2, role.getPermissionDesc());
            pstmt.setInt(3, role.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    public boolean delete(Integer id) {
        String sql = "DELETE FROM `角色` WHERE `ID` = ?";
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

    private Role mapResultSet(ResultSet rs) throws SQLException {
        Role role = new Role();
        role.setId(rs.getInt("ID"));
        role.setRoleName(rs.getString("角色名"));
        role.setPermissionDesc(rs.getString("权限描述"));
        return role;
    }
}
