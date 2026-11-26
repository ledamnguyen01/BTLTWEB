<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tổng quan Quản trị</title>
</head>
<body>
<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pb-3 mb-4 border-bottom">
    <div>
        <h3 class="fw-bold text-dark mb-1">
            <i class="bi bi-speedometer2 text-primary"></i> Bảng Điều Khiển Quản Trị
        </h3>
        <p class="text-muted mb-0">
            Xin chào <strong>${sessionScope.account.fullname}</strong> (@${sessionScope.account.username})
            — Vai trò: <span class="badge bg-warning text-dark">${sessionScope.account.role}</span>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm fw-semibold">
        <i class="bi bi-house-door"></i> Xem trang người dùng
    </a>
</div>

<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm bg-white h-100">
            <div class="card-body d-flex align-items-center gap-3 p-4">
                <div class="rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center flex-shrink-0" style="width: 56px; height: 56px;">
                    <i class="bi bi-folder2-open fs-3"></i>
                </div>
                <div class="min-w-0">
                    <div class="text-muted small fw-semibold text-uppercase">Tổng Danh mục</div>
                    <div class="fs-2 fw-bold text-dark">${totalCategories}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm bg-white h-100">
            <div class="card-body d-flex align-items-center gap-3 p-4">
                <div class="rounded-circle bg-info-subtle text-info d-flex align-items-center justify-content-center flex-shrink-0" style="width: 56px; height: 56px;">
                    <i class="bi bi-people-fill fs-3"></i>
                </div>
                <div class="min-w-0">
                    <div class="text-muted small fw-semibold text-uppercase">Tổng Người dùng</div>
                    <div class="fs-2 fw-bold text-dark">${totalUsers}</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm bg-white h-100">
            <div class="card-body d-flex align-items-center gap-3 p-4">
                <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center flex-shrink-0" style="width: 56px; height: 56px;">
                    <i class="bi bi-shield-lock-fill fs-3"></i>
                </div>
                <div class="min-w-0">
                    <div class="text-muted small fw-semibold text-uppercase">Trạng thái phiên</div>
                    <div class="fs-6 fw-bold text-success">Đã xác thực Admin</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm bg-white">
    <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
        <h5 class="mb-0 fw-bold"><i class="bi bi-clock-history text-primary me-2"></i> Danh mục mới cập nhật</h5>
        <span class="text-muted small">5 bản ghi gần nhất</span>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4" style="width: 90px;">Mã</th>
                        <th>Tên danh mục</th>
                        <th style="width: 180px;">Hình ảnh</th>
                        <th class="text-center" style="width: 150px;">Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentCategories}" var="cate">
                        <tr>
                            <td class="ps-4 fw-semibold">#${cate.id}</td>
                            <td class="fw-semibold text-dark">${cate.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cate.images}">
                                        <img src="${pageContext.request.contextPath}/uploads/${cate.images}"
                                             alt="${cate.name}"
                                             class="rounded-2 border shadow-sm"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <span class="badge ${cate.status == 1 ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                    ${cate.status == 1 ? 'Hoạt động' : 'Tạm ẩn'}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
