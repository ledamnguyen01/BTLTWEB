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
- **Unicode UTF-8** qua `CharacterEncodingFilter` (`Ordered.HIGHEST_PRECEDENCE`) + `InternalResourceViewResolver`
- **Spring Data JPA + SQL Server** (`SpringBoot4_WebMVC`), mã hóa mật khẩu **jBCrypt**, ký cookie Remember Me bằng **HMAC-SHA256**
- **Bootstrap 5.3.3** & **Bootstrap Icons**

---

## 2. Chức năng đã hoàn thành

### Phần 1 — Cấu hình lõi & Xác thực tài khoản
1. **Cấu hình lõi Spring Boot 4 + JSP + SiteMesh 3** chạy trên cổng `8090`, ViewResolver `/WEB-INF/views/` + `.jsp`.
2. **Đăng ký (`/register`):** Validation 2 lớp (Bootstrap 5 + Server-side), chống trùng `username` / `email` / `phone`, băm mật khẩu BCrypt.
3. **Đăng nhập (`/login`):** Hỗ trợ đăng nhập bằng `username` hoặc `email`, Remember Me cookie ký HMAC-SHA256 (7 ngày), tự động điều hướng theo vai trò (`ADMIN` → `/admin/home`, `USER` → `/home`).
4. **Đăng xuất (`/logout`):** Xóa Session và Remember Me cookie.
5. **Phân quyền (`AuthInterceptor`):** Bảo vệ toàn bộ `/admin/**`.

### Phần 2 — Admin CRUD, Tìm kiếm & Phân trang (`Category` & `User`)
6. **Quản lý Danh mục (`/admin/categories/searchpaginated`):**
   - `CategoryRepository.findByNameContaining(String keyword, Pageable page)` → `CategoryService` → `AdminCategoryController`.
   - Thêm mới (`/add`), Sửa (`/edit/{id}`), Xóa (`/delete/{id}`), upload ảnh Multipart (`/uploads/**`), tìm kiếm theo tên, phân trang + chọn kích thước trang (`3 / 5 / 10 / 15 / 20`).
7. **Quản lý Người dùng (`/admin/users/searchpaginated`):**
   - Tìm kiếm theo `username` / `fullname` / `email`, phân trang + chọn kích thước trang (`3 / 5 / 10 / 15 / 20`).
   - Thêm mới, Sửa (giữ mật khẩu cũ nếu để trống, băm BCrypt nếu đổi mới), phân quyền `ADMIN`/`USER`, khóa/mở tài khoản, upload ảnh đại diện Multipart, chặn Admin tự xóa hoặc tự khóa chính mình.

---

## 3. Tài khoản mặc định & Hướng dẫn chạy

- **Tài khoản mẫu tự động khởi tạo (`DataInitializer`):**
  - Admin: `admin` / `123456`
  - User: `user` / `123456`
- **Các bước chạy:**
  1. Mở SQL Server Management Studio và chạy file `database.sql` để tạo database `SpringBoot4_WebMVC`.
  2. Chạy ứng dụng:
     ```bash
     mvn spring-boot:run
     ```
  3. Mở trình duyệt truy cập `http://localhost:8090/home`.
