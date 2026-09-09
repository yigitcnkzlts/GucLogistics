package com.guclogistics.offers.application.dto;

import com.guclogistics.offers.domain.OffererType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record CreateOfferRequest(
        @NotNull OffererType offererType,
        UUID offererId,
        @NotNull @DecimalMin("0.01") BigDecimal amount,
        @NotBlank @Size(min = 3, max = 3) String currency,
        @Size(max = 1000) String message,
        Instant validUntil,
        UUID vehicleId,
        @NotBlank @Size(max = 32) String vehiclePlate,
        @NotBlank @Size(max = 80) String vehicleType,
        @NotBlank @Size(max = 120) String driverName,
        @NotBlank @Size(max = 32) String driverPhone,
        @Positive Integer estimatedTransitHours,
        Instant availableAt
) {
    public CreateOfferRequest(
            OffererType offererType, UUID offererId, BigDecimal amount,
            String currency, String message, Instant validUntil
    ) {
        this(offererType, offererId, amount, currency, message, validUntil,
                null, "UNASSIGNED", "UNASSIGNED", "UNASSIGNED", "UNASSIGNED", null, null);
    }
}
