package controller;

import entity.RepairApply;
import entity.User;
import dao.RepairApplyDao;
import dao.RepairUnitDao;
import service.CarService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 维修管理控制器
 * 司机(4)：维修事务管理——提交报修申请、查看/取消本人报修
 * 管理员(1)：查看全部维修事务
 */
public class RepairServlet extends HttpServlet {

    private RepairApplyDao repairApplyDao = new RepairApplyDao();
    private RepairUnitDao repairUnitDao = new RepairUnitDao();
    private CarService carService = new CarService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        // 司机(4)或管理员(1)可访问
        if (currentUser.getRoleId() != 4 && currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        List<RepairApply> all = repairApplyDao.findAll();
        List<RepairApply> repairs;
        if (currentUser.getRoleId() == 4) {
            // 司机只看本人提交的报修
            repairs = new ArrayList<>();
            for (RepairApply r : all) {
                if (currentUser.getId().equals(r.getApplicantId())) {
                    repairs.add(r);
                }
            }
        } else {
            repairs = all;
        }
        req.setAttribute("repairs", repairs);
        // 报修表单可选车辆列表与维修单位列表
        req.setAttribute("cars", carService.getAllCars());
        req.setAttribute("units", repairUnitDao.findAll());

        String msg = req.getParameter("msg");
        String err = req.getParameter("err");
        if (msg != null && !msg.isEmpty()) req.setAttribute("message", msg);
        if (err != null && !err.isEmpty()) req.setAttribute("error", err);

        req.getRequestDispatcher("/repair_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (currentUser.getRoleId() != 4 && currentUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/index");
            return;
        }

        String action = req.getParameter("action");
        if ("cancel".equals(action)) {
            cancelRepair(req, resp, currentUser);
        } else {
            submitRepair(req, resp, currentUser);
        }
    }

    /** 司机提交报修申请 */
    private void submitRepair(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        String carIdStr = req.getParameter("carId");
        String faultDesc = req.getParameter("faultDesc");
        String repairUnitName = req.getParameter("repairUnitName");
        String totalCostStr = req.getParameter("totalCost");

        if (carIdStr == null || carIdStr.trim().isEmpty()
                || faultDesc == null || faultDesc.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("请填写报修车辆和故障描述"));
            return;
        }

        try {
            RepairApply apply = new RepairApply();
            apply.setWorkOrderNo("WX" + System.currentTimeMillis());
            apply.setApplicantId(currentUser.getId());
            apply.setCarId(Integer.parseInt(carIdStr.trim()));
            apply.setApplyTime(LocalDateTime.now());
            apply.setFaultDesc(faultDesc.trim());
            apply.setRepairUnitName(repairUnitName != null && !repairUnitName.trim().isEmpty() ? repairUnitName.trim() : null);
            apply.setRepairProjectId(null);
            if (totalCostStr != null && !totalCostStr.trim().isEmpty()) {
                apply.setTotalCost(new BigDecimal(totalCostStr.trim()));
            }
            apply.setApproverId(null);
            apply.setApproveStatus("待审批");

            boolean ok = repairApplyDao.insert(apply);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/repair?msg=" + enc("报修申请提交成功，已进入待审批"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("报修申请提交失败"));
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("参数格式错误"));
        }
    }

    /** 司机取消（删除）本人尚未审批的报修 */
    private void cancelRepair(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        String workOrderNo = req.getParameter("workOrderNo");
        if (workOrderNo == null || workOrderNo.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("缺少工单号"));
            return;
        }
        RepairApply apply = repairApplyDao.findById(workOrderNo.trim());
        if (apply == null) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("报修记录不存在"));
            return;
        }
        // 司机只能取消本人、且仍为待审批的报修
        if (currentUser.getRoleId() == 4 && !currentUser.getId().equals(apply.getApplicantId())) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("无权取消他人的报修"));
            return;
        }
        if (!"待审批".equals(apply.getApproveStatus())) {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("该报修已审批，无法取消"));
            return;
        }
        boolean ok = repairApplyDao.delete(workOrderNo.trim());
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/repair?msg=" + enc("报修已取消"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/repair?err=" + enc("取消失败"));
        }
    }

    private static String enc(String s) {
        return java.net.URLEncoder.encode(s, java.nio.charset.StandardCharsets.UTF_8);
    }
}
