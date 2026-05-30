package entity;

import javax.persistence.*;

@Entity
@Table(name = "maintain_position")
public class RepairUnit {
    
    @Id
    @Column(name = "单位名", length = 100)
    private String unitName;
    
    @Column(name = "单位地址", length = 255)
    private String unitAddress;
    
    @Column(name = "联系方式", length = 100)
    private String contact;

    public RepairUnit() {
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public String getUnitAddress() {
        return unitAddress;
    }

    public void setUnitAddress(String unitAddress) {
        this.unitAddress = unitAddress;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }
}