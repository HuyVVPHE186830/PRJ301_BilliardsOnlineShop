<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userProfile.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

    <%
    /* Checking the user credentials */
    User u = (User) session.getAttribute("User");
    User currU = (User) session.getAttribute("User");
    boolean notOwn = false;
    if(request.getMethod().equals("GET")) {
        String uid = request.getParameter("uid");
        if(uid != null) {
            u = (User) request.getAttribute("User");
            notOwn = true;
        }
    }

    if (u == null) {
        response.sendRedirect("login?message=Session Expired, Login Again!!");
        return;
    }
    %>

    <jsp:include page="header.jsp" />

    <div class="container bg-secondary">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="index">Home</a></li>
                        <li class="breadcrumb-item"><a href="profile">User Profile</a></li>
                    </ol>
                </nav>
            </div>
        </div>

        <script type="text/javascript">
            function changeImage() {
                let input = document.getElementById("fileinput");
                input.click();
                input.onchange = function() {
                    let submit = document.getElementById("upload");
                    submit.click();
                }
            }
        </script>
        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <%
                        if(u.getImage() != null) {
                        %>
                        <a onclick="<%=notOwn ? "" : "changeImage()"%>">
                            <%
                            byte[] uimg = u.getImage().readAllBytes();
                            u.getImage().reset();
                            %>
                            <img src="data:image/png;base64,<%=ImageConverter.gI().encode(uimg)%>" class="rounded-circle img-fluid" style="width: 200px; height: 200px;">
                        </a>
                        <form action="changeAvatar" method="post" enctype="multipart/form-data">
                            <input style="overflow: hidden; width: 0px; height: 0px;" name="upload" type="file" id="fileinput"/>
                            <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="submit" value="Upload File" id="upload"/>
                        </form>
                        <%
                        } else {
                        %>
                        <a onclick="<%=notOwn ? "" : "changeImage()"%>">
                            <img src="images/profile.jpg" class="rounded-circle img-fluid default">
                        </a>
                        <form action="changeAvatar" method="post" enctype="multipart/form-data">
                            <input style="overflow: hidden; width: 0px; height: 0px;" name="upload" type="file" id="fileinput"/>
                            <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="submit" value="Upload File" id="upload"/>
                        </form>
                        <%
                        }
                        %>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Display Name</p>
                            </div>
                            <div class="col-sm-9">
                                <%if(!notOwn) {%>
                                <form action="profile" method="post">
                                    <input class="text-muted mb-0" value="<%=u.getDisplayname()%>" name="displayName" onchange="document.getElementById('changeName').click()"/>
                                    <input type="hidden" class="text-muted mb-0" value="<%=u.getName()%>" name="uid"/>
                                    <button style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="submit" id="changeName"></button>
                                </form>
                                <%} else {%>
                                <p class="text-muted mb-0"><%=u.getDisplayname()%></p>
                                <%}%>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Email</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><%=u.getEmail()%></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Phone</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><%=u.getMobile()%></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Address</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><%=u.getAddress()%></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">PinCode</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><%=u.getPinCode()%></p>
                            </div>
                        </div>
                        <%if(!notOwn) {%>
                        <h4><b>Change Password</b></h4>
                        <form method="POST">
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Old Password</p>
                                </div>
                                <div class="col-sm-4">
                                    <input type="password" name="old" required/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">New Password</p>
                                </div>
                                <div class="col-sm-4">
                                    <input type="password" name="new" required/>
                                </div>
                            </div>
                            <input type="submit" value="Change"/>
                            <%=request.getParameter("msg") != null ? "<br><p style=\"color: red\">"+request.getParameter("msg")+"</p>" : ""%>
                        </form>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <br>
    <br>
    <br>

    <jsp:include page="footer.html" />
</body>
</html>
