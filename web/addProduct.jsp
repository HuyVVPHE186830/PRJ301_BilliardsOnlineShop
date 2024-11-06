<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Product</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="css/addProduct.css">
    </head>
    <body>
        <%
            User u = (User) session.getAttribute("User");
            String userType = (String) (u == null ? null : (u.isAdmin() ? "admin" : "customer"));

            if (userType == null || !userType.equals("admin")) {
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
                <form action="addProduct" method="post" enctype="multipart/form-data" class="col-md-6 col-md-offset-3 form-container">
                    <div class="form-heading">
                        <h2>ADD PRODUCT</h2>
                        <% if (message != null) { %>
                        <p class="message"><%= message %></p>
                        <% } %>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="name">Product Name</label>
                            <input type="text" placeholder="Enter Product Name" name="name" class="form-control" id="name" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="producttype">Product Type</label>
                            <select name="producttype" id="producttype" class="form-control" required>
                                <option value="bfu">BFU-FURY</option>
                                <option value="bja">BJA-Jacoby</option>
                                <option value="bdp">BDP-David Potts</option>
                                <option value="bka">BKA-Kaofa</option>
                                <option value="bda">BDA-Dragon</option>
                                <option value="bml">BML-Maple Leaf</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="info">Product Description</label>
                        <textarea name="info" class="form-control" id="info" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="price">Unit Price</label>
                            <input type="number" placeholder="Enter Unit Price" name="price" class="form-control" id="price" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="quantity">Stock Quantity</label>
                            <input type="number" placeholder="Enter Stock Quantity" name="quantity" class="form-control" id="quantity" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="image">Product Image</label>
                        <input type="file" placeholder="Select Image" name="image" class="form-control" id="image" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 text-center">
                            <button type="reset" class="btn-reset">Reset</button>
                        </div>
                        <div class="col-md-6 text-center">
                            <button type="submit" class="btn-add">Add Product</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="footer.html" />
    </body>
</html>
