package com.Grownited.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.Grownited.entity.ExpenseEntity;
import com.Grownited.entity.UserEntity;

import jakarta.transaction.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ExpenseRepository extends JpaRepository<ExpenseEntity, Integer> {

    // ================= ADMIN =================
    @Query("""
        select coalesce(sum(e.amount), 0)
        from ExpenseEntity e
        where e.date between :startDate and :endDate
    """)
    Double sumExpenseBetweenDates(@Param("startDate") LocalDate startDate,
                                 @Param("endDate") LocalDate endDate);

    @Query("""
        select e.category.categoryName, sum(e.amount)
        from ExpenseEntity e
        where e.date between :startDate and :endDate
        group by e.category.categoryName
        order by sum(e.amount) desc
    """)
    List<Object[]> findTopExpenseCategory(@Param("startDate") LocalDate startDate,
                                         @Param("endDate") LocalDate endDate);

    // ================= USER =================
    @Query("""
        select coalesce(sum(e.amount), 0)
        from ExpenseEntity e
        where e.user.userId = :userId
          and e.date between :startDate and :endDate
    """)
    Double sumExpenseBetweenDatesByUser(@Param("userId") Integer userId,
                                       @Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate);

    @Query("""
        select e.category.categoryName, sum(e.amount)
        from ExpenseEntity e
        where e.user.userId = :userId
          and e.date between :startDate and :endDate
        group by e.category.categoryName
        order by sum(e.amount) desc
    """)
    List<Object[]> findTopExpenseCategoryByUser(@Param("userId") Integer userId,
                                               @Param("startDate") LocalDate startDate,
                                               @Param("endDate") LocalDate endDate);

    // ================= COMMON =================
    List<ExpenseEntity> findByUser(UserEntity user);

    boolean existsByAccountAccountId(Integer accountId);

    @Query("""
        select month(e.date), coalesce(sum(e.amount),0)
        from ExpenseEntity e
        group by month(e.date)
        order by month(e.date)
    """)
    List<Object[]> getMonthlyExpense();

    @Query("""
        select e.category.categoryName, sum(e.amount)
        from ExpenseEntity e
        where year(e.date) = :year
        group by e.category.categoryName
    """)
    List<Object[]> findCategoryYearWise(@Param("year") Integer year);

    @Query("SELECT SUM(e.amount) FROM ExpenseEntity e")
    Double getTotalExpense();

    // 🔍 SEARCH + PAGINATION
    Page<ExpenseEntity> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    Page<ExpenseEntity> findByDateBetweenAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String title,
            Pageable pageable
    );

    Page<ExpenseEntity> findByUser(UserEntity user, Pageable pageable);

    Page<ExpenseEntity> findByUserAndTitleContainingIgnoreCase(
            UserEntity user, String keyword, Pageable pageable);

    @Query("""
        SELECT c.categoryName, SUM(e.amount)
        FROM ExpenseEntity e
        JOIN e.category c
        WHERE e.user.userId = :userId
        AND e.date BETWEEN :start AND :end
        GROUP BY c.categoryName
    """)
    List<Object[]> sumExpenseByCategory(Integer userId, LocalDate start, LocalDate end);

    List<ExpenseEntity> findByUserUserIdAndDateBetween(
            Integer userId,
            LocalDate startDate,
            LocalDate endDate
    );

    List<ExpenseEntity> findByUserAndDateBetween(UserEntity user, LocalDate startDate, LocalDate endDate);

    // ✅ FIXED PAGINATION (REMOVED StatusName)
    Page<ExpenseEntity> findByUserAndStatus_Status(
            UserEntity user, String status, Pageable pageable);

    Page<ExpenseEntity> findByUserAndTitleContainingIgnoreCaseAndStatus_Status(
            UserEntity user, String title, String status, Pageable pageable);

    // ✅ FOR PDF
    List<ExpenseEntity> findByDateBetweenAndTitleContainingIgnoreCase(
            LocalDate startDate,
            LocalDate endDate,
            String keyword
    );

    List<ExpenseEntity> findByTitleContainingIgnoreCase(String keyword);

    // ✅ STATUS
    List<ExpenseEntity> findByStatus_Status(String status);

    // ✅ USER + STATUS
    List<ExpenseEntity> findByUserAndStatus_Status(UserEntity user, String status);

    // ✅ FULL FILTER
    List<ExpenseEntity> findByUserAndStatus_StatusAndDateBetweenAndTitleContainingIgnoreCase(
            UserEntity user,
            String status,
            LocalDate startDate,
            LocalDate endDate,
            String keyword
    );
    
    void deleteByUser_UserId(Integer userId);
    
    @Transactional
    @Modifying
    @Query("DELETE FROM ExpenseEntity e WHERE e.user.userId = :userId")
    void deleteExpenseByUserId(@Param("userId") Integer userId);
	
	@Modifying
	@Transactional
	@Query("DELETE FROM ExpenseEntity e WHERE e.vendor.vendorId = :vendorId")
	void deleteByVendorId(@Param("vendorId") Integer vendorId);
}