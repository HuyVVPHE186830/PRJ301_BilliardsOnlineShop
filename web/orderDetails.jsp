<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderDetails.css">
</head>
<body>
    <% DAO dao = new DAO();
        User u = (User) session.getAttribute("User");

        if (u == null) {
            response.sendRedirect("login?message=Session Expired, Login Again!!");
            return;
        }

        List<Order> orders = dao.getOrderList(u.getName());
    %>

    <jsp:include page="header.jsp" />

    <div class="order-details">ORDER DETAILS</div>

    <div class="container">
        <div class="table-responsive">
            <table class="table table-hover table-sm">
                <thead>
                    <tr>
                        <th>Picture</th>
                        <th>Product Name</th>
                        <th>Order Id</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Payment</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Order order : orders) {
                            byte[] ab = new byte[order.getProduct().getProdImage().available()];
                            order.getProduct().getProdImage().read(ab, 0, ab.length);
                    %>
                    <tr>
                        <td><img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" style="width: 50px; height: 50px;"></td>
                        <td><%=order.getProduct().getProdName()%></td>
                        <td><%=order.getOrderID()%></td>
                        <td><%=order.getProduct().getProdQuantity()%></td>
                        <td><%=order.getTotal()%>$</td>
                        <td><%=order.getPayment()%></td>
                        <td class="<%=order.getStatus().equals("ORDER DECLINED") ? "text-danger" : "text-success"%>"><%=order.getStatus()%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="footer.html"%>
</body>
</html>
