<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, java.util.Random, dal.DAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Payments</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body style="background-color: white;">

        <%
        DAO dao = new DAO();
        User u = (User) session.getAttribute("User");

        if (u == null) {

                response.sendRedirect("login?message=Session Expired, Login Again!!");
                return;
        }
        if(dao.getCartCount(u.getName()) == 0) {
                response.sendRedirect("cart");
                return;
        }

        String paymentType = request.getParameter("type");
        %>



        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="row"
                 style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
                <div class="col-md-6 col-md-offset-3" style="border-radius: 10px; background-color: rgba(255, 255, 255, 0.9); padding: 10px; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);">
                    <%
                        if(paymentType == null) {
                    %>
                    <form action="./payment?type=pbq" method="post">
                        <div class="col-md-6 form-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="form-control btn btn-success">
                                Pay By QR</button>
                        </div>
                    </form>
                    <form action="./payment?type=por" method="post">
                        <div class="col-md-6 form-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="form-control btn btn-success">
                                Pay On Receive</button>
                        </div>
                    </form>
                    <%
                        } else if(paymentType.equals("pbq")) {
                        double amount = dao.getCartAmount(u.getName());
                        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvxyz";
                        String generatedString = "";
                        Random r = new Random();
                        for(int i = 0; i< 6; i++) {
                            generatedString += AlphaNumericString.charAt(r.nextInt(AlphaNumericString.length()));
                        }
                        String desc = "BankAPI "+u.getName()+" "+generatedString;
                    %>
                    <img src="images/449480253_1108586223573355_4844032079460399656_n.jpg"
                         style="width: 200px; height: 200px; margin-left: 30%">
                    <form action="payment">
                        <input type="hidden" name="type" value="pbq"/>
                        <input type="hidden" name="done" value="true"/>
                        <input type="submit" class="btn btn-success" value="Done!" style="background-color: #0B1E33; border: none">
                    </form>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <!-- ENd of Product Items List -->


        <%@ include file="footer.html"%>

    </body>
</html>