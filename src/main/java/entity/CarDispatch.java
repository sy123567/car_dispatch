package entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "car_dispatch")
public class CarDispatch {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;
    
    @Column(name = "申请ID")
    private Integer applyId;
    
    @Column(name = "车辆ID")
    private Integer carId;
    
    @Column(name = "司机ID")
    private Integer driverId;
    
    @Column(name = "用车日期")
    private LocalDateTime useDate;
    
    @Column(name = "还车日期")
    private LocalDateTime returnDate;

    public CarDispatch() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getApplyId() {
        return applyId;
    }

    public void setApplyId(Integer applyId) {
        this.applyId = applyId;
    }

    public Integer getCarId() {
        return carId;
    }

    public void setCarId(Integer carId) {
        this.carId = carId;
    }

    public Integer getDriverId() {
        return driverId;
    }

    public void setDriverId(Integer driverId) {
        this.driverId = driverId;
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
}