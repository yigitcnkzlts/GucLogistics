package com.guclogistics.loads.infrastructure.persistence;

import com.guclogistics.loads.domain.LoadStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;

public interface LoadJpaRepository extends JpaRepository<LoadEntity, UUID> {

    Optional<LoadEntity> findByIdAndCreatedByUserId(UUID id, UUID createdByUserId);

    @Query("""
            SELECT l FROM LoadEntity l
            WHERE (
                l.status = com.guclogistics.loads.domain.LoadStatus.PUBLISHED
                OR (l.status = com.guclogistics.loads.domain.LoadStatus.DRAFT AND l.createdByUserId = :userId)
            )
            AND (:status IS NULL OR l.status = :status)
            AND (:pickupCountry IS NULL OR l.pickupCountry = :pickupCountry)
            AND (:dropoffCountry IS NULL OR l.dropoffCountry = :dropoffCountry)
            AND (:minWeight IS NULL OR l.weightKg >= :minWeight)
            AND (:maxWeight IS NULL OR l.weightKg <= :maxWeight)
            ORDER BY l.createdAt DESC
            """)
    Page<LoadEntity> searchVisibleLoads(
            @Param("userId") UUID userId,
            @Param("status") LoadStatus status,
            @Param("pickupCountry") String pickupCountry,
            @Param("dropoffCountry") String dropoffCountry,
            @Param("minWeight") BigDecimal minWeight,
            @Param("maxWeight") BigDecimal maxWeight,
            Pageable pageable
    );
}
