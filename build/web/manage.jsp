<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <title>User Manage</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/change.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manage.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
            DAO dao = new DAO();
        %>
        <jsp:include page="header.jsp" />
        
        <div class="text-center all-user">ALL USER</div>
        <div class="container-fluid">
            <div class="table-responsive">
                <table class="table table-hover table-sm">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Display Name</th>
                            <th>Mobile</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th colspan="1" style="text-align: center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${lists}" var="l">
                            <tr>
                                <td>
                                    <c:set var="name" value="${l.name}" />
                                    <a href="profile?uid=${l.name}">${name}</a>
                                </td>
                                <td>${l.displayname != null ? l.displayname : ""}</td>
                                <td>${l.mobile}</td>
                                <td>${l.email}</td>
                                <td>${l.address}</td>
                                <td>
                                    <form action="manage" method="post">
                                        <input type="hidden" name="uid" value="${l.name}"/>
                                        <input class="btn btn-ban" type="submit" value="${dao.checkBanned(l.name) ? 'Unban' : 'Ban'}"/>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <%@ include file="footer.html"%>
    </body>
</html>
