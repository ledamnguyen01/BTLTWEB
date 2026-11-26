<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật Người dùng' : 'Thêm Người dùng mới'}</title>
</head>
<body>
<c:set var="isEditingSelf" value="${isEdit && sessionScope.account != null && sessionScope.account.id == userObj.id}"/>

<div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pb-3 mb-4 border-bottom">
    <div>
        <h3 class="fw-bold text-dark mb-1">
            <i class="bi ${isEdit ? 'bi-person-gear text-warning' : 'bi-person-plus-fill text-primary'}"></i>
            ${isEdit ? 'Cập nhật Người dùng' : 'Thêm Người dùng mới'}
        </h3>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${isEdit}">
                    Chỉnh sửa thông tin tài khoản <strong>@<c:out value="${userObj.username}"/></strong> (Mã #${userObj.id})
                </c:when>
                <c:otherwise>
                    Điền đầy đủ thông tin bên dưới để tạo tài khoản mới trong hệ thống
                </c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="btn btn-outline-secondary fw-semibold">
        <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
    </a>
</div>

<c:if test="${not empty alert}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
        <div><c:out value="${alert}"/></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/admin/users/save" method="post"
      enctype="multipart/form-data" class="needs-validation" novalidate>
    <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${userObj.id}">
    </c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm bg-white h-100">
                <div class="card-header bg-white py-3 border-bottom">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi bi-person-vcard text-primary me-2"></i> Thông tin tài khoản
                    </h5>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label fw-semibold">
                                Tên đăng nhập (Username) <span class="text-danger">*</span>
                            </label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="bi bi-at"></i></span>
                                <input type="text" name="username" id="username" class="form-control"
                                       value="<c:out value='${userObj.username}'/>"
                                       placeholder="Từ 3–30 ký tự, không dấu"
                                       required minlength="3" maxlength="30" pattern="^[a-zA-Z0-9_]{3,30}$">
                                <div class="invalid-feedback">
                                    Tên đăng nhập từ 3–30 ký tự (chỉ gồm chữ cái, số và dấu gạch dưới _).
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="fullname" class="form-label fw-semibold">
                                Họ và tên <span class="text-danger">*</span>
                            </label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" name="fullname" id="fullname" class="form-control"
                                       value="<c:out value='${userObj.fullname}'/>"
                                       placeholder="Ví dụ: Lê Đàm Nguyên"
                                       required minlength="2" maxlength="100">
                                <div class="invalid-feedback">
                                    Họ và tên phải có độ dài từ 2 đến 100 ký tự.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label fw-semibold">
                                Địa chỉ Email <span class="text-danger">*</span>
                            </label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" id="email" class="form-control"
                                       value="<c:out value='${userObj.email}'/>"
                                       placeholder="Ví dụ: user@hcmute.edu.vn"
                                       required>
                                <div class="invalid-feedback">
                                    Vui lòng nhập địa chỉ email hợp lệ.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold">
                                Số điện thoại <span class="text-danger">*</span>
                            </label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel" name="phone" id="phone" class="form-control"
                                       value="<c:out value='${userObj.phone}'/>"
                                       placeholder="Ví dụ: 0901234567"
                                       required pattern="^0[0-9]{9}$">
                                <div class="invalid-feedback">
                                    Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0.
                                </div>
                            </div>
                        </div>

                        <div class="col-12">
                            <label for="password" class="form-label fw-semibold">
                                Mật khẩu
                                <c:if test="${!isEdit}">
                                    <span class="text-danger">*</span>
                                </c:if>
                            </label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="bi bi-key"></i></span>
                                <c:choose>
                                    <c:when test="${isEdit}">
                                        <input type="password" name="password" id="password" class="form-control"
                                               minlength="6" autocomplete="new-password"
                                               placeholder="Để trống nếu không đổi mật khẩu">
                                        <button type="button" class="btn btn-outline-secondary" id="togglePasswordBtn"
                                                title="Hiện / Ẩn mật khẩu">
                                            <i class="bi bi-eye" id="togglePasswordIcon"></i>
                                        </button>
                                        <div class="invalid-feedback">
                                            Nếu muốn đổi mật khẩu, mật khẩu mới phải có ít nhất 6 ký tự.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="password" name="password" id="password" class="form-control"
                                               required minlength="6" autocomplete="new-password"
                                               placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
                                        <button type="button" class="btn btn-outline-secondary" id="togglePasswordBtn"
                                                title="Hiện / Ẩn mật khẩu">
                                            <i class="bi bi-eye" id="togglePasswordIcon"></i>
                                        </button>
                                        <div class="invalid-feedback">
                                            Mật khẩu bắt buộc nhập và phải có độ dài tối thiểu 6 ký tự.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${isEdit}">
                                <div class="form-text">
                                    <i class="bi bi-info-circle me-1"></i> Bỏ trống ô này để giữ nguyên mật khẩu hiện tại (đã mã hóa BCrypt).
                                </div>
                            </c:if>
                        </div>

                        <div class="col-md-6">
                            <label for="role" class="form-label fw-semibold">
                                Vai trò <span class="text-danger">*</span>
                            </label>
                            <select name="role" id="role" class="form-select" required>
                                <option value="USER" ${userObj.role == 'USER' || empty userObj.role ? 'selected' : ''}>
                                    Người dùng (USER)
                                </option>
                                <option value="ADMIN" ${userObj.role == 'ADMIN' ? 'selected' : ''}>
                                    Quản trị viên (ADMIN)
                                </option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn vai trò cho tài khoản.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="status" class="form-label fw-semibold">
                                Trạng thái <span class="text-danger">*</span>
                            </label>
                            <select name="status" id="status" class="form-select" required>
                                <option value="1" ${userObj.status == 1 || userObj.status == null ? 'selected' : ''}>
                                    Hoạt động (1)
                                </option>
                                <option value="0" ${userObj.status == 0 ? 'selected' : ''}>
                                    Đã khóa (0)
                                </option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn trạng thái tài khoản.</div>
                        </div>

                        <c:if test="${isEditingSelf}">
                            <div class="col-12">
                                <div class="alert alert-warning py-2 px-3 mb-0 small d-flex align-items-center">
                                    <i class="bi bi-shield-exclamation me-2 fs-6"></i>
                                    <div>
                                        Bạn đang chỉnh sửa tài khoản Admin hiện tại. Hệ thống không cho phép tự khóa hoặc tự hạ quyền tài khoản đang đăng nhập.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm bg-white h-100">
                <div class="card-header bg-white py-3 border-bottom">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi bi-image text-primary me-2"></i> Ảnh đại diện
                    </h5>
                </div>
                <div class="card-body p-4 d-flex flex-column align-items-center text-center">
                    <c:set var="hasExistingImage" value="${not empty userObj.images}"/>
                    <c:if test="${hasExistingImage}">
                        <c:choose>
                            <c:when test="${fn:startsWith(userObj.images, 'http://') or fn:startsWith(userObj.images, 'https://')}">
                                <c:set var="existingImgUrl" value="${userObj.images}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="existingImgUrl" value="${pageContext.request.contextPath}/uploads/${userObj.images}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <div class="mb-3 position-relative">
                        <img id="avatarPreview"
                             <c:if test="${hasExistingImage}">src="<c:out value='${existingImgUrl}'/>"</c:if>
                             data-original-src="<c:if test='${hasExistingImage}'><c:out value='${existingImgUrl}'/></c:if>"
                             alt="Xem trước ảnh đại diện"
                             class="rounded-circle border shadow-sm object-fit-cover ${hasExistingImage ? '' : 'd-none'}"
                             style="width: 150px; height: 150px;"
                             onerror="this.classList.add('d-none'); var ph = document.getElementById('avatarPlaceholder'); ph.classList.remove('d-none'); ph.classList.add('d-inline-flex');">

                        <div id="avatarPlaceholder"
                             class="rounded-circle bg-primary-subtle text-primary border align-items-center justify-content-center ${hasExistingImage ? 'd-none' : 'd-inline-flex'}"
                             style="width: 150px; height: 150px;">
                            <i class="bi bi-person-fill" style="font-size: 4rem;"></i>
                        </div>
                    </div>

                    <div class="w-100 text-start">
                        <label for="imageFile" class="form-label fw-semibold">Chọn ảnh đại diện</label>
                        <input type="file" name="imageFile" id="imageFile" class="form-control"
                               accept=".jpg,.jpeg,.png,.gif,.webp,image/*">
                        <div class="form-text">
                            Hỗ trợ JPG, JPEG, PNG, GIF, WEBP (tối đa 10MB).
                            <c:if test="${isEdit}">
                                Để trống để giữ ảnh hiện tại.
                            </c:if>
                        </div>
                        <div id="imageErrorMsg" class="text-danger small mt-1 d-none">
                            Tệp được chọn không phải là hình ảnh hợp lệ!
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
        <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="btn btn-outline-secondary px-4">
            <i class="bi bi-x-lg me-1"></i> Hủy bỏ
        </a>
        <button type="submit" class="btn btn-primary fw-semibold px-4 shadow-sm">
            <i class="bi bi-check2-circle me-1"></i> ${isEdit ? 'Lưu thay đổi' : 'Thêm người dùng'}
        </button>
    </div>
</form>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var toggleBtn = document.getElementById('togglePasswordBtn');
        var passwordInput = document.getElementById('password');
        var toggleIcon = document.getElementById('togglePasswordIcon');

        if (toggleBtn && passwordInput && toggleIcon) {
            toggleBtn.addEventListener('click', function () {
                var isPwd = passwordInput.type === 'password';
                passwordInput.type = isPwd ? 'text' : 'password';
                toggleIcon.className = isPwd ? 'bi bi-eye-slash' : 'bi bi-eye';
            });
        }

        var fileInput = document.getElementById('imageFile');
        var previewImg = document.getElementById('avatarPreview');
        var placeholder = document.getElementById('avatarPlaceholder');
        var imageErrorMsg = document.getElementById('imageErrorMsg');

        function showPlaceholder() {
            if (previewImg) {
                previewImg.removeAttribute('src');
                previewImg.classList.add('d-none');
            }
            if (placeholder) {
                placeholder.classList.remove('d-none');
                placeholder.classList.add('d-inline-flex');
            }
        }

        function showPreview(src) {
            if (previewImg) {
                previewImg.src = src;
                previewImg.classList.remove('d-none');
            }
            if (placeholder) {
                placeholder.classList.remove('d-inline-flex');
                placeholder.classList.add('d-none');
            }
        }

        function restoreOriginalAvatar() {
            var originalSrc = previewImg ? previewImg.getAttribute('data-original-src') : '';
            if (originalSrc) {
                showPreview(originalSrc);
            } else {
                showPlaceholder();
            }
        }

        if (fileInput && previewImg && placeholder) {
            fileInput.addEventListener('change', function () {
                if (imageErrorMsg) imageErrorMsg.classList.add('d-none');
                var file = this.files && this.files[0];
                if (!file) {
                    restoreOriginalAvatar();
                    return;
                }
                if (!file.type || !file.type.startsWith('image/')) {
                    if (imageErrorMsg) imageErrorMsg.classList.remove('d-none');
                    this.value = '';
                    restoreOriginalAvatar();
                    return;
                }
                var reader = new FileReader();
                reader.onload = function (e) {
                    showPreview(e.target.result);
                };
                reader.readAsDataURL(file);
            });
        }
    });
</script>
</body>
</html>
