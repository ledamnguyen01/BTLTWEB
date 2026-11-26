<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Spring Boot 4 MVC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        }
        main {
            flex: 1 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .auth-card {
            max-width: 440px;
            width: 100%;
            border: none;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <header class="py-3 text-center">
        <a href="${pageContext.request.contextPath}/home" class="text-white text-decoration-none fs-4 fw-bold">
            <i class="bi bi-layers-fill text-warning"></i> SpringBoot4 MVC
        </a>
    </header>

    <main>
        <div class="card auth-card">
            <div class="card-header bg-primary text-white text-center py-3">
                <h4 class="mb-0 fw-bold"><i class="bi bi-shield-lock"></i> ĐĂNG NHẬP HỆ THỐNG</h4>
            </div>
            <div class="card-body p-4 bg-white">
                <c:if test="${alert != null}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>${alert}</div>
                    </div>
                </c:if>

                <c:if test="${message != null}">
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div>${message}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên đăng nhập hoặc Email: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                            <input type="text" name="username" class="form-control" placeholder="Nhập username hoặc email"
                                   value="${usernameVal}" required autofocus>
                            <div class="invalid-feedback">Vui lòng nhập tên đăng nhập hoặc email!</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mật khẩu: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                            <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <input type="checkbox" name="remember" class="form-check-input" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập (7 ngày)</label>
                        </div>
                        <a href="${pageContext.request.contextPath}/home" class="small text-decoration-none text-muted">
                            <i class="bi bi-house"></i> Trang chủ
                        </a>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">
                        <i class="bi bi-box-arrow-in-right"></i> ĐĂNG NHẬP
                    </button>
                </form>

                <div class="alert alert-light border mt-3 mb-0 py-2 px-3 small text-muted">
                    <strong>Tài khoản demo:</strong> <code>admin</code> / <code>123456</code> (Admin) &bull; <code>user</code> / <code>123456</code> (User)
                </div>

                <div class="text-center mt-3 pt-3 border-top">
                    <span>Chưa có tài khoản? </span>
                    <a href="${pageContext.request.contextPath}/register" class="fw-bold text-decoration-none">Đăng ký ngay</a>
                </div>
            </div>
        </div>
    </main>

    <footer class="text-white-50 text-center py-3 small">
        &copy; 2026 Lê Đàm Nguyên (24110040) — Lập trình Web ThS. Nguyễn Hữu Trung — HCMUTE
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
