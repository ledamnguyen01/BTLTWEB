package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService;
import vn.iotstar.util.FileUploadUtil;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    private final CategoryService categoryService;

    @Value("${app.upload.dir:D:/upload-springboot4}")
    private String uploadDir;

    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping({ "", "/", "/searchpaginated" })
    public String searchPaginated(
            ModelMap model,
            @RequestParam(name = "name", required = false) String name,
            @RequestParam("page") Optional<Integer> page,
            @RequestParam("size") Optional<Integer> size) {

        int currentPage = Math.max(1, page.orElse(1));
        int requestedSize = size.orElse(3);
        int pageSize = (requestedSize > 0 && requestedSize <= 50) ? requestedSize : 3;

        Sort sort = Sort.by("name").ascending();
        Pageable pageable = PageRequest.of(currentPage - 1, pageSize, sort);

        boolean hasKeyword = StringUtils.hasText(name);
        String trimmedName = hasKeyword ? name.trim() : null;

        Page<Category> resultPage;
        if (hasKeyword) {
            resultPage = categoryService.findByNameContaining(trimmedName, pageable);
            model.addAttribute("name", trimmedName);
        } else {
            resultPage = categoryService.findAll(pageable);
        }

        int totalPages = resultPage.getTotalPages();
        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
            Pageable lastPageable = PageRequest.of(currentPage - 1, pageSize, sort);
            resultPage = hasKeyword
                    ? categoryService.findByNameContaining(trimmedName, lastPageable)
                    : categoryService.findAll(lastPageable);
            totalPages = resultPage.getTotalPages();
        }

        if (totalPages > 0) {
            int start = Math.max(1, currentPage - 2);
            int end = Math.min(currentPage + 2, totalPages);
            List<Integer> pageNumbers = IntStream.rangeClosed(start, end)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }

        model.addAttribute("categoryPage", resultPage);
        return "admin/category/list";
    }

    @GetMapping("/add")
    public String add(ModelMap model) {
        Category category = new Category();
        category.setStatus(1);
        model.addAttribute("category", category);
        model.addAttribute("isEdit", false);
        return "admin/category/addOrEdit";
    }

    @GetMapping("/edit/{id}")
    public String edit(
            @PathVariable("id") Long id,
            ModelMap model,
            RedirectAttributes redirectAttributes) {

        Optional<Category> optCategory = categoryService.findById(id);
        if (optCategory.isEmpty()) {
            redirectAttributes.addFlashAttribute("alert", "Không tìm thấy danh mục có mã #" + id + "!");
            return "redirect:/admin/categories/searchpaginated";
        }

        model.addAttribute("category", optCategory.get());
        model.addAttribute("isEdit", true);
        return "admin/category/addOrEdit";
    }

    @PostMapping("/save")
    public String save(
            @RequestParam(name = "id", required = false) Long id,
            @RequestParam(name = "name", required = false) String name,
            @RequestParam(name = "status", required = false) Integer status,
            @RequestParam(name = "imageFile", required = false) MultipartFile imageFile,
            ModelMap model,
            RedirectAttributes redirectAttributes) {

        boolean isEdit = (id != null);
        Category existing = null;

        if (isEdit) {
            Optional<Category> optExisting = categoryService.findById(id);
            if (optExisting.isEmpty()) {
                redirectAttributes.addFlashAttribute("alert", "Không tìm thấy danh mục cần cập nhật (mã #" + id + ")!");
                return "redirect:/admin/categories/searchpaginated";
            }
            existing = optExisting.get();
        }

        String trimmedName = (name != null) ? name.trim() : "";

        Category formCategory = new Category();
        formCategory.setId(id);
        formCategory.setName(trimmedName);
        formCategory.setStatus(status);
        if (existing != null) {
            formCategory.setImages(existing.getImages());
        }

        if (!StringUtils.hasText(trimmedName) || trimmedName.length() < 2 || trimmedName.length() > 200) {
            model.addAttribute("alert", "Tên danh mục không hợp lệ (bắt buộc từ 2 đến 200 ký tự).");
            model.addAttribute("category", formCategory);
            model.addAttribute("isEdit", isEdit);
            return "admin/category/addOrEdit";
        }

        if (status == null || (status != 0 && status != 1)) {
            model.addAttribute("alert", "Trạng thái danh mục không hợp lệ (chỉ chấp nhận Hoạt động hoặc Tạm ẩn).");
            model.addAttribute("category", formCategory);
            model.addAttribute("isEdit", isEdit);
            return "admin/category/addOrEdit";
        }

        if (!FileUploadUtil.isValidImage(imageFile)) {
            model.addAttribute("alert", "Tệp hình ảnh không hợp lệ! Chỉ chấp nhận định dạng JPG, JPEG, PNG, GIF hoặc WEBP.");
            model.addAttribute("category", formCategory);
            model.addAttribute("isEdit", isEdit);
            return "admin/category/addOrEdit";
        }

        Category categoryToSave = isEdit ? existing : new Category();
        categoryToSave.setName(trimmedName);
        categoryToSave.setStatus(status);

        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String savedFileName = FileUploadUtil.saveImage(imageFile, uploadDir, "cat");
                categoryToSave.setImages(savedFileName);
            } catch (IOException e) {
                model.addAttribute("alert", "Không thể lưu tệp hình ảnh: " + e.getMessage());
                model.addAttribute("category", formCategory);
                model.addAttribute("isEdit", isEdit);
                return "admin/category/addOrEdit";
            }
        }

        categoryService.save(categoryToSave);
        redirectAttributes.addFlashAttribute("message",
                isEdit ? "Cập nhật danh mục thành công!" : "Thêm danh mục mới thành công!");
        return "redirect:/admin/categories/searchpaginated";
    }

    @GetMapping("/delete/{id}")
    public String delete(
            @PathVariable("id") Long id,
            RedirectAttributes redirectAttributes) {

        Optional<Category> optCategory = categoryService.findById(id);
        if (optCategory.isEmpty()) {
            redirectAttributes.addFlashAttribute("alert", "Không tìm thấy danh mục cần xóa (mã #" + id + ")!");
            return "redirect:/admin/categories/searchpaginated";
        }

        String deletedName = optCategory.get().getName();
        categoryService.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Đã xóa danh mục \"" + deletedName + "\" thành công!");
        return "redirect:/admin/categories/searchpaginated";
    }
}
