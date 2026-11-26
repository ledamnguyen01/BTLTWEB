package vn.iotstar.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class RememberMeUtil {

    private static final String HMAC_ALG = "HmacSHA256";
    private static final String DEFAULT_SECRET = "SB4_HCMUTE_24110040_REMEMBER_KEY_2026";

    private static String getSecret() {
        String envSecret = System.getenv("APP_REMEMBER_SECRET");
        return (envSecret != null && !envSecret.isBlank()) ? envSecret : DEFAULT_SECRET;
    }

    public static String createToken(String username) {
        if (username == null || username.isBlank()) {
            return "";
        }
        String sig = sign(username);
        String payload = username + ":" + sig;
        return Base64.getUrlEncoder().withoutPadding().encodeToString(payload.getBytes(StandardCharsets.UTF_8));
    }

    public static String verifyAndExtractUsername(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }
        try {
            String decoded = new String(Base64.getUrlDecoder().decode(token), StandardCharsets.UTF_8);
            int idx = decoded.lastIndexOf(':');
            if (idx <= 0 || idx == decoded.length() - 1) {
                return null;
            }
            String username = decoded.substring(0, idx);
            String providedSig = decoded.substring(idx + 1);
            String expectedSig = sign(username);
            if (MessageDigest.isEqual(
                    providedSig.getBytes(StandardCharsets.UTF_8),
                    expectedSig.getBytes(StandardCharsets.UTF_8))) {
                return username;
            }
        } catch (Exception ignored) {
            return null;
        }
        return null;
    }

    private static String sign(String data) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALG);
            mac.init(new SecretKeySpec(getSecret().getBytes(StandardCharsets.UTF_8), HMAC_ALG));
            byte[] raw = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(raw);
        } catch (Exception e) {
            throw new IllegalStateException("Cannot compute HMAC signature", e);
        }
    }
}
