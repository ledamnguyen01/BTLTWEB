<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="bg-primary text-white py-1 px-3 small d-none d-md-block">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <i class="bi bi-mortarboard-fill me-1"></i> HCMUTE - Lập trình Web (ThS. Nguyễn Hữu Trung) | Spring Boot 4 + JSP/JSTL + SiteMesh 3
        </div>
        <div>
            <i class="bi bi-person-fill me-1"></i> Lê Đàm Nguyên - MSSV: 24110040
        </div>
    </div>
</div>
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold text-warning" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-layers-fill"></i> SpringBoot4 MVC
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#webNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="webNavbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 text-nowrap">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">
                            <i class="bi bi-house-door"></i> Trang chủ
                        </a>
                    </li>
                    <c:if test="${sessionScope.account != null && sessionScope.account.admin}">
                        <li class="nav-item">
                            <a class="nav-link text-warning fw-semibold" href="${pageContext.request.contextPath}/admin/home">
                                <i class="bi bi-speedometer2"></i> Quản trị Admin
                            </a>
                        </li>
                    </c:if>
                </ul>

                <ul class="navbar-nav ms-auto align-items-center text-nowrap">
                    <c:choose>
                        <c:when test="${sessionScope.account == null}">
                            <li class="nav-item me-2">
                                <a class="btn btn-outline-light btn-sm px-3" href="${pageContext.request.contextPath}/login">
                                    <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-warning btn-sm fw-bold px-3" href="${pageContext.request.contextPath}/register">
                                    <i class="bi bi-person-plus-fill"></i> Đăng ký
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item text-white me-3">
                                <span class="badge ${sessionScope.account.admin ? 'bg-warning text-dark' : 'bg-info text-dark'} me-1">
                                    ${sessionScope.account.role}
                                </span>
                                Xin chào, <strong class="text-info">${sessionScope.account.fullname}</strong>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-danger btn-sm fw-bold" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
</header>
