package com.guclogistics.offers.infrastructure.persistence;

import com.guclogistics.offers.domain.OfferStatus;
import com.guclogistics.offers.domain.OffererType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "offers")
@Getter
@Setter
public class OfferEntity {

    @Id
    private UUID id;

    @Column(name = "load_id", nullable = false)
    private UUID loadId;

    @Enumerated(EnumType.STRING)
    @Column(name = "offerer_type", nullable = false, length = 20)
    private OffererType offererType;

    @Column(name = "offerer_id", nullable = false)
    private UUID offererId;

    @Column(name = "created_by_user_id", nullable = false)
    private UUID createdByUserId;

    @Column(nullable = false, precision = 14, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 3)
    private String currency;

    @Column(length = 1000)
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private OfferStatus status = OfferStatus.PENDING;

    @Column(name = "valid_until")
    private Instant validUntil;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    void onCreate() {
        if (id == null) {
            id = UUID.randomUUID();
        }
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = Instant.now();
    }
}
