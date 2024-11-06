<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.User, Service.*, dal.DAO"%>
<!DOCTYPE html>
<html>
<head>
<title>Logout Header</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header2.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
	<!--Company Header Starting  -->
	<div class="container-fluid text-center">

	</div>
	<!-- Company Header Ending -->

	<%
            DAO dao = new DAO();
	/* Checking the user credentials */
        User u = (User) session.getAttribute("User");
	String userType = (String) (u == null ? null : (u.isAdmin() ? "admin" : "customer"));
	if (userType == null) { //LOGGED OUT
	%>

	<!-- Starting Navigation Bar -->
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
                            <a class="navbar-brand" href="index">
                                <img src="images/billiard_lab_logo.png" alt="logo"/>
                            </a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="login">Login</a></li>
					<li><a href="register">Register</a></li>
					<li><a href="index">Products</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="index?type=bda">BDA-Dragon</a></li>
							<li><a href="index?type=bfu">BFU-FURY</a></li>
							<li><a href="index?type=bja">BJA-Jacoby</a></li>
							<li><a href="index?type=bdp">BDP-David Potts</a></li>
							<li><a href="index?type=bka">BKA-Kaofa</a></li>
							<li><a href="index?type=bml">BML-Maple Leaf</a></li>
						</ul></li>
				</ul>
			</div>
		</div>
	</nav>
	<%
	} else if ("customer".equalsIgnoreCase(userType)) { //CUSTOMER HEADER

	int notf = dao.getCartCount(u.getName());
	%>
	<nav class="navbar navbar-default navbar-fixed-top">

		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index"><img src="images/billiard_lab_logo.png" alt="logo"/></a>
			</div>

			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="index"><span>Products</span></a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="index?type=bda">BDA-Dragon</a></li>
							<li><a href="index?type=bfu">BFU-FURY</a></li>
							<li><a href="index?type=bja">BJA-Jacoby</a></li>
							<li><a href="index?type=bdp">BDP-David Potts</a></li>
							<li><a href="index?type=bka">BKA-Kaofa</a></li>
							<li><a href="index?type=bml">BML-Maple Leaf</a></li>
						</ul></li>
					<%
					if (notf == 0) {
					%>
					<li><a href="cart"> <span
							class="glyphicon glyphicon-shopping-cart"></span>Cart
					</a></li>

					<%
					} else {
					%>
					<li><a href="cart" id="mycart"><i
							data-count="<%=notf%>"
							class="fa fa-shopping-cart fa-3x icon-white badge"></i><span
							class="glyphicon glyphicon-shopping-cart"></span>Cart</a></li>
					<%
					}
					%>
					<li><a href="orders">Orders</a></li>
					<li><a href="profile">Profile</a></li>
					<li><a href="logout">Logout</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<%
	} else { //ADMIN HEADER
	%>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index"><img src="images/billiard_lab_logo.png" alt="logo"/></a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="admin">Products</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="index?type=bda">BDA-Dragon</a></li>
							<li><a href="index?type=bfu">BFU-FURY</a></li>
							<li><a href="index?type=bja">BJA-Jacoby</a></li>
							<li><a href="index?type=bdp">BDP-David Potts</a></li>
							<li><a href="index?type=bka">BKA-Kaofa</a></li>
							<li><a href="index?type=bml">BML-Maple Leaf</a></li>
						</ul></li>
					<li><a href="shipped">Shipped</a></li>
					<li><a href="unshipped">Orders</a></li>
					<li><a href="statistic">Statistic</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Setting<span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="manage">User Manager</a></li>
							<li><a href="logout">Logout</a></li>
						</ul></li>

				</ul>
			</div>
		</div>
	</nav>
	<%
	}
	%>
	<!-- End of Navigation Bar -->
</body>
</html>
