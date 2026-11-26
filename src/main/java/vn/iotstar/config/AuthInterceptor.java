package vn.iotstar.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Optional;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    public static final String SESSION_ACCOUNT = "account";
    public static final String COOKIE_REMEMBER = "SB4_REMEMBER_USER";

    private final UserService userService;

    public AuthInterceptor(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute(SESSION_ACCOUNT) : null;

        // Tự động khôi phục phiên từ Remember Me cookie nếu chưa có session
        if (account == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if (COOKIE_REMEMBER.equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                        Optional<User> opt = userService.findByUsername(c.getValue().trim());
                        if (opt.isPresent() && Integer.valueOf(1).equals(opt.get().getStatus())) {
                            account = opt.get();
                            request.getSession(true).setAttribute(SESSION_ACCOUNT, account);
                        }
                        break;
                    }
                }
            }
        }

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String path = uri.substring(ctx.length());

        // Bảo vệ toàn bộ tuyến đường /admin/**
        if (path.equals("/admin") || path.startsWith("/admin/")) {
            if (account == null) {
                response.sendRedirect(ctx + "/login?error=required");
                return false;
            }
            if (!Integer.valueOf(1).equals(account.getStatus())) {
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(ctx + "/login?error=locked");
                return false;
            }
            if (!account.isAdmin()) {
                response.sendRedirect(ctx + "/home?error=forbidden");
                return false;
            }
        }

        return true;
    }
}
