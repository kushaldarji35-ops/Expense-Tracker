package com.Grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.Grownited.entity.UserDetailEntity;

import jakarta.transaction.Transactional;

@Repository
public interface UserDetailRepository extends JpaRepository<UserDetailEntity, Integer>{

	void deleteByUser_UserId(Integer userId);

	@Modifying
	@Transactional
	@Query("DELETE FROM UserDetailEntity u WHERE u.user.userId = :userId")
	void deleteUserDetailsByUserId(@Param("userId") Integer userId);
}