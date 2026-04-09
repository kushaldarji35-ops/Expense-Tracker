package com.Grownited.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.SubCategoryEntity;

@Repository
public interface SubCategoryRepository extends JpaRepository<SubCategoryEntity, Integer> {

    // 🔍 SEARCH + PAGINATION
    Page<SubCategoryEntity> findBySubCategoryNameContainingIgnoreCase(String subCategoryName, Pageable pageable);
}