package service;

import dao.UserDao;
import entity.User;
import java.util.List;

/**
 * 用户业务逻辑层
 */
public class UserService {

    private UserDao userDao = new UserDao();

    /**
     * 用户登录验证
     */
    public User login(String account, String password) {
        User user = userDao.findByAccount(account);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    /**
     * 根据ID获取用户
     */
    public User getUserById(Integer id) {
        return userDao.findById(id);
    }

    /**
     * 根据角色获取用户
     */
    public List<User> getUsersByRole(Integer roleId) {
        return userDao.findByRoleId(roleId);
    }

    /**
     * 新增用户
     */
    public boolean addUser(User user) {
        if (user == null || user.getAccount() == null || user.getPassword() == null) {
            return false;
        }
        // 检查账号是否已存在
        User exist = userDao.findByAccount(user.getAccount());
        if (exist != null) {
            return false;
        }
        return userDao.insert(user);
    }

    /**
     * 更新用户
     */
    public boolean updateUser(User user) {
        if (user == null || user.getId() == null) {
            return false;
        }
        return userDao.update(user);
    }

    /**
     * 删除用户
     */
    public boolean deleteUser(Integer id) {
        return userDao.delete(id);
    }
}
