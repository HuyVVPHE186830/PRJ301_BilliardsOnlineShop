<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, dal.DAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Cart Details</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cartDetails.css">
    </head>
    <body>

        <%
        DAO dao = new DAO();
            User u = (User) session.getAttribute("User");

        if (u == null) {

            response.sendRedirect("login?message=Session Expired, Login Again!!");
                    return;
        }
        %>

        <jsp:include page="header.jsp" />

        <div class="cart-items">CART ITEMS</div>

        <div class="container">
            <table class="table table-hover" >
                <thead>
                    <tr>
                        <th>Picture</th>
                        <th>Products</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Remove</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Map<Product, Integer> cartItems = dao.cartDetails(u.getName());
                    double totAmount = 0;
                    for (Product item : cartItems.keySet()) {

                        int prodId = item.getProdId();
                        int prodQuantity = cartItems.get(item);
                        double currAmount = item.getProdPrice() * prodQuantity;
                        totAmount += currAmount;

                        if (prodQuantity > 0) {
                    %>
                    <tr>
                        <% 
                            byte[] ab = new byte[item.getProdImage().available()];
                            item.getProdImage().read(ab, 0, ab.length);
                        %>
                        <td><img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" style="width: 50px; height: 50px;"></td>
                        <td><%=item.getProdName()%></td>
                        <td><%=item.getProdPrice()%>$</td>
                        <td>
                            <form method="post" action="AddtoCart">
                                <input type="number" name="pqty" value="<%=prodQuantity%>" min="0" onchange="document.getElementById('Update').click()"> 
                                <input type="hidden" name="pid" value="<%=item.getProdId()%>"> 
                                <input type="hidden" name="uid" value="<%=u.getName()%>">
                                <input id='Update' type="submit" name="Update" value="Update">
                            </form>
                        </td>
                        <td><a href="AddtoCart?uid=<%=u.getName()%>&pid=<%=item.getProdId()%>&pqty=0" style="color: #d9534f;">Remove</a></td>
                        <td style="text-align: left"><%=currAmount%>$</td>
                    </tr>
                    <%
                        }
                    }
                    %>
                    <tr style="background-color: white">
                        <td colspan="5" style="text-align: center;">Total Amount to Pay (in Dollar)</td>
                        <td style="text-align: left"><%=totAmount%>$</td>
                    </tr>
                    <%
                    if (totAmount != 0) {
                    %>
                    <tr style="background-color: #0B1E33">
                        <td colspan="3" style="text-align: right;">
                        <td>
                            <form method="post">
                                <button formaction="index" style="background: #d9534f; border: none;">Cancel</button>
                            </form>
                        </td>
                        <td colspan="2" align="center">
                            <form id="pay" method="post" action="payment?type=pbq">
                                <script>
                                    function change() {
                                        if (document.getElementById("payType1").checked) {
                                            document.getElementById("pay").action = "payment?type=por";
                                        } else if (document.getElementById("payType2").checked) {
                                            document.getElementById("pay").action = "payment?type=pbq";
                                        }
                                    }
                                </script>
                                <input type="radio" id="payType1" name="pay_type" value="por" onclick="change()" > <p style="color: white; display: inline;"> On Receive </p>
                                <input type="radio" id="payType2" name="pay_type" value="pbq" onclick="change()" checked> <p style="color: white; display: inline;"> By QR Code </p>
                                <button style="background: #F5A201; color: #0B1E33; border: none; margin-left: 10px">Pay Now</button>
                            </form>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>

        <%@ include file="footer.html"%>

    </body>
</html>
