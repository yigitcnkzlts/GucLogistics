package com.guclogistics.matching.api;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/v1/devices")
@Tag(name = "Devices (stub)")
public class DevicesStubController {

    private final Map<String, String> tokens = new ConcurrentHashMap<>();

    @PostMapping("/push-token")
    public Map<String, Object> register(@RequestBody Map<String, String> body) {
        var token = body.getOrDefault("token", "");
        var platform = body.getOrDefault("platform", "unknown");
        if (!token.isBlank()) {
            tokens.put(token, platform);
        }
        return Map.of("ok", true, "registered", tokens.size());
    }
}
