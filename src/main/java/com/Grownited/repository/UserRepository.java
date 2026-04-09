package com.Grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;        // ✅ ADDED
import org.springframework.data.domain.Pageable;   // ✅ ADDED
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.UserEntity;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer>{

    List<UserEntity> findByRole(String role);

    Optional<UserEntity> findByEmail(String email);

    // 🔍 SEARCH + PAGINATION (NEW)
    Page<UserEntity> findByFirstNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
            String firstName, String email, Pageable pageable);
}