<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Billiard Lab</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: white;">
        <%User u = (User) session.getAttribute("User");%>
        <%
        DAO dao = new DAO(); 
        List<Product> products = new ArrayList<Product>();

        String search = request.getParameter("search");
        String type = request.getParameter("type");
        String message = "ALL PRODUCTS";
        
        if (search != null) {
                products = dao.ProductsByName(search);
                message = "Showing Results for '" + search + "'";
        } else if (type != null) {
                products = dao.ProductsByType(type);
                message = "Showing Results for '" + type + "'";
        } else {
                products = dao.allProducts();
        }
        if (products.isEmpty() && (type != null || search != null)) {
                message = "No items found for the search '" + (search != null ? search : type) + "'";
                products = dao.allProducts();
        }
        String pageN = request.getParameter("page");
        int p = 1;
        int total = (int) Math.ceil((double)products.size() / 9.0);
        if(pageN != null) {
            try {
                p = Integer.parseInt(pageN);
            } catch(Exception e) {}
        }
            if(p <= 0) {
                p = 1;
            }
            if(p > total) {
                p = total;
            }
        %>
        <jsp:include page="header.jsp" />
        <div class="container-fluid text-center" style="margin-top: 0;">
		<form class="form-inline" action="search" method="get" id="searchform">
			<div class="input-group" id="searchdiv">
				<input type="text" class="form-control" size="50" name="search"
					placeholder="Search Product" id="searchid" >
				<div class="input-group-btn">
                                    <button id="searchbutton" type="submit" class="btn btn-search"><i class="fa fa-search"></i></button>
				</div>
			</div>
		</form>
		<p align="center" id="message"></p>
	</div>
        <div class="text-center-title"><%=message%></div>
        <div class="text-center" id="message"
             style="color: black; font-size: 14px; font-weight: bold;"></div>
        <!-- Start of Product Items List -->
        <div class="container">
            <div class="row text-center">

                <%
                for (int i = (0+(9*(p - 1)) < 0 ? 0 : 0+(9*(p - 1))); i < (9+(9*(p - 1)) > products.size() ? products.size() : 9+(9*(p - 1))); i++) {
                    Product product = products.get(i);
                %>
                <div class="col-sm-4" style='height: 350px;'>
                    <div class="thumbnail">
                        <a href="product?pid=<%=product.getProdId()%>">
                            <% 
                                        byte[] ab = new byte[product.getProdImage().available()];
                                        product.getProdImage().read(ab, 0, ab.length);
                            %>
                            <img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" alt="Product"
                                 style="height: 150px; max-width: 180px">
                            <%
                            String prodName = product.getProdName();
                            prodName = prodName.substring(0, Math.min(prodName.length(), 20));
                            if(prodName.length() != product.getProdName().length()) {
                                prodName += "...";
                            }
                            %>
                            <p class="productname"><%=prodName%>
                            </p>
                        </a>
                        <%
                        String description = product.getProdInfo();
                        description = description.substring(0, Math.min(description.length(), 50));
                        %>
                        <p class="productinfo""><%=description%>..
                        </p>
                        <p class="price">
                            <%=product.getProdPrice()%>$
                        </p>
                        <%if(u != null && !u.isAdmin()) {
                            int cartQty = dao.getCartCount(u.getName(), product.getProdId());
                        %>
                        <form method="post">
                            <%
                            if (cartQty == 0) {
                                if(product.getProdQuantity() != 0) {
                            %>
                            <button type="submit"
                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1"
                                    class="btn btn-blue">Add to Cart</button>
                            &nbsp;&nbsp;&nbsp;
                            <button type="submit"
                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1&buy=true"
                                    class="btn btn-red">Buy Now</button>
                            <%
                                } else {
                            %>
                            <p style="color: #d9534f;font-size: 20px"><b>SOLD OUT<b></p>
                                        <%
                                    }
                                    } else {
                                        %>
                                        <button type="submit"
                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=0"
                                                class="btn btn-red">Remove From Cart</button>
                                        &nbsp;&nbsp;&nbsp;
                                        <button type="submit" formaction="cart"
                                                class="btn btn-blue">Checkout</button>
                                        <%
                                        }
                                        %>
                                        </form>
                                        <%
                                            } else if(u != null && u.isAdmin()) {
                                        %>
                                        <form method="post">
                                            <button type="submit"
                                                    formaction="RemoveProduct?prodid=<%=product.getProdId()%>"
                                                    class="btn btn-red" onclick="return confirm('Are you sure you want to delete this student?')">Remove Product</button>
                                            &nbsp;&nbsp;&nbsp;
                                            <button type="submit"
                                                    formaction="updateProduct?prodid=<%=product.getProdId()%>"
                                                    class="btn btn-blue">Edit Product</button>
                                        </form>
                                        <%
                                            }
                                        %>
                                        <br />
                                        </div>
                                        </div>

                                        <%
                                        }
                                        %>

                                        </div>
                                        </div>
                                        <div class="text-center"><form action="index"><button class="btn btn-blue" onclick="document.getElementById('page').value = '<%=p - 1%>'"><</button><%if(type != null) {%><input type='hidden' name="type" value="<%=type%>"/><%}%><input style='width: 3.5vw' id="page" type="number" name="page" value="<%=p%>" onchange='form.submit()' /><button onclick="document.getElementById('page').value = '<%=p + 1%>'" class="btn btn-blue">></button></form></div>
                                        <br>
                                        <div class="text-center-title">MOST SOLD PRODUCTS</div>
                                        <br>
                                        <div class="container">
                                            <div class="row text-center">
                                                <%
                                                    List<Product> sold = dao.most10Sold();
                                                    for(int i = 0; i < (sold.size() >= 4 ? 4 : sold.size()); i++) {
                                                        Product product = sold.get(i);
                                                %>

                                                <div class="col-sm-3" style='height: 350px;'>
                                                    <div class="thumbnail">
                                                        <a href="product?pid=<%=product.getProdId()%>">
                                                            <% 
                                                                        byte[] ab = new byte[product.getProdImage().available()];
                                                                        product.getProdImage().read(ab, 0, ab.length);
                                                            %>
                                                            <img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" alt="Product"
                                                                 style="height: 150px; max-width: 180px">
                                                            <%
                                                            String prodName = product.getProdName();
                                                            prodName = prodName.substring(0, Math.min(prodName.length(), 15));
                                                            if(prodName.length() != product.getProdName().length()) {
                                                                prodName += "...";
                                                            }
                                                            %>
                                                            <p class="productname"><%=prodName%>
                                                            </p>
                                                        </a>
                                                        <%
                                                        String description = product.getProdInfo();
                                                        description = description.substring(0, Math.min(description.length(), 50));
                                                        %>
                                                        <p class="productinfo"><%=description%>..
                                                        </p>
                                                        <p class="price">
                                                            <%=product.getProdPrice()%>$
                                                        </p>
                                                        <%if(u != null && !u.isAdmin()) {
                                                            int cartQty = dao.getCartCount(u.getName(), product.getProdId());
                                                        %>
                                                        <form method="post">
                                                            <%
                                                            if (cartQty == 0) {
                                                                if(product.getProdQuantity() != 0) {
                                                            %>
                                                            <button type="submit"
                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1"
                                                                    class="btn btn-blue">Add to Cart</button>
                                                            &nbsp;&nbsp;&nbsp;
                                                            <button type="submit"
                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1&buy=true"
                                                                    class="btn btn-red">Buy Now</button>
                                                            <%
                                                                } else {
                                                            %>
                                                            <p style="color: #d9534f;font-size: 20px"><b>SOLD OUT<b></p>
                                                                        <%
                                                                    }
                                                                    } else {
                                                                        %>
                                                                        <button type="submit"
                                                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=0"
                                                                                class="btn btn-red">Remove From Cart</button>
                                                                        &nbsp;&nbsp;&nbsp;
                                                                        <button type="submit" formaction="cart"
                                                                                class="btn btn-blue">Checkout</button>
                                                                        <%
                                                                        }
                                                                        %>
                                                                        </form>
                                                                        <%
                                                                            } else if(u != null && u.isAdmin()) {
                                                                        %>
                                                                        <form method="post">
                                                                            <button type="submit"
                                                                                    formaction="RemoveProduct?prodid=<%=product.getProdId()%>"
                                                                                    class="btn btn-red" onclick="return confirm('Are you sure you want to delete this student?')">Remove Product</button>
                                                                            &nbsp;&nbsp;&nbsp;
                                                                            <button type="submit"
                                                                                    formaction="updateProduct?prodid=<%=product.getProdId()%>"
                                                                                    class="btn btn-blue">Edit Product</button>
                                                                        </form>
                                                                        <%
                                                                            }
                                                                        %>
                                                                        </div>
                                                                        </div>
                                                                        <%
                        }%>
                                                                        </div>
                                                                        </div>
                                                                        <br>
                                                                        <div class="text-center-title">NEW PRODUCTS</div>
                                                                        <br>
                                                                        <div class="container">
                                                                            <div class="row text-center">
                                                                                <%
                                                                                    List<Product> soldn = dao.newItems();
                                                                                    for(int i = 0; i < (soldn.size() >= 4 ? 4 : soldn.size()); i++) {
                                                                                        Product product = soldn.get(i);
                                                                                %>

                                                                                <div class="col-sm-3" style='height: 350px;'>
                                                                                    <div class="thumbnail">
                                                                                        <a href="product?pid=<%=product.getProdId()%>">
                                                                                            <% 
                                                                                                        byte[] ab = new byte[product.getProdImage().available()];
                                                                                                        product.getProdImage().read(ab, 0, ab.length);
                                                                                            %>
                                                                                            <img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" alt="Product"
                                                                                                 style="height: 150px; max-width: 180px">
                                                                                            <%
                                                                                            String prodName = product.getProdName();
                                                                                            prodName = prodName.substring(0, Math.min(prodName.length(), 15));
                                                                                            if(prodName.length() != product.getProdName().length()) {
                                                                                                prodName += "...";
                                                                                            }
                                                                                            %>
                                                                                            <p class="productname"><%=prodName%>
                                                                                            </p>
                                                                                        </a>
                                                                                        <%
                                                                                        String description = product.getProdInfo();
                                                                                        description = description.substring(0, Math.min(description.length(), 50));
                                                                                        %>
                                                                                        <p class="productinfo"><%=description%>..
                                                                                        </p>
                                                                                        <p class="price">
                                                                                            <%=product.getProdPrice()%>$
                                                                                        </p>
                                                                                        <%if(u != null && !u.isAdmin()) {
                                                                                            int cartQty = dao.getCartCount(u.getName(), product.getProdId());
                                                                                        %>
                                                                                        <form method="post">
                                                                                            <%
                                                                                            if (cartQty == 0) {
                                                                                                if(product.getProdQuantity() != 0) {
                                                                                            %>
                                                                                            <button type="submit"
                                                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1"
                                                                                                    class="btn btn-blue">Add to Cart</button>
                                                                                            &nbsp;&nbsp;&nbsp;
                                                                                            <button type="submit"
                                                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1&buy=true"
                                                                                                    class="btn btn-red">Buy Now</button>
                                                                                            <%
                                                                                                } else {
                                                                                            %>
                                                                                            <p style="color: #d9534f;font-size: 20px"><b>SOLD OUT<b></p>
                                                                                                        <%
                                                                                                    }
                                                                                                    } else {
                                                                                                        %>
                                                                                                        <button type="submit"
                                                                                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=0"
                                                                                                                class="btn btn-red">Remove From Cart</button>
                                                                                                        &nbsp;&nbsp;&nbsp;
                                                                                                        <button type="submit" formaction="cart"
                                                                                                                class="btn btn-blue">Checkout</button>
                                                                                                        <%
                                                                                                        }
                                                                                                        %>
                                                                                                        </form>
                                                                                                        <%
                                                                                                            } else if(u != null && u.isAdmin()) {
                                                                                                        %>
                                                                                                        <form method="post">
                                                                                                            <button type="submit"
                                                                                                                    formaction="RemoveProduct?prodid=<%=product.getProdId()%>"
                                                                                                                    class="btn btn-red" onclick="return confirm('Are you sure you want to delete this student?')">Remove Product</button>
                                                                                                            &nbsp;&nbsp;&nbsp;
                                                                                                            <button type="submit"
                                                                                                                    formaction="updateProduct?prodid=<%=product.getProdId()%>"
                                                                                                                    class="btn btn-blue">Edit Product</button>
                                                                                                        </form>
                                                                                                        <%
                                                                                                            }
                                                                                                        %>
                                                                                                        </div>
                                                                                                        </div>
                                                                                                        <%
                        }%>
                                                                                                        </div>
                                                                                                        </div>
                                                                                                        <br>
                                                                                                        <div class="text-center-title"">FAMOUS PRODUCTS</div>
                                                                                                        <br>
                                                                                                        <div class="container">
                                                                                                            <div class="row text-center">
                                                                                                                <%
                                                                                                                    List<Product> sold2n = dao.FamousItems();
                                                                                                                    for(int i = 0; i < (sold2n.size() >= 4 ? 4 : sold2n.size()); i++) {
                                                                                                                        Product product = sold2n.get(i);
                                                                                                                %>

                                                                                                                <div class="col-sm-3" style='height: 350px;'>
                                                                                                                    <div class="thumbnail">
                                                                                                                        <a href="product?pid=<%=product.getProdId()%>">
                                                                                                                            <% 
                                                                                                                                        byte[] ab = new byte[product.getProdImage().available()];
                                                                                                                                        product.getProdImage().read(ab, 0, ab.length);
                                                                                                                            %>
                                                                                                                            <img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" alt="Product"
                                                                                                                                 style="height: 150px; max-width: 180px">
                                                                                                                            <%
                                                                                                                            String prodName = product.getProdName();
                                                                                                                            prodName = prodName.substring(0, Math.min(prodName.length(), 15));
                                                                                                                            if(prodName.length() != product.getProdName().length()) {
                                                                                                                                prodName += "...";
                                                                                                                            }
                                                                                                                            %>
                                                                                                                            <p class="productname"><%=prodName%>
                                                                                                                            </p>
                                                                                                                        </a>
                                                                                                                        <%
                                                                                                                        String description = product.getProdInfo();
                                                                                                                        description = description.substring(0, Math.min(description.length(), 50));
                                                                                                                        %>
                                                                                                                        <p class="productinfo"><%=description%>..
                                                                                                                        </p>
                                                                                                                        <p class="price">
                                                                                                                            <%=product.getProdPrice()%>$
                                                                                                                        </p>
                                                                                                                        <%if(u != null && !u.isAdmin()) {
                                                                                                                            int cartQty = dao.getCartCount(u.getName(), product.getProdId());
                                                                                                                        %>
                                                                                                                        <form method="post">
                                                                                                                            <%
                                                                                                                            if (cartQty == 0) {
                                                                                                                                if(product.getProdQuantity() != 0) {
                                                                                                                            %>
                                                                                                                            <button type="submit"
                                                                                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1"
                                                                                                                                    class="btn btn-blue">Add to Cart</button>
                                                                                                                            &nbsp;&nbsp;&nbsp;
                                                                                                                            <button type="submit"
                                                                                                                                    formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=1&buy=true"
                                                                                                                                    class="btn btn-red">Buy Now</button>
                                                                                                                            <%
                                                                                                                                } else {
                                                                                                                            %>
                                                                                                                            <p style="color: #d9534f;font-size: 20px"><b>SOLD OUT</b></p>
                                                                                                                                        <%
                                                                                                                                    }
                                                                                                                                    } else {
                                                                                                                                        %>
                                                                                                                                        <button type="submit"
                                                                                                                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=product.getProdId()%>&pqty=0"
                                                                                                                                                class="btn btn-red">Remove From Cart</button>
                                                                                                                                        &nbsp;&nbsp;&nbsp;
                                                                                                                                        <button type="submit" formaction="cart"
                                                                                                                                                class="btn btn-blue">Checkout</button>
                                                                                                                                        <%
                                                                                                                                        }
                                                                                                                                        %>
                                                                                                                                        </form>
                                                                                                                                        <%
                                                                                                                                            } else if(u != null && u.isAdmin()) {
                                                                                                                                        %>
                                                                                                                                        <form method="post">
                                                                                                                                            <button type="submit"
                                                                                                                                                    formaction="RemoveProduct?prodid=<%=product.getProdId()%>"
                                                                                                                                                    class="btn btn-red" onclick="return confirm('Are you sure you want to delete this student?')">Remove Product</button>
                                                                                                                                            &nbsp;&nbsp;&nbsp;
                                                                                                                                            <button type="submit"
                                                                                                                                                    formaction="updateProduct?prodid=<%=product.getProdId()%>"
                                                                                                                                                    class="btn btn-blue">Edit Product</button>
                                                                                                                                        </form>
                                                                                                                                        <%
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        </div>
                                                                                                                                        </div>
                                                                                                                                        <%
                        }%>
                                                                                                                                        </div>
                                                                                                                                        </div>
                                                                                                                                        <!-- ENd of Product Items List -->


                                                                                                                                        <%@ include file="footer.html"%>

                                                                                                                                        </body>
                                                                                                                                        </html>