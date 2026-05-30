package controller;

import entity.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * 登录控制器
 */
public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String account = req.getParameter("account");
        String password = req.getParameter("password");

        User user = userService.login(account, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);
            resp.sendRedirect(req.getContextPath() + "/index");
        } else {
            req.setAttribute("error", "账号或密码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
