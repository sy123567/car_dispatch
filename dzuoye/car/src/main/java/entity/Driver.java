package entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "driver")
public class Driver {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;
    
    @Column(name = "用户ID")
    private Integer userId;
    
    @Column(name = "姓名", nullable = false, length = 50)
    private String name;
    
    @Column(name = "工号", nullable = false, length = 50)
    private String employeeNo;
    
    @Column(name = "联系方式", length = 30)
    private String contact;
    
    @Column(name = "驾驶证号", length = 50)
    private String driverLicenseNo;
    
    @Column(name = "驾驶证有效期")
    @Temporal(TemporalType.DATE)
    private Date licenseExpireDate;
    
    @Column(name = "从业资格证号", length = 50)
    private String qualificationNo;
    
    @Column(name = "资格证有效期")
    @Temporal(TemporalType.DATE)
    private Date qualificationExpireDate;
    
    @Column(name = "司机状态")
    private Integer driverStatusId;

    @Transient
    private String statusName;

    public Driver() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmployeeNo() {
        return employeeNo;
    }

    public void setEmployeeNo(String employeeNo) {
        this.employeeNo = employeeNo;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getDriverLicenseNo() {
        return driverLicenseNo;
    }

    public void setDriverLicenseNo(String driverLicenseNo) {
        this.driverLicenseNo = driverLicenseNo;
    }

    public Date getLicenseExpireDate() {
        return licenseExpireDate;
    }

    public void setLicenseExpireDate(Date licenseExpireDate) {
        this.licenseExpireDate = licenseExpireDate;
    }

    public String getQualificationNo() {
        return qualificationNo;
    }

    public void setQualificationNo(String qualificationNo) {
        this.qualificationNo = qualificationNo;
    }

    public Date getQualificationExpireDate() {
        return qualificationExpireDate;
    }

    public void setQualificationExpireDate(Date qualificationExpireDate) {
        this.qualificationExpireDate = qualificationExpireDate;
    }

    public Integer getDriverStatusId() {
        return driverStatusId;
    }

    public void setDriverStatusId(Integer driverStatusId) {
        this.driverStatusId = driverStatusId;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }
}