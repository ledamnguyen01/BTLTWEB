<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh mục</title>
    <style>
        .category-thumb {
            width: 52px;
            height: 52px;
            object-fit: cover;
            border-radius: 0.5rem;
        }
        .category-thumb-placeholder {
            width: 52px;
            height: 52px;
            border-radius: 0.5rem;
            background-color: #f8f9fa;
            color: #adb5bd;
        }
    </style>
</head>
<body>
<div class="card border-0 shadow-sm bg-white">
    <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div class="d-flex align-items-center gap-2">
            <h5 class="mb-0 fw-bold text-dark">
                <i class="bi bi-folder2-open text-success me-2"></i>Quản lý Danh mục
            </h5>
            <span class="badge bg-primary-subtle text-primary rounded-pill">
                ${categoryPage.totalElements} danh mục
            </span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-primary btn-sm fw-semibold px-3 py-2 text-nowrap">
            <i class="bi bi-plus-circle me-1"></i> Thêm mới
        </a>
    </div>

    <div class="card-body p-4">
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                <div><c:out value="${message}"/></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <c:if test="${not empty alert}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                <div><c:out value="${alert}"/></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <div class="row g-3 align-items-center justify-content-between mb-4">
            <div class="col-12 col-md-7 col-lg-6">
                <form action="${pageContext.request.contextPath}/admin/categories/searchpaginated" method="get" class="d-flex gap-2">
                    <input type="hidden" name="size" value="${categoryPage.size}">
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               name="name"
                               value="<c:out value='${name}'/>"
                               class="form-control"
                               placeholder="Nhập tên danh mục cần tìm...">
                        <button type="submit" class="btn btn-primary fw-semibold">
                            Tìm kiếm
                        </button>
                    </div>
                    <c:if test="${not empty name}">
                        <c:url var="clearSearchUrl" value="/admin/categories/searchpaginated">
                            <c:param name="size" value="${categoryPage.size}"/>
                        </c:url>
                        <a href="${clearSearchUrl}" class="btn btn-outline-secondary text-nowrap" title="Xóa từ khóa tìm kiếm">
                            <i class="bi bi-x-lg"></i> Xóa lọc
                        </a>
                    </c:if>
                </form>
            </div>

            <div class="col-12 col-md-auto">
                <form action="${pageContext.request.contextPath}/admin/categories/searchpaginated" method="get" class="d-flex align-items-center justify-content-md-end gap-2">
                    <input type="hidden" name="name" value="<c:out value='${name}'/>">
                    <label for="pageSizeSelect" class="form-label mb-0 text-muted small text-nowrap">Hiển thị:</label>
                    <select id="pageSizeSelect" name="size" class="form-select form-select-sm w-auto" onchange="this.form.submit()">
                        <option value="3" ${categoryPage.size == 3 ? 'selected' : ''}>3 / trang</option>
                        <option value="5" ${categoryPage.size == 5 ? 'selected' : ''}>5 / trang</option>
                        <option value="10" ${categoryPage.size == 10 ? 'selected' : ''}>10 / trang</option>
                        <option value="15" ${categoryPage.size == 15 ? 'selected' : ''}>15 / trang</option>
                        <option value="20" ${categoryPage.size == 20 ? 'selected' : ''}>20 / trang</option>
                    </select>
                </form>
            </div>
        </div>

        <c:choose>
            <c:when test="${categoryPage.hasContent()}">
                <div class="table-responsive border rounded">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 70px;">STT</th>
                                <th class="text-center" style="width: 100px;">Hình ảnh</th>
                                <th>Tên danh mục</th>
                                <th class="text-center" style="width: 150px;">Trạng thái</th>
                                <th class="text-center" style="width: 180px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${categoryPage.content}" var="cate" varStatus="STT">
                                <tr>
                                    <td class="text-center fw-semibold text-muted">
                                        ${categoryPage.number * categoryPage.size + STT.index + 1}
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty cate.images}">
                                                <img src="${pageContext.request.contextPath}/uploads/${cate.images}"
                                                     alt="<c:out value='${cate.name}'/>"
                                                     class="category-thumb border shadow-sm"
                                                     onerror="this.classList.add('d-none'); this.nextElementSibling.classList.remove('d-none'); this.nextElementSibling.classList.add('d-inline-flex');">
                                                <div class="category-thumb-placeholder border d-none align-items-center justify-content-center" title="Chưa có ảnh">
                                                    <i class="bi bi-image fs-4"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="category-thumb-placeholder border d-inline-flex align-items-center justify-content-center" title="Chưa có ảnh">
                                                    <i class="bi bi-image fs-4"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-dark"><c:out value="${cate.name}"/></div>
                                        <small class="text-muted">Mã: #${cate.id}</small>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${cate.status == 1}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                    <i class="bi bi-check-circle-fill me-1"></i>Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1">
                                                    <i class="bi bi-pause-circle-fill me-1"></i>Tạm ẩn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-inline-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/admin/categories/edit/${cate.id}"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil-square me-1"></i>Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/categories/delete/${cate.id}"
                                               class="btn btn-sm btn-outline-danger"
                                               data-name="<c:out value='${cate.name}'/>"
                                               onclick="return confirmDeleteCategory(this);">
                                                <i class="bi bi-trash me-1"></i>Xóa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${categoryPage.totalPages > 0}">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mt-4">
                        <div class="text-muted small">
                            Hiển thị trang <strong>${categoryPage.number + 1}</strong> / <strong>${categoryPage.totalPages}</strong>
                            (tổng cộng <strong>${categoryPage.totalElements}</strong> danh mục)
                        </div>

                        <nav aria-label="Phân trang danh mục">
                            <ul class="pagination pagination-sm mb-0">
                                <c:choose>
                                    <c:when test="${categoryPage.first}">
                                        <li class="page-item disabled">
                                            <span class="page-link"><i class="bi bi-chevron-left me-1"></i>Trước</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="prevUrl" value="/admin/categories/searchpaginated">
                                            <c:param name="page" value="${categoryPage.number}"/>
                                            <c:param name="size" value="${categoryPage.size}"/>
                                            <c:if test="${not empty name}">
                                                <c:param name="name" value="${name}"/>
                                            </c:if>
                                        </c:url>
                                        <li class="page-item">
                                            <a class="page-link" href="${prevUrl}"><i class="bi bi-chevron-left me-1"></i>Trước</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>

                                <c:forEach items="${pageNumbers}" var="pageNumber">
                                    <c:url var="pageUrl" value="/admin/categories/searchpaginated">
                                        <c:param name="page" value="${pageNumber}"/>
                                        <c:param name="size" value="${categoryPage.size}"/>
                                        <c:if test="${not empty name}">
                                            <c:param name="name" value="${name}"/>
                                        </c:if>
                                    </c:url>
                                    <li class="page-item ${pageNumber == categoryPage.number + 1 ? 'active' : ''}">
                                        <a class="page-link" href="${pageUrl}">${pageNumber}</a>
                                    </li>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${categoryPage.last}">
                                        <li class="page-item disabled">
                                            <span class="page-link">Sau<i class="bi bi-chevron-right ms-1"></i></span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="nextUrl" value="/admin/categories/searchpaginated">
                                            <c:param name="page" value="${categoryPage.number + 2}"/>
                                            <c:param name="size" value="${categoryPage.size}"/>
                                            <c:if test="${not empty name}">
                                                <c:param name="name" value="${name}"/>
                                            </c:if>
                                        </c:url>
                                        <li class="page-item">
                                            <a class="page-link" href="${nextUrl}">Sau<i class="bi bi-chevron-right ms-1"></i></a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 px-3 border rounded bg-light-subtle">
                    <div class="text-muted mb-3">
                        <i class="bi bi-folder-x display-4 text-secondary"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">Không có danh mục nào được tìm thấy</h5>
                    <p class="text-muted mb-4">
                        <c:choose>
                            <c:when test="${not empty name}">
                                Không tìm thấy danh mục nào khớp với từ khóa "<strong><c:out value="${name}"/></strong>".
                            </c:when>
                            <c:otherwise>
                                Hệ thống hiện chưa có danh mục nào. Hãy tạo danh mục đầu tiên ngay bây giờ.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="d-flex justify-content-center gap-2">
                        <c:if test="${not empty name}">
                            <c:url var="resetUrl" value="/admin/categories/searchpaginated">
                                <c:param name="size" value="${categoryPage.size}"/>
                            </c:url>
                            <a href="${resetUrl}" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Xem tất cả danh mục
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-circle me-1"></i> Thêm danh mục mới
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function confirmDeleteCategory(linkEl) {
        var categoryName = linkEl.getAttribute('data-name') || '';
        return confirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '" không?\nHành động này không thể hoàn tác.');
    }
</script>
</body>
</html>
