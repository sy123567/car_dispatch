package entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "car_record")
public class CarRecord {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;
    
    @Column(name = "派车单ID", unique = true, nullable = false)
    private Integer dispatchId;
    
    @Column(name = "实际出车时间")
    private LocalDateTime actualDepartTime;
    
    @Column(name = "实际回车时间")
    private LocalDateTime actualReturnTime;
    
    @Column(name = "实际里程", precision = 10, scale = 2)
    private BigDecimal actualMileage;
    
    @Column(name = "油耗", precision = 10, scale = 2)
    private BigDecimal fuelConsumption;
    
    @Column(name = "车辆状态")
    private Integer carStatusId;

    public CarRecord() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getDispatchId() {
        return dispatchId;
    }

    public void setDispatchId(Integer dispatchId) {
        this.dispatchId = dispatchId;
    }

    public LocalDateTime getActualDepartTime() {
        return actualDepartTime;
    }

    public void setActualDepartTime(LocalDateTime actualDepartTime) {
        this.actualDepartTime = actualDepartTime;
    }

    public LocalDateTime getActualReturnTime() {
        return actualReturnTime;
    }

    public void setActualReturnTime(LocalDateTime actualReturnTime) {
        this.actualReturnTime = actualReturnTime;
    }

    public BigDecimal getActualMileage() {
        return actualMileage;
    }

    public void setActualMileage(BigDecimal actualMileage) {
        this.actualMileage = actualMileage;
    }

    public BigDecimal getFuelConsumption() {
        return fuelConsumption;
    }

    public void setFuelConsumption(BigDecimal fuelConsumption) {
        this.fuelConsumption = fuelConsumption;
    }

    public Integer getCarStatusId() {
        return carStatusId;
    }

    public void setCarStatusId(Integer carStatusId) {
        this.carStatusId = carStatusId;
    }
}