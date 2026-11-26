<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - Spring Boot 4 MVC</title>
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
            max-width: 500px;
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
            <div class="card-header bg-success text-white text-center py-3">
                <h4 class="mb-0 fw-bold"><i class="bi bi-person-plus-fill"></i> ĐĂNG KÝ TÀI KHOẢN</h4>
            </div>
            <div class="card-body p-4 bg-white">
                <c:if test="${alert != null}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>${alert}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên đăng nhập (Username): <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" name="username" class="form-control" placeholder="Từ 3-30 ký tự, không dấu"
                                   value="${usernameVal}" required minlength="3" maxlength="30" pattern="^[a-zA-Z0-9_]{3,30}$" autofocus>
                            <div class="invalid-feedback">Tên đăng nhập từ 3–30 ký tự (chữ cái, số, dấu gạch dưới)!</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Họ và tên đầy đủ: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                            <input type="text" name="fullname" class="form-control" placeholder="Ví dụ: Lê Đàm Nguyên"
                                   value="${fullnameVal}" required minlength="2" maxlength="100">
                            <div class="invalid-feedback">Vui lòng nhập họ và tên (từ 2 đến 100 ký tự)!</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Địa chỉ Email: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="Ví dụ: sinhvien@hcmute.edu.vn"
                                   value="${emailVal}" required>
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ!</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                            <input type="tel" name="phone" class="form-control" placeholder="Ví dụ: 0912345678"
                                   value="${phoneVal}" required pattern="^0[0-9]{9}$">
                            <div class="invalid-feedback">Vui lòng nhập đúng 10 chữ số bắt đầu bằng số 0!</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mật khẩu: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-key"></i></span>
                            <input type="password" name="password" id="regPassword" class="form-control"
                                   placeholder="Tối thiểu 6 ký tự" required minlength="6">
                            <div class="invalid-feedback">Mật khẩu phải có độ dài tối thiểu 6 ký tự!</div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Xác nhận mật khẩu: <span class="text-danger">*</span></label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                            <input type="password" name="confirmPassword" id="regConfirmPassword" class="form-control"
                                   placeholder="Nhập lại mật khẩu" required minlength="6" data-match="regPassword">
                            <div class="invalid-feedback">Mật khẩu xác nhận phải trùng khớp và tối thiểu 6 ký tự!</div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold">
                        <i class="bi bi-check-circle-fill"></i> ĐĂNG KÝ TÀI KHOẢN
                    </button>
                </form>

                <div class="text-center mt-3 pt-3 border-top">
                    <span>Đã có tài khoản? </span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-bold text-decoration-none">Đăng nhập ngay</a>
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
            function syncMatch(input) {
                var target = document.getElementById(input.getAttribute('data-match'));
                if (!target) return;
                if (input.value && input.value !== target.value) {
                    input.setCustomValidity('Mật khẩu xác nhận không trùng khớp!');
                } else {
                    input.setCustomValidity('');
                }
            }
            var matchInputs = document.querySelectorAll('[data-match]');
            Array.prototype.slice.call(matchInputs).forEach(function (input) {
                var target = document.getElementById(input.getAttribute('data-match'));
                input.addEventListener('input', function () { syncMatch(input); });
                if (target) target.addEventListener('input', function () { syncMatch(input); });
            });
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    Array.prototype.slice.call(form.querySelectorAll('[data-match]')).forEach(syncMatch);
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
