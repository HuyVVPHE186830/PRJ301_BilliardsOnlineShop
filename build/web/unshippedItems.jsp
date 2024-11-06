<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Home</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/unshippedItems.css">
</head>
<body>
	<%
	DAO dao = new DAO();
        User u = (User) session.getAttribute("User");
        String userType = (String) (u == null ? null : (u.isAdmin() ? "admin" : "customer"));

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login");
                return;

	}

	if (u == null) {

		response.sendRedirect("login");
                return;
	}
	%>

	<jsp:include page="header.jsp" />

	<div class="unship-order">UNSHIPPED ORDERS</div>
	<div class="container-fluid">
		<div class="table-responsive ">
			<table class="table table-hover table-sm">
				<thead>
					<tr>
						<th>TransactionId</th>
						<th>Payment</th>
						<th>ProductId</th>
						<th>User Email</th>
						<th>Address</th>
						<th>Quantity</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>

					<%
                        List<Order> orders = dao.getOrderList();
						int count = 0;
						for (Order order : orders) {
							int transId = order.getOrderID();
                            String payment = order.getPayment();
							int prodId = order.getProduct().getProdId();
							int quantity = order.getProduct().getProdQuantity();
							boolean shipped = order.isShipped();
							String status = order.getStatus();
							String userId = dao.getUser(order.getUid()).getEmail();
							String userAddr = dao.getUser(order.getUid()).getAddress();
							if (!shipped) {
								count++;
					%>

					<tr>
						<td><%=transId%></td>
						<td><%=payment%></td>
						<td><a href="./updateProduct?prodid=<%=prodId%>"><%=prodId%></a></td>
						<td><a href="profile?uid=<%=userId%>"><%=userId%></a></td>
						<td><%=userAddr%></td>
						<td><%=quantity%></td>
						<td><form method="post" action="updateOrder">
                                                        <input type="text" name="status" value="<%=status%>" style="max-width: 150px;" onchange="document.getElementById('Update').click()"> 
                                                        <input type="hidden" name="oid" value="<%=transId%>"> 
                                                        <input type="hidden" name="res" value="unshipped"> 
                                                        <input id='Update' style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="submit" name="Update" value="Update" style="max-width: 80px;">
						</form></td>
						<td><a href="Shipment?orderid=<%=order.getOrderID()%>" class="btn btn-add">SHIP NOW</a>
						    <a href="Shipment?orderid=<%=order.getOrderID()%>&decline=true" class="btn btn-reset">DECLINE</a></td>
					</tr>

					<%
						}
					}
					%>
					<%
					if (count == 0) {
					%>
					<tr style="background-color: grey; color: white;">
						<td colspan="8">No Items Available</td>
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
