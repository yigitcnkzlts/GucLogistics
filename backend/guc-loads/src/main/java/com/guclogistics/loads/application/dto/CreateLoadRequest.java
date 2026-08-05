package com.guclogistics.loads.application.dto;

import jakarta.validation.constraints.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record CreateLoadRequest(
        @NotNull UUID shipperCompanyId,
        @NotBlank @Size(max = 200) String title,
        @Size(max = 5000) String description,
        @NotBlank @Size(min = 2, max = 2) String pickupCountry,
        @NotBlank @Size(max = 100) String pickupCity,
        @Size(max = 500) String pickupAddress,
        Double pickupLat,
        Double pickupLng,
        @NotBlank @Size(min = 2, max = 2) String dropoffCountry,
        @NotBlank @Size(max = 100) String dropoffCity,
        @Size(max = 500) String dropoffAddress,
        Double dropoffLat,
        Double dropoffLng,
        @NotNull Instant readyFrom,
        @NotNull Instant readyTo,
        @NotNull @DecimalMin("0.01") BigDecimal weightKg,
        @DecimalMin("0") BigDecimal volumeM3,
        @Size(max = 500) String vehicleRequirements,
        @NotBlank @Size(min = 3, max = 3) String currency
) {
}
