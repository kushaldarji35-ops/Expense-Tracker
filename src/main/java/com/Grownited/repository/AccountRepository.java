package com.Grownited.repository;

import java.util.List;

import org.springframework.data.domain.Page;        // ✅ ADDED
import org.springframework.data.domain.Pageable;   // ✅ ADDED
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.AccountEntity;

import jakarta.transaction.Transactional;

@Repository
public interface AccountRepository extends JpaRepository<AccountEntity, Integer>{

    List<AccountEntity> findByUserId(Integer userId);

    @Query("SELECT SUM(a.amount) FROM AccountEntity a")
    Double getTotalBalance();

    // 🔍 SEARCH + PAGINATION
    Page<AccountEntity> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    // Pagination + User filter
    Page<AccountEntity> findByUserId(Integer userId, Pageable pageable);

    // Search + Pagination
    Page<AccountEntity> findByUserIdAndTitleContainingIgnoreCase(
            Integer userId, String title, Pageable pageable);

    // ✅ FIXED HERE (Long → Integer)
    Page<AccountEntity> findByUserIdAndAccountType(
            Integer userId, String accountType, Pageable pageable);

    Page<AccountEntity> findByUserIdAndTitleContainingIgnoreCaseAndAccountType(
            Integer userId, String title, String accountType, Pageable pageable);

        // delete accounts of specific user
        @Modifying
        @Transactional
        @Query("DELETE FROM AccountEntity a WHERE a.userId = :userId")
        void deleteByUserId(@Param("userId") Integer userId);

        // 🔥 CLEANUP OLD INVALID DATA
        @Modifying
        @Transactional
        @Query("DELETE FROM AccountEntity a WHERE a.userId NOT IN (SELECT u.userId FROM UserEntity u)")
        void deleteOrphanAccounts();
    }