package dao;

import entity.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

/**
 * 用户数据访问对象
 * 操作: 用户表
 */
public class UserDao {

    /**
     * 根据ID查询用户
     */
    public User findById(Integer id) {
        String sql = "SELECT * FROM `用户` WHERE `ID` = ?";
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

    /**
     * 根据账号查询用户（登录用）
     */
    public User findByAccount(String account) {
        String sql = "SELECT * FROM `用户` WHERE `账号` = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, account);
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

    /**
     * 查询所有用户
     */
    public List<User> findAll() {
        String sql = "SELECT * FROM `用户`";
        List<User> list = new ArrayList<>();
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

    /**
     * 根据角色ID查询用户
     */
    public List<User> findByRoleId(Integer roleId) {
        String sql = "SELECT * FROM `用户` WHERE `角色ID` = ?";
        List<User> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, roleId);
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

    /**
     * 新增用户
     */
    public boolean insert(User user) {
        String sql = "INSERT INTO `用户`(`姓名`,`账号`,`密码`,`部门`,`角色ID`) VALUES(?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getAccount());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getDepartment());
            pstmt.setInt(5, user.getRoleId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 更新用户
     */
    public boolean update(User user) {
        String sql = "UPDATE `用户` SET `姓名`=?,`账号`=?,`密码`=?,`部门`=?,`角色ID`=? WHERE `ID`=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getAccount());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getDepartment());
            pstmt.setInt(5, user.getRoleId());
            pstmt.setInt(6, user.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 删除用户
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM `用户` WHERE `ID` = ?";
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

    /**
     * ResultSet映射为User对象
     */
    private User mapResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("ID"));
        user.setName(rs.getString("姓名"));
        user.setAccount(rs.getString("账号"));
        user.setPassword(rs.getString("密码"));
        user.setDepartment(rs.getString("部门"));
        user.setRoleId(rs.getInt("角色ID"));
        return user;
    }
}
