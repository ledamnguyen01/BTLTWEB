-- Tạo database cho dự án Spring Boot 4 + JSP/JSTL + SQL Server
-- Lưu ý: Các bảng Users, Categories và dữ liệu mẫu sẽ tự động được Hibernate + DataInitializer khởi tạo khi chạy ứng dụng.

IF DB_ID(N'SpringBoot4_WebMVC') IS NULL
BEGIN
    CREATE DATABASE SpringBoot4_WebMVC;
END
GO

USE SpringBoot4_WebMVC;
GO
