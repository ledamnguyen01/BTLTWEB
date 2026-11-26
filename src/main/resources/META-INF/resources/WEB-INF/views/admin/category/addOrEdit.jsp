<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật Danh mục' : 'Thêm Danh mục mới'}</title>
    <style>
        .preview-thumb {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 0.5rem;
        }
        .preview-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 0.5rem;
            background-color: #f8f9fa;
            color: #adb5bd;
        }
    </style>
</head>
<body>
<div class="row justify-content-center">
    <div class="col-12 col-lg-8">
        <div class="card border-0 shadow-sm bg-white">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h4 class="mb-0 fw-bold text-dark">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <i class="bi bi-pencil-square text-primary me-2"></i>Cập nhật Danh mục
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-folder-plus text-success me-2"></i>Thêm Danh mục mới
                        </c:otherwise>
                    </c:choose>
                </h4>
                <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>

            <div class="card-body p-4">
                <c:if test="${not empty alert}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                        <div><c:out value="${alert}"/></div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/categories/save"
                      method="post"
                      enctype="multipart/form-data"
                      class="needs-validation"
                      novalidate>

                    <c:if test="${not empty category.id}">
                        <input type="hidden" name="id" value="${category.id}">
                    </c:if>

                    <div class="mb-3">
                        <label for="name" class="form-label fw-semibold">
                            Tên danh mục <span class="text-danger">*</span>
                        </label>
                        <input type="text"
                               class="form-control"
                               id="name"
                               name="name"
                               value="<c:out value='${category.name}'/>"
                               required
                               minlength="2"
                               maxlength="200"
                               placeholder="Nhập tên danh mục (ví dụ: Điện thoại, Laptop...)">
                        <div class="invalid-feedback">
                            Vui lòng nhập tên danh mục (độ dài từ 2 đến 200 ký tự).
                        </div>
                        <div class="form-text">Độ dài hợp lệ từ 2 đến 200 ký tự.</div>
                    </div>

                    <div class="mb-3">
                        <label for="status" class="form-label fw-semibold">
                            Trạng thái <span class="text-danger">*</span>
                        </label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="1" ${category.status == 1 || empty category.status ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${category.status == 0 ? 'selected' : ''}>Tạm ẩn</option>
                        </select>
                        <div class="invalid-feedback">
                            Vui lòng chọn trạng thái cho danh mục.
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="imageFile" class="form-label fw-semibold">Hình ảnh danh mục</label>
                        <input type="file"
                               class="form-control"
                               id="imageFile"
                               name="imageFile"
                               accept=".jpg,.jpeg,.png,.gif,.webp,image/*">
                        <div class="form-text">
                            Chấp nhận định dạng JPG, JPEG, PNG, GIF hoặc WEBP (tối đa 10MB).
                            <c:if test="${isEdit}">
                                Để trống nếu muốn giữ nguyên hình ảnh hiện tại.
                            </c:if>
                        </div>

                        <div class="d-flex flex-wrap gap-4 mt-3">
                            <c:if test="${isEdit && not empty category.images}">
                                <div id="currentImageBox">
                                    <div class="small fw-semibold text-muted mb-2">Hình ảnh hiện tại</div>
                                    <img src="${pageContext.request.contextPath}/uploads/${category.images}"
                                         alt="<c:out value='${category.name}'/>"
                                         class="preview-thumb border shadow-sm"
                                         onerror="this.classList.add('d-none'); this.nextElementSibling.classList.remove('d-none'); this.nextElementSibling.classList.add('d-inline-flex');">
                                    <div class="preview-placeholder border d-none align-items-center justify-content-center" title="Không tải được ảnh">
                                        <i class="bi bi-image fs-2"></i>
                                    </div>
                                    <div class="small text-muted mt-1 text-truncate" style="max-width: 140px;" title="<c:out value='${category.images}'/>">
                                        <c:out value="${category.images}"/>
                                    </div>
                                </div>
                            </c:if>

                            <div id="newImagePreviewBox" class="d-none">
                                <div class="small fw-semibold text-primary mb-2">Xem trước ảnh mới</div>
                                <img id="imagePreview" src="" alt="Xem trước hình ảnh" class="preview-thumb border border-primary shadow-sm">
                                <div class="d-flex align-items-center justify-content-between mt-1 gap-2" style="max-width: 160px;">
                                    <small id="previewFileName" class="text-muted text-truncate"></small>
                                    <button type="button" id="clearImageBtn" class="btn btn-link btn-sm text-danger p-0 text-decoration-none" title="Hủy chọn ảnh">
                                        <i class="bi bi-x-circle"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary fw-semibold px-4">
                            <i class="bi bi-check2-circle me-1"></i> ${isEdit ? 'Cập nhật danh mục' : 'Lưu danh mục'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        var fileInput = document.getElementById('imageFile');
        var previewBox = document.getElementById('newImagePreviewBox');
        var previewImg = document.getElementById('imagePreview');
        var previewFileName = document.getElementById('previewFileName');
        var clearBtn = document.getElementById('clearImageBtn');

        if (!fileInput) {
            return;
        }

        function resetPreview() {
            previewImg.src = '';
            previewFileName.textContent = '';
            previewBox.classList.add('d-none');
        }

        fileInput.addEventListener('change', function () {
            var file = this.files && this.files[0];
            if (!file) {
                resetPreview();
                return;
            }
            if (!file.type || !file.type.startsWith('image/')) {
                resetPreview();
                return;
            }
            var reader = new FileReader();
            reader.onload = function (e) {
                previewImg.src = e.target.result;
                previewFileName.textContent = file.name;
                previewFileName.title = file.name;
                previewBox.classList.remove('d-none');
            };
            reader.readAsDataURL(file);
        });

        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                fileInput.value = '';
                resetPreview();
            });
        }
    })();
</script>
</body>
</html>
