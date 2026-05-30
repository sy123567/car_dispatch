package controller;

import entity.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 用户管理控制器（仅管理员可访问）
 */
public class UserManageServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            deleteUser(req, resp);
        } else {
            listUsers(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            addUser(req, resp);
        } else {
            listUsers(req, resp);
        }
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/user_manage.jsp").forward(req, resp);
    }

    private void addUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String account = req.getParameter("account");
        String password = req.getParameter("password");
        String department = req.getParameter("department");
        String roleIdStr = req.getParameter("roleId");

        User user = new User();
        user.setName(name);
        user.setAccount(account);
        user.setPassword(password);
        user.setDepartment(department);
        try {
            user.setRoleId(Integer.parseInt(roleIdStr));
        } catch (Exception e) {
            user.setRoleId(2); // 默认员工
        }

        boolean success = userService.addUser(user);
        if (success) {
            req.setAttribute("message", "用户添加成功");
        } else {
            req.setAttribute("error", "添加失败，账号可能已存在");
        }
        listUsers(req, resp);
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        try {
            Integer id = Integer.parseInt(idStr);
            boolean success = userService.deleteUser(id);
            req.setAttribute("message", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            req.setAttribute("error", "参数错误");
        }
        listUsers(req, resp);
    }
}
