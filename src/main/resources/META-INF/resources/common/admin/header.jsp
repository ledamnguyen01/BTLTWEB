<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="navbar navbar-dark sticky-top bg-dark p-2 shadow">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning fs-6" href="${pageContext.request.contextPath}/admin/home">
            <i class="bi bi-shield-shaded"></i> ADMIN PANEL — SB4
        </a>
        <div class="d-flex align-items-center gap-2 text-nowrap">
            <span class="text-light small me-2 d-none d-sm-inline">
                <i class="bi bi-person-check-fill text-success"></i> ${sessionScope.account.fullname} (<strong class="text-warning">${sessionScope.account.role}</strong>)
            </span>
            <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-box-arrow-up-right"></i> Về Website
            </a>
            <a class="btn btn-sm btn-danger fw-semibold" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </div>
    </div>
</header>
