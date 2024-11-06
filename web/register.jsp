<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Register</title>
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
        String message = request.getParameter("message");
        %>
        <div class="container">
            <div class="row">
                <form action="register" method="post" class="col-md-6 col-md-offset-3">
                    <div class="text-center">
                        <h2>Registration Form</h2>
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
                            <label for="username">Name</label>
                            <input type="text" name="username" class="form-control" id="username" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="email">Email</label>
                            <input type="email" name="email" class="form-control" id="email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea name="address" class="form-control" id="address" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="mobile">Mobile</label>
                            <input type="number" name="mobile" class="form-control" id="mobile" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="pincode">Pin Code</label>
                            <input type="number" name="pincode" class="form-control" id="pincode" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="password">Password</label>
                            <input type="password" name="password" class="form-control" id="password" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" required>
                        </div>
                    </div>
                    <div class="row text-center">
                        <div class="col-md-6">
                            <button type="reset" class="btn btn-danger">Reset</button>
                        </div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-success">Register</button>
                        </div>
                    </div>
                    <div class="text-center" style=" margin-top: 20px;">
                        <a href="login" style="font-weight: bolder;">Login</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
