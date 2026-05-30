package entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "car")
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @Column(name = "车牌号", nullable = false, length = 30)
    private String licensePlate;

    @Column(name = "品牌", length = 50)
    private String brand;

    @Column(name = "车型", length = 50)
    private String model;

    @Column(name = "购置日期")
    @Temporal(TemporalType.DATE)
    private Date purchaseDate;

    @Column(name = "排量", length = 30)
    private String displacement;

    @Column(name = "行驶证号", length = 50)
    private String drivingLicenseNo;

    @Column(name = "车辆状态")
    private Integer carStatusId;

    @Column(name = "年检到期日")
    @Temporal(TemporalType.DATE)
    private Date inspectionExpireDate;

    @Column(name = "保险到期日")
    @Temporal(TemporalType.DATE)
    private Date insuranceExpireDate;

    public Car() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public String getDisplacement() {
        return displacement;
    }

    public void setDisplacement(String displacement) {
        this.displacement = displacement;
    }

    public String getDrivingLicenseNo() {
        return drivingLicenseNo;
    }

    public void setDrivingLicenseNo(String drivingLicenseNo) {
        this.drivingLicenseNo = drivingLicenseNo;
    }

    public Integer getCarStatusId() {
        return carStatusId;
    }

    public void setCarStatusId(Integer carStatusId) {
        this.carStatusId = carStatusId;
    }

    public Date getInspectionExpireDate() {
        return inspectionExpireDate;
    }

    public void setInspectionExpireDate(Date inspectionExpireDate) {
        this.inspectionExpireDate = inspectionExpireDate;
    }

    public Date getInsuranceExpireDate() {
        return insuranceExpireDate;
    }

    public void setInsuranceExpireDate(Date insuranceExpireDate) {
        this.insuranceExpireDate = insuranceExpireDate;
    }
}