package com.Grownited.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.CategoryEntity;

@Repository
public interface CategoryRepository extends JpaRepository<CategoryEntity, Integer>{

    // 🔍 SEARCH + PAGINATION
    Page<CategoryEntity> findByCategoryNameContainingIgnoreCase(String categoryName, Pageable pageable);
}