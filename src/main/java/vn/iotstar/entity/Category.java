package vn.iotstar.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "Categories")
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "NVARCHAR(200)")
    private String name;

    @Column(columnDefinition = "NVARCHAR(500)")
    private String images;

    @Column(nullable = false)
    private Integer status = 1; // 1: Active, 0: Inactive

    public Category() {}

    public Category(String name, String images, Integer status) {
        this.name = name;
        this.images = images;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
}
