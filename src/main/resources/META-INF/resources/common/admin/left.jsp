<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav id="adminSidebar" class="col-md-3 col-lg-2 d-md-block bg-white sidebar collapse shadow-sm border-end py-3">
    <div class="position-sticky pt-2">
        <h6 class="px-3 mt-1 mb-2 text-muted text-uppercase small fw-bold">Quản lý</h6>
        <ul class="nav flex-column mb-3 gap-1 px-2">
            <li class="nav-item">
                <a class="nav-link py-2 px-3 d-flex align-items-center text-nowrap" href="${pageContext.request.contextPath}/admin/home">
                    <i class="bi bi-speedometer2 text-primary me-2"></i> Tổng quan
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2 px-3 d-flex align-items-center text-nowrap" href="${pageContext.request.contextPath}/admin/home#recent-categories">
                    <i class="bi bi-folder2-open text-success me-2"></i> Quản lý danh mục
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2 px-3 d-flex align-items-center text-nowrap" href="${pageContext.request.contextPath}/admin/home">
                    <i class="bi bi-people-fill text-info me-2"></i> Quản lý người dùng
                </a>
            </li>
        </ul>

        <h6 class="px-3 mt-3 mb-2 text-muted text-uppercase small fw-bold">Tài khoản</h6>
        <ul class="nav flex-column gap-1 px-2">
            <li class="nav-item">
                <a class="nav-link py-2 px-3 text-nowrap" href="${pageContext.request.contextPath}/home">
                    <i class="bi bi-house me-2"></i> Trang chủ Web
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-danger py-2 px-3 text-nowrap" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                </a>
            </li>
        </ul>
    </div>
</nav>
