<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
</head>
<body>
<div class="container">
    <c:if test="${alert != null}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
            <div>${alert}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${message != null}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i>
            <div>${message}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Hero Banner -->
    <div class="card border-0 shadow-sm mb-4 bg-white">
        <div class="card-body p-4 p-lg-5">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 mb-3">
                        <i class="bi bi-stars"></i> Spring Boot 4.0 &bull; JSP/JSTL &bull; SiteMesh 3 &bull; SQL Server
                    </span>
                    <h2 class="fw-bold text-dark mb-2">
                        Hệ thống Quản lý Danh mục &amp; Người dùng
                    </h2>
                    <p class="text-muted mb-4">
                        Bài tập Lập trình Web — Giảng viên: <strong>ThS. Nguyễn Hữu Trung</strong> (HCMUTE).
                        Hỗ trợ Đăng ký, Đăng nhập (BCrypt + Remember Me), Đăng xuất, phân quyền Session Interceptor và quản trị Admin.
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <c:choose>
                            <c:when test="${sessionScope.account == null}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary px-4 fw-semibold">
                                    <i class="bi bi-box-arrow-in-right"></i> Đăng nhập ngay
                                </a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-success px-4 fw-semibold">
                                    <i class="bi bi-person-plus"></i> Tạo tài khoản mới
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${sessionScope.account.admin}">
                                    <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-warning px-4 fw-bold text-dark">
                                        <i class="bi bi-speedometer2"></i> Vào trang Quản trị Admin
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger px-4 fw-semibold">
                                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-3 rounded-3 bg-light border">
                        <h6 class="fw-bold text-secondary mb-3"><i class="bi bi-bar-chart-fill text-primary"></i> Thống kê nhanh</h6>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted"><i class="bi bi-folder2-open text-success"></i> Tổng danh mục</span>
                            <span class="badge bg-success fs-6">${totalCategories}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted"><i class="bi bi-people-fill text-info"></i> Tổng người dùng</span>
                            <span class="badge bg-info text-dark fs-6">${totalUsers}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2">
                            <span class="text-muted"><i class="bi bi-shield-lock text-warning"></i> Trạng thái phiên</span>
                            <span class="badge ${sessionScope.account != null ? 'bg-primary' : 'bg-secondary'}">
                                ${sessionScope.account != null ? sessionScope.account.role : 'Khách'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Thông tin tài khoản đang đăng nhập -->
    <c:if test="${sessionScope.account != null}">
        <div class="card border-0 shadow-sm mb-4 bg-white">
            <div class="card-body p-3">
                <div class="row g-2 align-items-center small">
                    <div class="col-md-3"><strong><i class="bi bi-person-badge text-primary"></i> Tài khoản:</strong> @${sessionScope.account.username}</div>
                    <div class="col-md-3"><strong><i class="bi bi-card-text text-success"></i> Họ tên:</strong> ${sessionScope.account.fullname}</div>
                    <div class="col-md-3"><strong><i class="bi bi-envelope text-info"></i> Email:</strong> ${sessionScope.account.email}</div>
                    <div class="col-md-3"><strong><i class="bi bi-shield-check text-warning"></i> Quyền hạn:</strong> ${sessionScope.account.role}</div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Danh mục nổi bật -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold text-dark mb-0">
            <i class="bi bi-grid-fill text-primary"></i> Danh mục nổi bật
        </h4>
        <span class="text-muted small">Hiển thị từ SQL Server (Spring Data JPA)</span>
    </div>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3 mb-4">
        <c:forEach items="${categories}" var="cate">
            <div class="col">
                <div class="card h-100 border-0 shadow-sm hover-lift bg-white">
                    <div class="card-body p-3 d-flex flex-column justify-content-between">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="rounded-3 bg-primary-subtle text-primary d-flex align-items-center justify-content-center flex-shrink-0"
                                 style="width: 48px; height: 48px;">
                                <i class="bi bi-tag-fill fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1" style="line-height: 1.35;" title="${cate.name}">${cate.name}</h6>
                                <span class="badge ${cate.status == 1 ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                    ${cate.status == 1 ? 'Đang hoạt động' : 'Tạm ẩn'}
                                </span>
                            </div>
                        </div>
                        <div class="text-muted small border-top pt-2 mt-1">
                            Mã danh mục: <code>#${cate.id}</code>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
