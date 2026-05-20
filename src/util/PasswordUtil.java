package util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * PasswordUtil - Secure password hashing using PBKDF2WithHmacSHA256.
 *
 * Uses a random 16-byte salt per password so identical passwords produce
 * different hashes, defeating rainbow-table and dictionary attacks.
 *
 * Stored format: base64(salt) + ":" + base64(hash)
 */
public class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int    ITERATIONS  = 310_000;  // OWASP 2023 recommendation
    private static final int    KEY_LENGTH  = 256;       // bits
    private static final int    SALT_BYTES  = 16;

    // Prevent instantiation
    private PasswordUtil() {}

    /**
     * Hashes a plain-text password with a freshly generated random salt.
     *
     * @param plainPassword plain-text password from the user
     * @return "saltBase64:hashBase64" string for database storage
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password must not be null or empty.");
        }
        try {
            byte[] salt = generateSalt();
            byte[] hash = pbkdf2(plainPassword.toCharArray(), salt);
            return Base64.getEncoder().encodeToString(salt)
                    + ":"
                    + Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Error hashing password.", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored hash string.
     *
     * @param plainPassword  plain-text password from the login form
     * @param storedHash     value previously returned by {@link #hashPassword}
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;

        String[] parts = storedHash.split(":");
        if (parts.length != 2) return false;

        try {
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
            byte[] actualHash   = pbkdf2(plainPassword.toCharArray(), salt);
            return slowEquals(expectedHash, actualHash);
        } catch (Exception e) {
            return false;
        }
    }

    // -----------------------------------------------------------------------
    // Private helpers
    // -----------------------------------------------------------------------

    private static byte[] generateSalt() throws NoSuchAlgorithmException {
        byte[] salt = new byte[SALT_BYTES];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    private static byte[] pbkdf2(char[] password, byte[] salt)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, KEY_LENGTH);
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);
            return skf.generateSecret(spec).getEncoded();
        } finally {
            spec.clearPassword(); // wipe sensitive data from memory
        }
    }

    /**
     * Constant-time comparison to prevent timing attacks.
     */
    private static boolean slowEquals(byte[] a, byte[] b) {
        if (a.length != b.length) return false;
        int diff = 0;
        for (int i = 0; i < a.length; i++) {
            diff |= a[i] ^ b[i];
        }
        return diff == 0;
    }
}
