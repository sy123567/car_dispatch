package entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "fix_order")
public class RepairApply {
    
    @Id
    @Column(name = "工单号", length = 50)
    private String workOrderNo;
    
    @Column(name = "申请人ID")
    private Integer applicantId;
    
    @Column(name = "车ID")
    private Integer carId;
    
    @Column(name = "申请时间")
    private LocalDateTime applyTime;
    
    @Column(name = "故障描述", length = 255)
    private String faultDesc;
    
    @Column(name = "维修单位名", length = 100)
    private String repairUnitName;
    
    @Column(name = "维修项目")
    private Integer repairProjectId;
    
    @Column(name = "维修总费用", precision = 10, scale = 2)
    private BigDecimal totalCost;
    
    @Column(name = "审批人工号")
    private Integer approverId;
    
    @Column(name = "审批状态", length = 50)
    private String approveStatus;

    public RepairApply() {
    }

    public String getWorkOrderNo() {
        return workOrderNo;
    }

    public void setWorkOrderNo(String workOrderNo) {
        this.workOrderNo = workOrderNo;
    }

    public Integer getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(Integer applicantId) {
        this.applicantId = applicantId;
    }

    public Integer getCarId() {
        return carId;
    }

    public void setCarId(Integer carId) {
        this.carId = carId;
    }

    public LocalDateTime getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(LocalDateTime applyTime) {
        this.applyTime = applyTime;
    }

    public String getFaultDesc() {
        return faultDesc;
    }

    public void setFaultDesc(String faultDesc) {
        this.faultDesc = faultDesc;
    }

    public String getRepairUnitName() {
        return repairUnitName;
    }

    public void setRepairUnitName(String repairUnitName) {
        this.repairUnitName = repairUnitName;
    }

    public Integer getRepairProjectId() {
        return repairProjectId;
    }

    public void setRepairProjectId(Integer repairProjectId) {
        this.repairProjectId = repairProjectId;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }

    public Integer getApproverId() {
        return approverId;
    }

    public void setApproverId(Integer approverId) {
        this.approverId = approverId;
    }

    public String getApproveStatus() {
        return approveStatus;
    }

    public void setApproveStatus(String approveStatus) {
        this.approveStatus = approveStatus;
    }
}