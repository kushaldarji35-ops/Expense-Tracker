package com.Grownited.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.Grownited.entity.IncomeEntity;
import com.Grownited.entity.UserEntity;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import org.springframework.transaction.annotation.Transactional;

public interface IncomeRepository extends JpaRepository<IncomeEntity, Integer> {

    // ================= ADMIN =================
    @Query("""
        select coalesce(sum(i.amount), 0)
        from IncomeEntity i
        where i.date between :startDate and :endDate
    """)
    Double sumIncomeBetweenDates(@Param("startDate") LocalDate startDate,
                                @Param("endDate") LocalDate endDate);


    // ================= USER =================
    @Query("""
        select coalesce(sum(i.amount), 0)
        from IncomeEntity i
        where i.user.userId = :userId
          and i.date between :startDate and :endDate
    """)
    Double sumIncomeBetweenDatesByUser(@Param("userId") Integer userId,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate);


    // ================= COMMON =================

    // Get all income of a specific user
    List<IncomeEntity> findByUser(UserEntity user);

    // Check account used in income
    boolean existsByAccountAccountId(Integer accountId);


    // ⭐ NEW (OPTION 3 READY - MONTHLY GRAPH)
    @Query("""
        select month(i.date), coalesce(sum(i.amount),0)
        from IncomeEntity i
        group by month(i.date)
        order by month(i.date)
    """)
    List<Object[]> getMonthlyIncome();
    
    @Query("SELECT SUM(i.amount) FROM IncomeEntity i")
    Double getTotalIncome();
    
 // 🔍 SEARCH + PAGINATION
    Page<IncomeEntity> findByTitleContainingIgnoreCase(String title, Pageable pageable);
    
    Page<IncomeEntity> findByDateBetweenAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String title,
            Pageable pageable
    );
    
    Page<IncomeEntity> findByUser(UserEntity user, Pageable pageable);

    Page<IncomeEntity> findByUserAndTitleContainingIgnoreCase(
            UserEntity user, String keyword, Pageable pageable);
    
 
    List<IncomeEntity> findByUserAndDateBetween(
            UserEntity user,
            LocalDate startDate,
            LocalDate endDate
    );
    
    Page<IncomeEntity> findByUserAndStatus_Status(
            UserEntity user, String status, Pageable pageable);

    Page<IncomeEntity> findByUserAndTitleContainingIgnoreCaseAndStatus_Status(
            UserEntity user, String title, String status, Pageable pageable);
    
 // ✅ STATUS FILTER (ADMIN)
    Page<IncomeEntity> findByStatus_Status(String status, Pageable pageable);

    // ✅ DATE + STATUS + SEARCH (ADMIN)
    Page<IncomeEntity> findByDateBetweenAndStatus_StatusAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String status,
            String title,
            Pageable pageable
    );
    
    List<IncomeEntity> findByStatus_Status(String status);

    List<IncomeEntity> findByDateBetweenAndStatus_StatusAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String status,
            String keyword
    );
    
 // ✅ FOR PDF (NO PAGINATION)
    List<IncomeEntity> findByDateBetweenAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String keyword
    );


	List<IncomeEntity> findByTitleContainingIgnoreCase(String keyword);
    
	List<IncomeEntity> findByUserAndStatus_Status(UserEntity user, String status);

	List<IncomeEntity> findByUserAndStatus_StatusAndDateBetweenAndTitleContainingIgnoreCase(
	        UserEntity user,
	        String status,
	        LocalDate startDate,
	        LocalDate endDate,
	        String keyword
	);
	@Transactional
	void deleteByUser_UserId(Integer userId);
	
	@Transactional
	@Modifying
	@Query("DELETE FROM IncomeEntity i WHERE i.user.userId = :userId")
	void deleteIncomeByUserId(@Param("userId") Integer userId);
}