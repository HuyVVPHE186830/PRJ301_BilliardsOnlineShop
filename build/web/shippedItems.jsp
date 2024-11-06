<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/shippedItems.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>
	<%
	DAO dao = new DAO();
        User u = (User) session.getAttribute("User");
        String userType = (String) (u == null ? null : (u.isAdmin() ? "admin" : "customer"));

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login?message=Access Denied, Login as admin!!");
                return;

	}

	else if (u == null) {

		response.sendRedirect("login?message=Session Expired, Login Again!!");
                return;

	}
	%>

	<jsp:include page="header.jsp" />

	<div class="ship-order">SHIPPED ORDERS</div>
	<div class="container-fluid">
		<div class="table-responsive ">
			<table class="table table-hover table-sm">
				<thead>
					<tr>
						<th>TransactionId</th>
                        <th>Payment</th>
						<th>ProductId</th>
						<th>Username</th>
						<th>Address</th>
						<th>Quantity</th>
						<th>Amount</th>
						<td>Status</td>
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
							String userId = dao.getUser(order.getUid()).getName();
							String userAddr = dao.getUser(order.getUid()).getAddress();
							if (shipped) {
								count++;
					%>

					<tr>
						<td><%=transId%></td>
                        <td><%=payment%></td>
						<td><a href="./updateProduct?prodid=<%=prodId%>"><%=prodId%></a></td>
                        <td><a href="profile?uid=<%=userId%>"><%=userId%></a></td>
						<td><%=userAddr%></td>
						<td><%=quantity%></td>
						<td><%=order.getTotal()%>$</td>
                        <td <%if(!status.equals("ORDER DECLINED")) {%> class="text-success" <%} else {%> class="text-danger" <%}%> style="font-weight: bold;">
                            <form method="post" action="updateOrder">
                                <input type="text" name="status" value="<%=status%>" style="max-width: 150px;" onchange="document.getElementById('Update').click()"> 
                                <input type="hidden" name="oid" value="<%=transId%>"> 
                                <input type="hidden" name="res" value="shipped"> 
                                <input id='Update' style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="submit" name="Update" value="Update" style="max-width: 80px;">
							</form>
                        </td>
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
