# BÀI TẬP 05: SPRING BOOT 4 + JSP/JSTL + SITEMESH 3 + AUTH & ADMIN CRUD PHÂN TRANG

- **Họ và tên sinh viên:** Lê Đàm Nguyên
- **Mã số sinh viên (MSSV):** 24110040
- **Trường:** Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
- **Môn học:** Lập trình Web — Giảng viên: **ThS. Nguyễn Hữu Trung**

---

## 1. Công nghệ & Kiến trúc

- **Spring Boot 4.0.0** (Spring Framework 7, Jakarta EE 11, Java 21+)
- **Embedded Tomcat + Jasper** hỗ trợ **JSP/JSTL** đóng gói JAR thông qua `JSPStaticResourceConfigurer` & `TomcatJSPConfiguration`
- **SiteMesh 3** (`CustomSiteMeshFilter` + `FilterRegistrationBean`) quản lý layout chung (`web.jsp`, `admin.jsp`)
- **Unicode UTF-8** qua `CharacterEncodingFilter` (`Ordered.HIGHEST_PRECEDENCE`)
- **Spring Data JPA + SQL Server** (`SpringBoot4_WebMVC`), mã hóa mật khẩu bằng **jBCrypt**
- **Bootstrap 5.3.3** & **Bootstrap Icons**

---

## 2. Chức năng đã hoàn thành (Mốc 1)

1. **Cấu hình lõi Spring Boot 4 + JSP + SiteMesh 3** chạy trên cổng `8090`, ViewResolver `/WEB-INF/views/` + `.jsp`.
2. **Đăng ký tài khoản (`/register`):** Validation 2 lớp (Client Bootstrap 5 + Server-side), kiểm tra trùng `username` / `email` / `phone`, băm mật khẩu BCrypt.
3. **Đăng nhập (`/login`):** Hỗ trợ đăng nhập bằng `username` hoặc `email`, Remember Me cookie (7 ngày), tự động điều hướng theo vai trò (`ADMIN` → `/admin/home`, `USER` → `/home`).
4. **Đăng xuất (`/logout`):** Xóa Session và Remember Me cookie.
5. **Phân quyền (`AuthInterceptor`):** Chặn truy cập trái phép vào `/admin/**` (chưa đăng nhập → `/login`, không phải Admin → `/home`).
6. **Tài khoản mẫu tự động khởi tạo (`DataInitializer`):**
   - Admin: `admin` / `123456`
   - User: `user` / `123456`

---

## 3. Hướng dẫn chạy dự án

1. Mở SQL Server Management Studio và chạy file `database.sql` để tạo database `SpringBoot4_WebMVC` (các bảng và dữ liệu mẫu sẽ tự khởi tạo khi chạy ứng dụng).
2. Chạy ứng dụng:
   ```bash
   mvn spring-boot:run
   ```
3. Mở trình duyệt truy cập: `http://localhost:8090/home`
