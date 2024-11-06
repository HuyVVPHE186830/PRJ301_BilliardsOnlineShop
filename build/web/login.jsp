<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
        String message = request.getParameter("message");
        String user = null;
        String pass = null;
                Cookie[] cs = request.getCookies();
                for (int i = 0; i < cs.length; i++) {
                    if (cs[i].getName().equals("remember")) {
                        String[] arr = cs[i].getValue().split("-");
                        user = arr[0].split(":")[1];
                        pass = arr[1].split(":")[1];
                        break;
                    }
                }
                String forget = request.getParameter("forget");
        %>
        <div class="container">
            <div class="row">
                <form action="login" method="<%=forget==null ? "post" : "get"%>"
                      class="col-md-4 col-md-offset-4 col-sm-8 col-sm-offset-2">
                    <div class="text-center">
                        <h2><%=forget == null ? "Login" : "Forget Password"%></h2>
                        <%
                        if (message != null) {
                        %>
                        <p>
                            <%=message%>
                        </p>
                        <%
                        }
                        %>
                    </div>
                    <div></div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <%if(forget == null) {%>
                            <label for="username">Username</label> 
                            <input type="text" placeholder="Enter Username" name="username" class="form-control" id="username" <%=user != null ? "value=\""+user+"\"" : ""%> required>
                            <%} else {%>
                            <label for="username">Email</label> 
                            <input type="text" placeholder="Enter Email" name="email" class="form-control" id="username" required>
                            <%}%>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <%if(forget == null) {%>
                            <label for="password">Password</label> 
                            <input type="password" placeholder="Enter Password" name="password" class="form-control" id="password" <%=pass != null ? "value=\""+pass+"\"" : ""%> required>
                            <%}%>
                        </div>
                    </div>
                    <%if(forget == null) {%>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <input type="checkbox" name="remember" value="true" id="remember" <%=user != null ? "checked" : ""%>>
                            <label for="remember">Remember me</label>
                        </div>
                    </div>
                    <%}%>
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <button type="submit" class="btn btn-success"><%=forget == null ? "Login" : "Confirm"%></button>
                        </div>
                    </div>
                    <%if(forget == null) {%>
                    <div class="text-center">
                        <a href="register.jsp">Register</a>  | 
                        <a href="login?forget=1">Forget Password</a>
                    </div>
                    <%} else {%>
                    <div class="text-center">
                        <a href="login">Login</a>
                    </div>
                    <%}%>
                </form>
            </div>
        </div>

    </body>
</html>
