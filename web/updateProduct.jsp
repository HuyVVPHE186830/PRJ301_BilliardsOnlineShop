<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Product</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/updateProduct.css">
    </head>
    <body>
        <%
        DAO dao = new DAO();
        /* Checking the user credentials */
        User u = (User) session.getAttribute("User");
        String userType = (String) (u == null ? null : (u.isAdmin() ? "admin" : "customer"));
        String prodid = request.getParameter("prodid");
        int pid = -1;
        if(prodid != null) {
            pid = Integer.parseInt(prodid);
        }
        Product product = dao.getProduct(pid);
        if (prodid == null || product == null) {
                response.sendRedirect("updateProduct?message=Please Enter a valid product Id");
                return;
        } else if (userType == null || !userType.equals("admin")) {
                response.sendRedirect("login?message=Access Denied, Login as admin!!");
                return;
        } else if (u == null) {
                response.sendRedirect("login?message=Session Expired, Login Again!!");
                return;
        }
        %>

        <jsp:include page="header.jsp" />

        <%
        String message = request.getParameter("message");
        %>
        <div class="container">
            <div class="row">
                <form action="changeImage" method="post" enctype="multipart/form-data">
                    <input name="upload" type="file" id="fileinput"/>
                    <input name="pid" type="text" value="<%=product.getProdId()%>"/>
                    <input type="submit" value="Upload File" id="upload"/>
                </form>
                <form class="form-update" action="updateProduct" method="post" class="col-md-6 col-md-offset-3">
                    <script type="text/javascript">
                        function changeImage() {
                            let input = document.getElementById("fileinput");
                            input.click();
                            input.onchange = function () {
                                let submit = document.getElementById("upload");
                                submit.click();
                            };
                        }
                    </script>
                    <div class="text-center">
                        <div class="form-group">
                            <a onclick="changeImage()">
                                <%
                                    byte[] pimg = new byte[product.getProdImage().available()];
                                    product.getProdImage().read(pimg, 0, pimg.length);
                                %>
                                <img src="data:image/png;base64,<%=ImageConverter.gI().encode(pimg)%>"
                                     alt="Product Image" />
                            </a>
                        </div>
                    </div>
                    <div class="text-center">
                        <h2>EDIT PRODUCT</h2>
                        <%
                        if (message != null) {
                        %>
                        <p><%=message%></p>
                        <%
                        }
                        %>
                    </div>
                    <div></div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="name">Product Name</label> 
                            <input type="text" placeholder="Enter Product Name" name="name" class="form-control" id="name" value="<%=product.getProdName()%>" required>
                        </div>
                        <input type="hidden" name="pid" class="form-control" value="<%=product.getProdId()%>" id="last_name" required>
                        <div class="col-md-6 form-group">
                            <%
                            String ptype = product.getProdType();
                            %>
                            <label for="producttype">Product Type</label> 
                            <select name="producttype" id="producttype" class="form-control" required>
                                <option value="bda" <%="bda".equalsIgnoreCase(ptype) ? "selected" : ""%>>BDA-Dragon</option>
                                <option value="bfu" <%="bfu".equalsIgnoreCase(ptype) ? "selected" : ""%>>BFU-FURY</option>
                                <option value="bja" <%="bja".equalsIgnoreCase(ptype) ? "selected" : ""%>>BJA-Jacoby</option>
                                <option value="bdp" <%="bdp".equalsIgnoreCase(ptype) ? "selected" : ""%>>BDP-David Potts</option>
                                <option value="bka" <%="bka".equalsIgnoreCase(ptype) ? "selected" : ""%>>BKA-Kaofa</option>
                                <option value="bml" <%="bml".equalsIgnoreCase(ptype) ? "selected" : ""%>>BML-Maple Leaf</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="info">Product Description</label>
                        <textarea name="info" class="form-control" id="info" required><%=product.getProdInfo()%></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="price">Unit Price</label> 
                            <input type="number" placeholder="Enter Unit Price" name="price" class="form-control" value="<%=product.getProdPrice()%>" id="price" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="quantity">Stock Quantity</label> 
                            <input type="number" placeholder="Enter Stock Quantity" name="quantity" value="<%=product.getProdQuantity()%>" class="form-control" id="quantity" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 text-center">
                            <button formaction="admin" class="btn btn-reset">Cancel</button>
                        </div>
                        <div class="col-md-6 text-center">
                            <button type="submit" class="btn btn-add">Edit Product</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="footer.html"%>
    </body>
</html>
