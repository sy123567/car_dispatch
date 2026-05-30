package entity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "maintain_project")
public class RepairProject {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "项目ID")
    private Integer projectId;
    
    @Column(name = "项目类型", length = 100)
    private String projectType;
    
    @Column(name = "单价", precision = 10, scale = 2)
    private BigDecimal unitPrice;

    public RepairProject() {
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
}