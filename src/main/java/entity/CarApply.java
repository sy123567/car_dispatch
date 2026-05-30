package entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "car_apply")
public class CarApply {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "申请ID")
    private Integer applyId;
    
    @Column(name = "员工ID", nullable = false)
    private Integer employeeId;
    
    @Column(name = "申请日期")
    private LocalDateTime applyDate;
    
    @Column(name = "用车日期")
    private LocalDateTime useDate;
    
    @Column(name = "还车日期")
    private LocalDateTime returnDate;
    
    @Column(name = "用车原因", length = 255)
    private String reason;
    
    @Column(name = "目的地", length = 255)
    private String destination;
    
    @Column(name = "乘车人数")
    private Integer passengerCount;
    
    @Column(name = "申请状态", length = 50)
    private String applyStatus;
    
    @Column(name = "审批人ID")
    private Integer approverId;
    
    @Column(name = "审批意见", length = 255)
    private String approveComment;
    
    @Column(name = "审批时间")
    private LocalDateTime approveTime;

    @Column(name = "往返类型", length = 20)
    private String tripType; // 单程/往返

    @Column(name = "备注", length = 500)
    private String remark;

    public CarApply() {
    }

    public Integer getApplyId() {
        return applyId;
    }

    public void setApplyId(Integer applyId) {
        this.applyId = applyId;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    public LocalDateTime getApplyDate() {
        return applyDate;
    }

    public void setApplyDate(LocalDateTime applyDate) {
        this.applyDate = applyDate;
    }

    public LocalDateTime getUseDate() {
        return useDate;
    }

    public void setUseDate(LocalDateTime useDate) {
        this.useDate = useDate;
    }

    public LocalDateTime getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDateTime returnDate) {
        this.returnDate = returnDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public Integer getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(Integer passengerCount) {
        this.passengerCount = passengerCount;
    }

    public String getApplyStatus() {
        return applyStatus;
    }

    public void setApplyStatus(String applyStatus) {
        this.applyStatus = applyStatus;
    }

    public Integer getApproverId() {
        return approverId;
    }

    public void setApproverId(Integer approverId) {
        this.approverId = approverId;
    }

    public String getApproveComment() {
        return approveComment;
    }

    public void setApproveComment(String approveComment) {
        this.approveComment = approveComment;
    }

    public LocalDateTime getApproveTime() {
        return approveTime;
    }

    public void setApproveTime(LocalDateTime approveTime) {
        this.approveTime = approveTime;
    }

    public String getTripType() {
        return tripType;
    }

    public void setTripType(String tripType) {
        this.tripType = tripType;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}