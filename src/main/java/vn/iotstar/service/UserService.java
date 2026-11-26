package vn.iotstar.service;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.User;

public interface UserService {
    Optional<User> findById(Long id);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);
    boolean existsByUsernameAndIdNot(String username, Long id);
    boolean existsByEmailAndIdNot(String email, Long id);
    boolean existsByPhoneAndIdNot(String phone, Long id);
    User register(String username, String rawPassword, String email, String fullname, String phone);
    Optional<User> authenticate(String usernameOrEmail, String rawPassword);
    User save(User user);
    void deleteById(Long id);
    long count();
    Page<User> findAll(Pageable pageable);
    Page<User> search(String keyword, Pageable pageable);
}
