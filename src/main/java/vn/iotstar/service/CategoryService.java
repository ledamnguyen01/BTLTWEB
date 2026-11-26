package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.Category;

public interface CategoryService {
    List<Category> findAll();
    Page<Category> findAll(Pageable pageable);
    Page<Category> findByNameContaining(String keyword, Pageable page);
    Optional<Category> findById(Long id);
    Category save(Category category);
    void deleteById(Long id);
    long count();
}
