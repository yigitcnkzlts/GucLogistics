package com.guclogistics.offers.application.dto;

import com.guclogistics.offers.domain.OfferStatus;
import com.guclogistics.offers.domain.OffererType;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record OfferResponse(
        UUID id,
        UUID loadId,
        OffererType offererType,
        UUID offererId,
        UUID createdByUserId,
        BigDecimal amount,
        String currency,
        String message,
        OfferStatus status,
        Instant validUntil,
        long version,
        Instant createdAt,
        Instant updatedAt
) {
}
