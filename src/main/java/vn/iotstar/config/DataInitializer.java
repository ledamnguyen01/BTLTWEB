package vn.iotstar.config;

import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.repository.CategoryRepository;
import vn.iotstar.repository.UserRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;

    public DataInitializer(UserRepository userRepository, CategoryRepository categoryRepository) {
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public void run(String... args) {
        if (userRepository.count() == 0) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(BCrypt.hashpw("123456", BCrypt.gensalt(10)));
            admin.setEmail("admin@hcmute.edu.vn");
            admin.setFullname("Quản Trị Viên");
            admin.setPhone("0901234567");
            admin.setRole("ADMIN");
            admin.setStatus(1);

            User user = new User();
            user.setUsername("user");
            user.setPassword(BCrypt.hashpw("123456", BCrypt.gensalt(10)));
            user.setEmail("user@hcmute.edu.vn");
            user.setFullname("Lê Đàm Nguyên");
            user.setPhone("0989574059");
            user.setRole("USER");
            user.setStatus(1);

            userRepository.saveAll(List.of(admin, user));
            System.out.println(">>> [DataInitializer] Đã khởi tạo tài khoản mẫu: admin/123456 (ADMIN), user/123456 (USER)");
        }

        if (categoryRepository.count() == 0) {
            List<Category> samples = List.of(
                new Category("Điện thoại & Smartphone", "phone.png", 1),
                new Category("Laptop & Máy tính xách tay", "laptop.png", 1),
                new Category("Máy tính bảng (Tablet)", "tablet.png", 1),
                new Category("Phụ kiện công nghệ", "accessory.png", 1),
                new Category("Đồng hồ thông minh", "watch.png", 1),
                new Category("Tai nghe & Âm thanh", "audio.png", 1),
                new Category("Màn hình & Linh kiện PC", "monitor.png", 1),
                new Category("Thiết bị mạng & Wi-Fi", "network.png", 1),
                new Category("Máy ảnh & Quay phim", "camera.png", 1),
                new Category("Thiết bị nhà thông minh", "smarthome.png", 0)
            );
            categoryRepository.saveAll(samples);
            System.out.println(">>> [DataInitializer] Đã khởi tạo " + samples.size() + " danh mục mẫu.");
        }
    }
}
