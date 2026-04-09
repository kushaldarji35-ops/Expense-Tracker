package com.Grownited.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "vendors")
public class VendorEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vendor_id")
    private Integer vendorId;

    private String vendorName;

    // 🔥 Proper Foreign Key Mapping
    @ManyToOne
    @JoinColumn(name = "user_id")
    private UserEntity user;

    // ================= GETTERS & SETTERS =================

    public Integer getVendorId() {
        return vendorId;
    }

    public void setVendorId(Integer vendorId) {
        this.vendorId = vendorId;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }
    
    
    
    
}