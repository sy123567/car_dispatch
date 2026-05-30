package controller;

import entity.CarApply;
import entity.User;
import service.CarApplyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 用车申请控制器
 */
public class CarApplyServlet extends HttpServlet {

    private CarApplyService carApplyService = new CarApplyService();
    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("submit".equals(action)) {
            submitApply(req, resp);
        } else if ("approve".equals(action)) {
            approveApply(req, resp);
        } else {
            submitApply(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("list".equals(action)) {
            listApplies(req, resp);
        } else if ("myList".equals(action)) {
            myApplies(req, resp);
        } else if ("add".equals(action)) {
            req.getRequestDispatcher("/car_apply_add.jsp").forward(req, resp);
        } else {
            listApplies(req, resp);
        }
    }

    /**
     * 提交用车申请
     */
    private void submitApply(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reason = req.getParameter("reason");
        String destination = req.getParameter("destination");
        String useTimeStr = req.getParameter("useDate");
        String returnTimeStr = req.getParameter("returnDate");
        String passengerCountStr = req.getParameter("passengerCount");
        String tripType = req.getParameter("tripType");
        String remark = req.getParameter("remark");

        CarApply apply = new CarApply();
        apply.setEmployeeId(currentUser.getId());
        apply.setReason(reason);
        apply.setDestination(destination);
        apply.setTripType(tripType != null ? tripType : "单程");
        apply.setRemark(remark);

        try {
            if (useTimeStr != null && !useTimeStr.isEmpty()) {
                apply.setUseDate(LocalDateTime.parse(useTimeStr, formatter));
            }
            if (returnTimeStr != null && !returnTimeStr.isEmpty()) {
                apply.setReturnDate(LocalDateTime.parse(returnTimeStr, formatter));
            }
            if (passengerCountStr != null && !passengerCountStr.isEmpty()) {
                apply.setPassengerCount(Integer.parseInt(passengerCountStr));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 数据验证
        String validationError = carApplyService.validateApply(apply);
        if (validationError != null) {
            req.setAttribute("error", validationError);
            req.setAttribute("apply", apply); // 保留数据以便重新填写
            req.getRequestDispatcher("/car_apply_add.jsp").forward(req, resp);
            return;
        }

        boolean success = carApplyService.submitApply(apply);
        if (success) {
            req.setAttribute("message", "申请提交成功");
        } else {
            req.setAttribute("error", "申请提交失败");
        }
        req.getRequestDispatcher("/car_apply_dispatch.jsp").forward(req, resp);
    }

    /**
     * 审批用车申请
     */
    private void approveApply(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String applyIdStr = req.getParameter("applyId");
        String status = req.getParameter("status");
        String comment = req.getParameter("comment");

        try {
            Integer applyId = Integer.parseInt(applyIdStr);
            boolean success = carApplyService.approveApply(applyId, currentUser.getId(), comment, status);
            if (success) {
                req.setAttribute("message", "审批操作成功");
            } else {
                req.setAttribute("error", "审批操作失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "参数错误");
        }

        listApplies(req, resp);
    }

    /**
     * 查询所有申请列表
     */
    private void listApplies(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String pageStr = req.getParameter("page");
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int pageSize = 10;

        List<CarApply> applies;
        int totalCount;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // 搜索功能
            applies = carApplyService.searchApplies(keyword);
            totalCount = applies.size();
        } else if (status != null && !status.trim().isEmpty()) {
            // 状态筛选
            applies = carApplyService.getAppliesByStatus(status);
            totalCount = applies.size();
        } else {
            // 全部列表
            applies = carApplyService.getAllApplies();
            totalCount = applies.size();
        }

        // 分页处理
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalCount);
        List<CarApply> pagedApplies = applies.subList(startIndex, endIndex);

        req.setAttribute("applies", pagedApplies);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);
        req.getRequestDispatcher("/car_apply_list.jsp").forward(req, resp);
    }

    /**
     * 查询当前用户的申请列表
     */
    private void myApplies(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        List<CarApply> applies = carApplyService.getAppliesByEmployee(currentUser.getId());
        req.setAttribute("applies", applies);
        req.getRequestDispatcher("/car_apply_list.jsp").forward(req, resp);
    }
}
