<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title"/> - Admin Panel</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f4f6f9;
            font-size: 0.92rem;
        }
        .sidebar {
            min-height: calc(100vh - 56px);
        }
        .sidebar .nav-link {
            color: #333;
            font-weight: 500;
            border-radius: 0.5rem;
            transition: background-color 0.15s ease, color 0.15s ease;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #e7f1ff;
            color: #0d6efd;
        }
        main {
            flex: 1 0 auto;
        }
    </style>

    <sitemesh:write property="head"/>
</head>
<body>
    <%@ include file="/common/admin/header.jsp" %>

    <div class="container-fluid flex-grow-1">
        <div class="row">
            <%@ include file="/common/admin/left.jsp" %>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <sitemesh:write property="body"/>
            </main>
        </div>
    </div>

    <%@ include file="/common/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
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
