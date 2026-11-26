package vn.iotstar.controller;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.mindrot.jbcrypt.BCrypt;
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
import vn.iotstar.config.AuthInterceptor;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.FileUploadUtil;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0[0-9]{9}$");

    private final UserService userService;

    @Value("${app.upload.dir:D:/upload-springboot4}")
    private String uploadDir;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping({ "", "/", "/searchpaginated" })
    public String searchPaginated(ModelMap model,
                                  @RequestParam(name = "name", required = false) String name,
                                  @RequestParam("page") Optional<Integer> page,
                                  @RequestParam("size") Optional<Integer> size) {
        int currentPage = Math.max(1, page.orElse(1));
        int requestedSize = size.orElse(3);
        int pageSize = (requestedSize > 0 && requestedSize <= 50) ? requestedSize : 3;

        Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("username").ascending());
        Page<User> resultPage;

        if (StringUtils.hasText(name)) {
            String keyword = name.trim();
            resultPage = userService.search(keyword, pageable);
            model.addAttribute("name", keyword);
        } else {
            resultPage = userService.findAll(pageable);
        }

        int totalPages = resultPage.getTotalPages();
        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
            pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("username").ascending());
            resultPage = StringUtils.hasText(name)
                    ? userService.search(name.trim(), pageable)
                    : userService.findAll(pageable);
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

        model.addAttribute("userPage", resultPage);
        return "admin/user/list";
    }

    @GetMapping("/add")
    public String add(ModelMap model) {
        User userObj = new User();
        userObj.setRole("USER");
        userObj.setStatus(1);
        model.addAttribute("userObj", userObj);
        model.addAttribute("isEdit", false);
        return "admin/user/addOrEdit";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id,
                       ModelMap model,
                       RedirectAttributes redirectAttributes) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("alert", "Không tìm thấy người dùng có mã #" + id + "!");
            return "redirect:/admin/users/searchpaginated";
        }
        model.addAttribute("userObj", opt.get());
        model.addAttribute("isEdit", true);
        return "admin/user/addOrEdit";
    }

    @PostMapping("/save")
    public String save(@RequestParam(name = "id", required = false) Long id,
                       @RequestParam(name = "username", required = false) String username,
                       @RequestParam(name = "fullname", required = false) String fullname,
                       @RequestParam(name = "email", required = false) String email,
                       @RequestParam(name = "phone", required = false) String phone,
                       @RequestParam(name = "password", required = false) String password,
                       @RequestParam(name = "role", required = false) String role,
                       @RequestParam(name = "status", required = false) Integer status,
                       @RequestParam(name = "imageFile", required = false) MultipartFile imageFile,
                       HttpSession session,
                       ModelMap model,
                       RedirectAttributes redirectAttributes) {
        boolean isEdit = (id != null);
        User currentAccount = (User) session.getAttribute(AuthInterceptor.SESSION_ACCOUNT);

        User existing = null;
        if (isEdit) {
            Optional<User> opt = userService.findById(id);
            if (opt.isEmpty()) {
                redirectAttributes.addFlashAttribute("alert", "Không tìm thấy người dùng có mã #" + id + " để cập nhật!");
                return "redirect:/admin/users/searchpaginated";
            }
            existing = opt.get();
        }

        String cleanUsername = (username != null) ? username.trim() : "";
        String cleanFullname = (fullname != null) ? fullname.trim() : "";
        String cleanEmail = (email != null) ? email.trim().toLowerCase() : "";
        String cleanPhone = (phone != null) ? phone.trim() : "";
        String cleanRole = StringUtils.hasText(role) ? role.trim().toUpperCase() : "USER";
        Integer cleanStatus = status;

        User formUser = new User();
        formUser.setId(id);
        formUser.setUsername(cleanUsername);
        formUser.setFullname(cleanFullname);
        formUser.setEmail(cleanEmail);
        formUser.setPhone(cleanPhone);
        formUser.setRole(("ADMIN".equals(cleanRole) || "USER".equals(cleanRole)) ? cleanRole : "USER");
        formUser.setStatus((Integer.valueOf(0).equals(cleanStatus) || Integer.valueOf(1).equals(cleanStatus))
                ? cleanStatus
                : (existing != null ? existing.getStatus() : 1));
        if (existing != null) {
            formUser.setImages(existing.getImages());
        }

        if (!USERNAME_PATTERN.matcher(cleanUsername).matches()) {
            return validationError(model, formUser, isEdit,
                    "Tên đăng nhập phải từ 3 đến 30 ký tự (chỉ gồm chữ cái, số và dấu gạch dưới _).");
        }
        if (cleanFullname.length() < 2 || cleanFullname.length() > 100) {
            return validationError(model, formUser, isEdit,
                    "Họ và tên phải có độ dài từ 2 đến 100 ký tự!");
        }
        if (!EMAIL_PATTERN.matcher(cleanEmail).matches()) {
            return validationError(model, formUser, isEdit,
                    "Địa chỉ email không đúng định dạng!");
        }
        if (!PHONE_PATTERN.matcher(cleanPhone).matches()) {
            return validationError(model, formUser, isEdit,
                    "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0!");
        }
        if (!"ADMIN".equals(cleanRole) && !"USER".equals(cleanRole)) {
            return validationError(model, formUser, isEdit,
                    "Vai trò không hợp lệ! Chỉ chấp nhận ADMIN hoặc USER.");
        }
        if (cleanStatus == null || (cleanStatus != 0 && cleanStatus != 1)) {
            return validationError(model, formUser, isEdit,
                    "Trạng thái tài khoản không hợp lệ!");
        }

        if (!isEdit) {
            if (password == null || password.isBlank() || password.length() < 6) {
                return validationError(model, formUser, false,
                        "Mật khẩu bắt buộc nhập và phải có độ dài tối thiểu 6 ký tự!");
            }
            if (userService.existsByUsername(cleanUsername)) {
                return validationError(model, formUser, false,
                        "Tên đăng nhập '" + cleanUsername + "' đã tồn tại! Vui lòng chọn tên khác.");
            }
            if (userService.existsByEmail(cleanEmail)) {
                return validationError(model, formUser, false,
                        "Email '" + cleanEmail + "' đã được đăng ký bởi tài khoản khác!");
            }
            if (userService.existsByPhone(cleanPhone)) {
                return validationError(model, formUser, false,
                        "Số điện thoại '" + cleanPhone + "' đã được đăng ký bởi tài khoản khác!");
            }
        } else {
            if (password != null && !password.isEmpty() && (password.isBlank() || password.length() < 6)) {
                return validationError(model, formUser, true,
                        "Mật khẩu mới phải có độ dài tối thiểu 6 ký tự (hoặc để trống nếu không đổi)!");
            }
            if (currentAccount != null && existing.getId().equals(currentAccount.getId())) {
                if (Integer.valueOf(0).equals(cleanStatus)) {
                    return validationError(model, formUser, true,
                            "Không thể tự khóa tài khoản Admin đang đăng nhập!");
                }
                if (!"ADMIN".equals(cleanRole)) {
                    return validationError(model, formUser, true,
                            "Không thể tự hạ quyền tài khoản Admin đang đăng nhập!");
                }
            }
            if (userService.existsByUsernameAndIdNot(cleanUsername, id)) {
                return validationError(model, formUser, true,
                        "Tên đăng nhập '" + cleanUsername + "' đã tồn tại ở tài khoản khác!");
            }
            if (userService.existsByEmailAndIdNot(cleanEmail, id)) {
                return validationError(model, formUser, true,
                        "Email '" + cleanEmail + "' đã được sử dụng bởi tài khoản khác!");
            }
            if (userService.existsByPhoneAndIdNot(cleanPhone, id)) {
                return validationError(model, formUser, true,
                        "Số điện thoại '" + cleanPhone + "' đã được sử dụng bởi tài khoản khác!");
            }
        }

        if (!FileUploadUtil.isValidImage(imageFile)) {
            return validationError(model, formUser, isEdit,
                    "Ảnh đại diện không hợp lệ! Chỉ chấp nhận tệp JPG, JPEG, PNG, GIF hoặc WEBP.");
        }

        String savedFileName = null;
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                savedFileName = FileUploadUtil.saveImage(imageFile, uploadDir, "usr");
            } catch (IOException ex) {
                return validationError(model, formUser, isEdit,
                        "Lỗi khi lưu ảnh đại diện lên hệ thống. Vui lòng thử lại!");
            }
        }

        User entity = isEdit ? existing : new User();
        entity.setUsername(cleanUsername);
        entity.setFullname(cleanFullname);
        entity.setEmail(cleanEmail);
        entity.setPhone(cleanPhone);
        entity.setRole(cleanRole);
        entity.setStatus(cleanStatus);

        if (!isEdit) {
            entity.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(10)));
        } else if (password != null && !password.isEmpty()) {
            entity.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(10)));
        }

        if (savedFileName != null) {
            entity.setImages(savedFileName);
        }

        User saved = userService.save(entity);

        if (currentAccount != null && saved.getId().equals(currentAccount.getId())) {
            session.setAttribute(AuthInterceptor.SESSION_ACCOUNT, saved);
        }

        redirectAttributes.addFlashAttribute("message", isEdit
                ? "Cập nhật người dùng '" + saved.getUsername() + "' thành công!"
                : "Thêm mới người dùng '" + saved.getUsername() + "' thành công!");
        return "redirect:/admin/users/searchpaginated";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User currentAccount = (User) session.getAttribute(AuthInterceptor.SESSION_ACCOUNT);
        if (currentAccount != null && id.equals(currentAccount.getId())) {
            redirectAttributes.addFlashAttribute("alert", "Không thể tự xóa tài khoản Admin đang đăng nhập!");
            return "redirect:/admin/users/searchpaginated";
        }

        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("alert", "Không tìm thấy người dùng có mã #" + id + " để xóa!");
            return "redirect:/admin/users/searchpaginated";
        }

        String deletedUsername = opt.get().getUsername();
        userService.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Đã xóa người dùng '" + deletedUsername + "' thành công!");
        return "redirect:/admin/users/searchpaginated";
    }

    private String validationError(ModelMap model, User formUser, boolean isEdit, String alertMessage) {
        model.addAttribute("alert", alertMessage);
        model.addAttribute("userObj", formUser);
        model.addAttribute("isEdit", isEdit);
        return "admin/user/addOrEdit";
    }
}
