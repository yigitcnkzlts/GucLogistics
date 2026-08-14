package com.guclogistics.matching.api;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/** Temporary payments/escrow ledger until a dedicated payments module ships. */
@RestController
@RequestMapping("/api/v1/payments")
@Tag(name = "Payments (stub)")
public class PaymentsStubController {

    private final List<Map<String, Object>> ledger = new ArrayList<>();

    public PaymentsStubController() {
        ledger.add(Map.of(
                "id", UUID.randomUUID().toString(),
                "shipmentId", "stub-ship-1",
                "label", "Escrow hold",
                "amount", 2050,
                "currency", "EUR",
                "kind", "HOLD",
                "at", Instant.now().toString()
        ));
    }

    @GetMapping("/ledger")
    public List<Map<String, Object>> ledger() {
        return List.copyOf(ledger);
    }

    @PostMapping("/{shipmentId}/release")
    public Map<String, Object> release(@PathVariable String shipmentId) {
        var release = Map.<String, Object>of(
                "id", UUID.randomUUID().toString(),
                "shipmentId", shipmentId,
                "label", "Escrow release",
                "amount", 2050,
                "currency", "EUR",
                "kind", "RELEASE",
                "at", Instant.now().toString()
        );
        var payout = Map.<String, Object>of(
                "id", UUID.randomUUID().toString(),
                "shipmentId", shipmentId,
                "label", "Carrier payout",
                "amount", 1988.5,
                "currency", "EUR",
                "kind", "PAYOUT",
                "at", Instant.now().toString()
        );
        ledger.add(0, payout);
        ledger.add(0, release);
        return Map.of("ok", true, "shipmentId", shipmentId);
    }
}
