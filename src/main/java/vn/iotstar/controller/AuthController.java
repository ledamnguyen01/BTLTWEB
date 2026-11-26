package vn.iotstar.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Optional;
import java.util.regex.Pattern;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.iotstar.config.AuthInterceptor;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.RememberMeUtil;

@Controller
public class AuthController {

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0[0-9]{9}$");

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String loginForm(HttpSession session,
                            @RequestParam(name = "error", required = false) String error,
                            @RequestParam(name = "logout", required = false) String logout,
                            @RequestParam(name = "registered", required = false) String registered,
                            Model model) {
        User account = (User) session.getAttribute(AuthInterceptor.SESSION_ACCOUNT);
        if (account != null) {
            return account.isAdmin() ? "redirect:/admin/home" : "redirect:/home";
        }
        if ("required".equals(error)) {
            model.addAttribute("alert", "Vui lòng đăng nhập để tiếp tục truy cập!");
        } else if ("locked".equals(error)) {
            model.addAttribute("alert", "Tài khoản của bạn hiện đang bị khóa. Vui lòng liên hệ Quản trị viên!");
        }
        if ("true".equals(logout)) {
            model.addAttribute("message", "Bạn đã đăng xuất khỏi hệ thống thành công!");
        }
        if ("true".equals(registered) && !model.containsAttribute("message")) {
            model.addAttribute("message", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam(name = "username", required = false) String username,
                               @RequestParam(name = "password", required = false) String password,
                               @RequestParam(name = "remember", required = false) String remember,
                               HttpServletRequest request,
                               HttpServletResponse response,
                               Model model) {
        model.addAttribute("usernameVal", username);

        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            model.addAttribute("alert", "Tên đăng nhập và mật khẩu không được để trống!");
            return "auth/login";
        }

        Optional<User> opt = userService.authenticate(username, password);
        if (opt.isEmpty()) {
            model.addAttribute("alert", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            return "auth/login";
        }

        User user = opt.get();
        if (!Integer.valueOf(1).equals(user.getStatus())) {
            model.addAttribute("alert", "Tài khoản của bạn đang bị khóa! Không thể đăng nhập.");
            return "auth/login";
        }

        HttpSession session = request.getSession(true);
        session.setAttribute(AuthInterceptor.SESSION_ACCOUNT, user);

        if ("on".equalsIgnoreCase(remember) || "true".equalsIgnoreCase(remember)) {
            Cookie cookie = new Cookie(AuthInterceptor.COOKIE_REMEMBER, RememberMeUtil.createToken(user.getUsername()));
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            response.addCookie(cookie);
        }

        return user.isAdmin() ? "redirect:/admin/home" : "redirect:/home";
    }

    @GetMapping("/register")
    public String registerForm(HttpSession session) {
        User account = (User) session.getAttribute(AuthInterceptor.SESSION_ACCOUNT);
        if (account != null) {
            return account.isAdmin() ? "redirect:/admin/home" : "redirect:/home";
        }
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@RequestParam(name = "username", required = false) String username,
                                  @RequestParam(name = "fullname", required = false) String fullname,
                                  @RequestParam(name = "email", required = false) String email,
                                  @RequestParam(name = "phone", required = false) String phone,
                                  @RequestParam(name = "password", required = false) String password,
                                  @RequestParam(name = "confirmPassword", required = false) String confirmPassword,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        model.addAttribute("usernameVal", username);
        model.addAttribute("fullnameVal", fullname);
        model.addAttribute("emailVal", email);
        model.addAttribute("phoneVal", phone);

        if (username == null || !USERNAME_PATTERN.matcher(username.trim()).matches()) {
            model.addAttribute("alert", "Tên đăng nhập phải từ 3 đến 30 ký tự (chỉ gồm chữ cái, số và dấu gạch dưới _).");
            return "auth/register";
        }
        if (fullname == null || fullname.trim().length() < 2 || fullname.trim().length() > 100) {
            model.addAttribute("alert", "Họ và tên phải từ 2 đến 100 ký tự!");
            return "auth/register";
        }
        if (email == null || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            model.addAttribute("alert", "Địa chỉ email không đúng định dạng!");
            return "auth/register";
        }
        if (phone == null || !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            model.addAttribute("alert", "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0!");
            return "auth/register";
        }
        if (password == null || password.length() < 6) {
            model.addAttribute("alert", "Mật khẩu phải có độ dài tối thiểu 6 ký tự!");
            return "auth/register";
        }
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            model.addAttribute("alert", "Mật khẩu xác nhận không trùng khớp!");
            return "auth/register";
        }

        String trimmedUser = username.trim();
        String trimmedEmail = email.trim().toLowerCase();
        String trimmedPhone = phone.trim();

        if (userService.existsByUsername(trimmedUser)) {
            model.addAttribute("alert", "Tên đăng nhập '" + trimmedUser + "' đã tồn tại! Vui lòng chọn tên khác.");
            return "auth/register";
        }
        if (userService.existsByEmail(trimmedEmail)) {
            model.addAttribute("alert", "Email '" + trimmedEmail + "' đã được đăng ký bởi tài khoản khác!");
            return "auth/register";
        }
        if (userService.existsByPhone(trimmedPhone)) {
            model.addAttribute("alert", "Số điện thoại '" + trimmedPhone + "' đã được đăng ký bởi tài khoản khác!");
            return "auth/register";
        }

        userService.register(trimmedUser, password, trimmedEmail, fullname, trimmedPhone);
        redirectAttributes.addFlashAttribute("message", "Đăng ký tài khoản '" + trimmedUser + "' thành công! Bạn có thể đăng nhập ngay.");
        return "redirect:/login?registered=true";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(AuthInterceptor.SESSION_ACCOUNT);
            session.invalidate();
        }
        Cookie cookie = new Cookie(AuthInterceptor.COOKIE_REMEMBER, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
        return "redirect:/login?logout=true";
    }
}
