<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Home</title>
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
    <body style="background-color: white !important;">
        <%
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

        <div class="products" style="background-color: white !important;">

            <div class="tab" style="
                 margin-right: 3%;
                 width: 97%;
                 border-radius: 10px;
                 background-color: rgba(255, 255, 255, 0.9);
                 padding: 10px;
                 box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);">
                <div class="row">
                    <div class="col-lg-2">
                        <p style="margin-left: 4vw" >Sold Chart</p>
                        <img src="ShowImage?sellPercent=true" style="margin-left: 1vw; border-radius: 50%; width: 200px; height: 200px"/>
                    </div>
                    <div class="col-lg-5">
                        <div class="row" style="margin-top: 5vh;">
                            <img style="background: lime; width: 25px; height: 25px"/>
                            <p style="display: inline">BDA-Dragon</p>
                        </div>
                        <div class="row">
                            <img style="background: magenta; width: 25px; height: 25px"/>
                            <p style="display: inline">BFU-FURY</p>
                        </div> 
                        <div class="row">
                            <img style="background: red; width: 25px; height: 25px"/>
                            <p style="display: inline">BJA-Jacoby</p>
                        </div> 
                        <div class="row">
                            <img style="background: blue; width: 25px; height: 25px"/>
                            <p style="display: inline">BDP-David Potts</p>
                        </div> 
                        <div class="row">
                            <img style="background: yellow; width: 25px; height: 25px"/>
                            <p style="display: inline">BKA-Kaofa</p>
                        </div> 
                        <div class="row">
                            <img style="background: orange; width: 25px; height: 25px"/>
                            <p style="display: inline">BML-Maple Leaf</p>
                        </div> 
                    </div>
                    <div class="col-lg-3">
                        <p style="margin-left: 6vw;">10 Most Sold Product</p>
                        <img src="ShowImage?top10=true"/>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.html"%>
    </body>
</html>