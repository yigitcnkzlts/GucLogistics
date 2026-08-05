package com.guclogistics.vehicles.infrastructure.persistence;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface VehicleJpaRepository extends JpaRepository<VehicleEntity, UUID> {

    List<VehicleEntity> findByCreatedByUserIdOrderByCreatedAtDesc(UUID createdByUserId);

    Optional<VehicleEntity> findByIdAndCreatedByUserId(UUID id, UUID createdByUserId);
}
