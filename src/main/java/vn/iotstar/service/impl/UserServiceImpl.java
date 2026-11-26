package vn.iotstar.service.impl;

import java.util.Optional;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import vn.iotstar.entity.User;
import vn.iotstar.repository.UserRepository;
import vn.iotstar.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public boolean existsByPhone(String phone) {
        return userRepository.existsByPhone(phone);
    }

    @Override
    public User register(String username, String rawPassword, String email, String fullname, String phone) {
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(BCrypt.hashpw(rawPassword, BCrypt.gensalt(10)));
        user.setEmail(email.trim().toLowerCase());
        user.setFullname(fullname.trim());
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole("USER");
        user.setStatus(1);
        return userRepository.save(user);
    }

    @Override
    public Optional<User> authenticate(String usernameOrEmail, String rawPassword) {
        if (usernameOrEmail == null || rawPassword == null) {
            return Optional.empty();
        }
        String key = usernameOrEmail.trim();
        Optional<User> opt = userRepository.findByUsername(key);
        if (opt.isEmpty()) {
            opt = userRepository.findByEmail(key.toLowerCase());
        }
        if (opt.isPresent()) {
            User user = opt.get();
            String stored = user.getPassword();
            boolean match = false;
            if (stored != null && (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$"))) {
                try {
                    match = BCrypt.checkpw(rawPassword, stored);
                } catch (Exception ignored) {
                    match = false;
                }
            } else {
                match = rawPassword.equals(stored);
            }
            if (match) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public long count() {
        return userRepository.count();
    }

    @Override
    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Page<User> search(String keyword, Pageable pageable) {
        return userRepository.findByUsernameContainingOrFullnameContainingOrEmailContaining(
                keyword, keyword, keyword, pageable);
    }
}
