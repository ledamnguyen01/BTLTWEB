package vn.iotstar.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

    private static final Set<String> ALLOWED_EXT = Set.of("jpg", "jpeg", "png", "gif", "webp");

    public static boolean isValidImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return true;
        }
        String orig = file.getOriginalFilename();
        if (orig == null || !orig.contains(".")) {
            return false;
        }
        String ext = orig.substring(orig.lastIndexOf('.') + 1).toLowerCase();
        String ct = file.getContentType();
        if (!ALLOWED_EXT.contains(ext)) {
            return false;
        }
        return ct == null || ct.toLowerCase().startsWith("image/");
    }

    public static String saveImage(MultipartFile file, String uploadDir, String prefix) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        String orig = file.getOriginalFilename();
        String ext = (orig != null && orig.contains("."))
                ? orig.substring(orig.lastIndexOf('.') + 1).toLowerCase()
                : "png";
        String safeFileName = prefix + "_" + System.currentTimeMillis() + "_"
                + UUID.randomUUID().toString().substring(0, 8) + "." + ext;

        Path dirPath = Paths.get(uploadDir).toAbsolutePath().normalize();
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
        }
        Path target = dirPath.resolve(safeFileName);
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        return safeFileName;
    }
}
