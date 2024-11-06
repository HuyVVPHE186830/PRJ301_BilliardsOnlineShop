<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Stocks</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
        DAO dao = new DAO();
        /* Checking the user credentials */
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

        <div class="text-center all-products">ALL PRODUCTS</div>
        <div class="container-fluid">
            <div class="table-responsive">
                <table class="table table-hover table-sm">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Product Id</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Sold</th>
                            <th>Stock</th>
                            <th colspan="2" style="text-align: center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        List<Product> products = new ArrayList<Product>();
                        products = dao.allProducts();
                        String pageN = request.getParameter("page");
                        int p = 1;
                        int total = (int)Math.ceil((double)products.size() / 12.0);
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
                        for (int i = 0 + 12*(p-1); i < ((12 + 12*(p-1)) > products.size() ? products.size() : (12 + 12*(p-1))); i++) {
                            Product product = products.get(i);
                        %>

                        <tr>
                            <% 
                                        byte[] ab = new byte[product.getProdImage().available()];
                                        product.getProdImage().read(ab, 0, ab.length);
                            %>
                            <td><img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>"></td>
                            <td><a
                                    href="./product?pid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
                                <%
                                String name = product.getProdName();
                                name = name.substring(0, Math.min(name.length(), 25)) + "..";
                                %>
                            <td><%=name%></td>
                            <td><%=product.getProdType().toUpperCase()%></td>
                            <td><%=product.getProdPrice()%>$</td>
                            <td><%=dao.countSoldItem(product.getProdId())%></td>
                            <td><%=product.getProdQuantity()%></td>
                            <td>
                                <form method="post">
                                    <button type="submit"
                                            formaction="updateProduct?prodid=<%=product.getProdId()%>"
                                            class="btn btn-edit">Edit</button>
                                </form>
                            </td>
                            <td>
                                <form method="post">
                                    <button type="submit"
                                            formaction="./RemoveProduct?prodid=<%=product.getProdId()%>"
                                            class="btn btn-remove" onclick="return confirm('Are you sure you want to delete this student?')">Remove</button>
                                </form>
                            </td>

                        </tr>

                        <%
                        }
                        %>
                        <%
                        if (products.size() == 0) {
                        %>
                        <tr style="background-color: grey;">
                            <td colspan="8">No Items Available</td>

                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
                <form>
                    <button type="submit" formaction="addProduct" class="btn btn-add" style="transform: none;">Add products</button>
                </form>
                <form class="text-center">
                    <button class="btn btn-edit" type="submit" formaction="admin?page=<%=(p - 1) <= 0 ? 0 : (p - 1)%>"><</button>
                    <input type="number" value="<%=p%>" name="page" onchange="form.submit()"/>
                    <button class="btn btn-edit" type="submit" formaction="admin?page=<%=(p + 1) > total ? total : (p + 1)%>">></button>
                </form>
            </div>
        </div>

        <%@ include file="footer.html"%>
    </body>
</html>
