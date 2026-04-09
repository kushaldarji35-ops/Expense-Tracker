package com.Grownited.repository;

import java.util.List;

import org.springframework.data.domain.Page;        // ✅ ADDED
import org.springframework.data.domain.Pageable;   // ✅ ADDED
import org.springframework.data.jpa.repository.JpaRepository;

import com.Grownited.entity.UserEntity;
import com.Grownited.entity.VendorEntity;

public interface VendorRepository extends JpaRepository<VendorEntity, Integer> {

    // 🔥 Fetch only logged-in user's vendors
    List<VendorEntity> findByUser(UserEntity user);

    // 🔍 SEARCH + PAGINATION (NEW)
    Page<VendorEntity> findByVendorNameContainingIgnoreCase(String vendorName, Pageable pageable);
}