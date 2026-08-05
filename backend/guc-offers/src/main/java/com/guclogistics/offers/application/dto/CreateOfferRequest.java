package com.guclogistics.offers.application.dto;

import com.guclogistics.offers.domain.OffererType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
        Instant validUntil
) {
}
