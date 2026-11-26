<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Người dùng</title>
</head>
<body>
<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pb-3 mb-4 border-bottom">
    <div>
        <h3 class="fw-bold text-dark mb-1">
            <i class="bi bi-people-fill text-primary"></i> Quản lý Người dùng (User)
        </h3>
        <p class="text-muted mb-0">
            Tổng cộng <strong>${userPage.totalElements}</strong> tài khoản
            <c:if test="${not empty name}">
                — Kết quả tìm kiếm cho từ khóa: <span class="badge bg-primary-subtle text-primary"><c:out value="${name}"/></span>
            </c:if>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary fw-semibold shadow-sm">
        <i class="bi bi-person-plus-fill me-1"></i> Thêm người dùng mới
    </a>
</div>

<c:if test="${not empty message}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2 fs-5"></i>
        <div><c:out value="${message}"/></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
    </div>
</c:if>

<c:if test="${not empty alert}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
        <div><c:out value="${alert}"/></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
    </div>
</c:if>

<div class="card border-0 shadow-sm bg-white mb-4">
    <div class="card-body py-3">
        <div class="row g-3 align-items-center justify-content-between">
            <div class="col-lg-8">
                <form action="${pageContext.request.contextPath}/admin/users/searchpaginated" method="get" class="row g-2 align-items-center">
                    <input type="hidden" name="size" value="${userPage.size}">
                    <div class="col-sm">
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                            <input type="text" name="name" class="form-control"
                                   value="<c:out value='${name}'/>"
                                   placeholder="Tìm kiếm theo tài khoản, họ tên hoặc email...">
                        </div>
                    </div>
                    <div class="col-sm-auto d-flex gap-2">
                        <button type="submit" class="btn btn-primary fw-semibold">
                            <i class="bi bi-search me-1"></i> Tìm kiếm
                        </button>
                        <c:if test="${not empty name}">
                            <c:url var="clearSearchUrl" value="/admin/users/searchpaginated">
                                <c:param name="size" value="${userPage.size}"/>
                            </c:url>
                            <a href="${clearSearchUrl}" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-1"></i> Xóa lọc
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>

            <div class="col-lg-4 d-flex justify-content-lg-end">
                <form action="${pageContext.request.contextPath}/admin/users/searchpaginated" method="get" class="d-flex align-items-center gap-2">
                    <c:if test="${not empty name}">
                        <input type="hidden" name="name" value="<c:out value='${name}'/>">
                    </c:if>
                    <label for="pageSizeSelect" class="text-muted small text-nowrap mb-0">Hiển thị:</label>
                    <select name="size" id="pageSizeSelect" class="form-select form-select-sm w-auto" onchange="this.form.submit()">
                        <option value="3" ${userPage.size == 3 ? 'selected' : ''}>3 / trang</option>
                        <option value="5" ${userPage.size == 5 ? 'selected' : ''}>5 / trang</option>
                        <option value="10" ${userPage.size == 10 ? 'selected' : ''}>10 / trang</option>
                        <option value="15" ${userPage.size == 15 ? 'selected' : ''}>15 / trang</option>
                        <option value="20" ${userPage.size == 20 ? 'selected' : ''}>20 / trang</option>
                    </select>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm bg-white">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="text-center" style="width: 50px;">STT</th>
                        <th class="text-center" style="width: 65px;">Ảnh</th>
                        <th>Tài khoản &amp; Họ tên</th>
                        <th>Email &amp; SĐT</th>
                        <th class="text-center" style="width: 90px;">Vai trò</th>
                        <th class="text-center" style="width: 110px;">Trạng thái</th>
                        <th class="text-center" style="width: 145px;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty userPage.content}">
                            <c:forEach items="${userPage.content}" var="u" varStatus="st">
                                <c:set var="isCurrentAdmin" value="${sessionScope.account != null && sessionScope.account.id == u.id}"/>
                                <tr>
                                    <td class="text-center fw-semibold text-muted">
                                        ${userPage.number * userPage.size + st.index + 1}
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty u.images}">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(u.images, 'http://') or fn:startsWith(u.images, 'https://')}">
                                                        <c:set var="avatarUrl" value="${u.images}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="avatarUrl" value="${pageContext.request.contextPath}/uploads/${u.images}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <img src="<c:out value='${avatarUrl}'/>" alt="<c:out value='${u.username}'/>"
                                                     class="rounded-circle border shadow-sm object-fit-cover"
                                                     style="width: 46px; height: 46px;"
                                                     onerror="this.onerror=null; this.classList.add('d-none'); this.nextElementSibling.classList.remove('d-none'); this.nextElementSibling.classList.add('d-inline-flex');">
                                                <div class="rounded-circle bg-primary-subtle text-primary d-none align-items-center justify-content-center border"
                                                     style="width: 46px; height: 46px;">
                                                    <i class="bi bi-person-fill fs-5"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center border"
                                                     style="width: 46px; height: 46px;">
                                                    <i class="bi bi-person-fill fs-5"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">
                                            <c:out value="${u.fullname}"/>
                                            <c:if test="${isCurrentAdmin}">
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle ms-1">Đang đăng nhập</span>
                                            </c:if>
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-at"></i><c:out value="${u.username}"/>
                                            <span class="ms-2 text-secondary">#${u.id}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-dark">
                                            <i class="bi bi-envelope text-muted me-1"></i><c:out value="${u.email}"/>
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-telephone text-muted me-1"></i>
                                            <c:choose>
                                                <c:when test="${not empty u.phone}">
                                                    <c:out value="${u.phone}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="fst-italic">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.role == 'ADMIN'}">
                                                <span class="badge bg-warning text-dark px-2 py-1">
                                                    <i class="bi bi-shield-fill-check me-1"></i>ADMIN
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info text-dark px-2 py-1">
                                                    <i class="bi bi-person-fill me-1"></i>USER
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                    <i class="bi bi-check-circle-fill me-1"></i>Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                    <i class="bi bi-lock-fill me-1"></i>Đã khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit/${u.id}"
                                           class="btn btn-sm btn-outline-warning text-dark fw-semibold me-1"
                                           title="Chỉnh sửa người dùng">
                                            <i class="bi bi-pencil-square"></i> Sửa
                                        </a>
                                        <c:choose>
                                            <c:when test="${isCurrentAdmin}">
                                                <span class="d-inline-block" tabindex="0" data-bs-toggle="tooltip"
                                                      data-bs-placement="top"
                                                      title="Không thể tự xóa tài khoản Admin đang đăng nhập">
                                                    <button type="button" class="btn btn-sm btn-outline-secondary" disabled>
                                                        <i class="bi bi-trash"></i> Xóa
                                                    </button>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/admin/users/delete/${u.id}"
                                                   class="btn btn-sm btn-outline-danger fw-semibold"
                                                   title="Xóa người dùng"
                                                   data-username="<c:out value='${u.username}'/>"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản @' + this.dataset.username + ' không? Thao tác này không thể hoàn tác!');">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-people fs-1 d-block mb-2 opacity-50"></i>
                                    <div class="fw-semibold mb-2">Không tìm thấy người dùng nào phù hợp.</div>
                                    <c:if test="${not empty name}">
                                        <c:url var="resetUrl" value="/admin/users/searchpaginated">
                                            <c:param name="size" value="${userPage.size}"/>
                                        </c:url>
                                        <a href="${resetUrl}" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-arrow-counterclockwise me-1"></i> Xem toàn bộ danh sách
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${userPage.totalElements > 0}">
        <div class="card-footer bg-white py-3 border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div class="text-muted small">
                Trang <strong>${userPage.number + 1}</strong> / <strong>${userPage.totalPages}</strong>
                — Tổng <strong>${userPage.totalElements}</strong> người dùng
            </div>

            <c:if test="${userPage.totalPages > 1}">
                <nav aria-label="Phân trang danh sách người dùng">
                    <ul class="pagination pagination-sm mb-0">
                        <c:choose>
                            <c:when test="${userPage.number == 0}">
                                <li class="page-item disabled">
                                    <span class="page-link"><i class="bi bi-chevron-left"></i> Trước</span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:url var="prevUrl" value="/admin/users/searchpaginated">
                                    <c:param name="size" value="${userPage.size}"/>
                                    <c:param name="page" value="${userPage.number}"/>
                                    <c:if test="${not empty name}">
                                        <c:param name="name" value="${name}"/>
                                    </c:if>
                                </c:url>
                                <li class="page-item">
                                    <a class="page-link" href="${prevUrl}"><i class="bi bi-chevron-left"></i> Trước</a>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach items="${pageNumbers}" var="pageNumber">
                            <c:url var="pageUrl" value="/admin/users/searchpaginated">
                                <c:param name="size" value="${userPage.size}"/>
                                <c:param name="page" value="${pageNumber}"/>
                                <c:if test="${not empty name}">
                                    <c:param name="name" value="${name}"/>
                                </c:if>
                            </c:url>
                            <li class="page-item ${pageNumber == userPage.number + 1 ? 'active' : ''}">
                                <a class="page-link" href="${pageUrl}">${pageNumber}</a>
                            </li>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${userPage.number + 1 >= userPage.totalPages}">
                                <li class="page-item disabled">
                                    <span class="page-link">Sau <i class="bi bi-chevron-right"></i></span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:url var="nextUrl" value="/admin/users/searchpaginated">
                                    <c:param name="size" value="${userPage.size}"/>
                                    <c:param name="page" value="${userPage.number + 2}"/>
                                    <c:if test="${not empty name}">
                                        <c:param name="name" value="${name}"/>
                                    </c:if>
                                </c:url>
                                <li class="page-item">
                                    <a class="page-link" href="${nextUrl}">Sau <i class="bi bi-chevron-right"></i></a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </c:if>
        </div>
    </c:if>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.bootstrap && bootstrap.Tooltip) {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });
        }
    });
</script>
</body>
</html>
