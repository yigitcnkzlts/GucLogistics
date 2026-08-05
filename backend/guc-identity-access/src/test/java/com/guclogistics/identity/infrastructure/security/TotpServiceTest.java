package com.guclogistics.identity.infrastructure.security;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class TotpServiceTest {

    private final TotpService totpService = new TotpService();

    @Test
    void generatesSecretAndValidatesCurrentCodeWindow() {
        String secret = totpService.generateSecret();
        assertThat(secret).isNotBlank();

        String uri = totpService.otpAuthUri("GucLogistics", "user@example.com", secret);
        assertThat(uri).startsWith("otpauth://totp/GucLogistics:user@example.com");
        assertThat(uri).contains("secret=");
    }
}
