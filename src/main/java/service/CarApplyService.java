package service;

import dao.CarApplyDao;
import dao.CarDispatchDao;
import entity.CarApply;
import entity.CarDispatch;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 用车申请与调度业务逻辑层
 */
public class CarApplyService {

    private CarApplyDao carApplyDao = new CarApplyDao();
    private CarDispatchDao carDispatchDao = new CarDispatchDao();

    /**
     * 提交用车申请
     */
    public boolean submitApply(CarApply apply) {
        if (apply == null) {
            return false;
        }
        // 自动设置申请日期为当前时间
        apply.setApplyDate(LocalDateTime.now());
        apply.setApplyStatus("待审批");
        return carApplyDao.insert(apply);
    }

    /**
     * 审批用车申请
     * 触发器会自动处理：审批通过后自动派车
     */
    public boolean approveApply(Integer applyId, Integer approverId, String comment, String status) {
        CarApply apply = carApplyDao.findById(applyId);
        if (apply == null) {
            return false;
        }
        apply.setApproverId(approverId);
        apply.setApproveComment(comment);
        apply.setApplyStatus(status);
        // 自动设置审批时间为当前时间
        apply.setApproveTime(LocalDateTime.now());
        return carApplyDao.update(apply);
    }

    /**
     * 获取所有申请
     */
    public List<CarApply> getAllApplies() {
        return carApplyDao.findAll();
    }

    /**
     * 根据员工ID获取申请
     */
    public List<CarApply> getAppliesByEmployee(Integer employeeId) {
        return carApplyDao.findByEmployeeId(employeeId);
    }

    /**
     * 根据状态获取申请
     */
    public List<CarApply> getAppliesByStatus(String status) {
        return carApplyDao.findByStatus(status);
    }

    /**
     * 搜索申请（按编号、申请人、目的地）
     */
    public List<CarApply> searchApplies(String keyword) {
        return carApplyDao.search(keyword);
    }

    /**
     * 获取申请详情（含派车信息）
     */
    public CarApply getApplyDetail(Integer applyId) {
        return carApplyDao.findById(applyId);
    }

    /**
     * 获取派车单
     */
    public CarDispatch getDispatchByApplyId(Integer applyId) {
        return carDispatchDao.findByApplyId(applyId);
    }

    /**
     * 删除申请
     */
    public boolean deleteApply(Integer applyId) {
        return carApplyDao.delete(applyId);
    }

    /**
     * 验证申请数据的合理性
     * @return 验证通过返回null，否则返回错误信息
     */
    public String validateApply(CarApply apply) {
        if (apply == null) {
            return "申请数据不能为空";
        }
        // 用车时间不能是过去的时间（允许5分钟内的时钟偏差）
        if (apply.getUseDate() != null && apply.getUseDate().isBefore(LocalDateTime.now().minusMinutes(5))) {
            return "用车时间不能早于当前时间";
        }
        // 还车时间必须晚于用车时间
        if (apply.getUseDate() != null && apply.getReturnDate() != null 
                && !apply.getReturnDate().isAfter(apply.getUseDate())) {
            return "还车时间必须晚于用车时间";
        }
        // 用车时长不能超过30天
        if (apply.getUseDate() != null && apply.getReturnDate() != null) {
            long days = java.time.Duration.between(apply.getUseDate(), apply.getReturnDate()).toDays();
            if (days > 30) {
                return "单次用车时长不能超过30天";
            }
        }
        // 乘车人数验证
        if (apply.getPassengerCount() == null || apply.getPassengerCount() < 1) {
            return "乘车人数至少为1人";
        }
        if (apply.getPassengerCount() > 50) {
            return "乘车人数不能超过50人";
        }
        // 目的地不能为空
        if (apply.getDestination() == null || apply.getDestination().trim().isEmpty()) {
            return "目的地不能为空";
        }
        // 用车原因不能为空
        if (apply.getReason() == null || apply.getReason().trim().isEmpty()) {
            return "用车原因不能为空";
        }
        return null; // 验证通过
    }
}
