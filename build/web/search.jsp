<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Billiard Lab</title>
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
    <body style="background-color: white;" onload="onrun()">
        <%User u = (User) session.getAttribute("User");%>
        <%
            
        List<Product> products = (ArrayList)request.getAttribute("result");

        String search = request.getParameter("search");
        String message = (String)request.getAttribute("mess");
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
        <script>
            function onrun() {
                document.getElementById("searchid").value = "<%=search%>";
                document.getElementById("searchbutton").onclick = function(event) {
                    event.preventDefault();
                    document.getElementById("search").value = document.getElementById("searchid").value;
                    document.getElementById("searchfilter").submit();
                    //document.getElementById("searchid").value = document.getElementById("searchfilter");
                };
            };
        </script>
        <div class="text-center"
             style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
        <div class="text-center" id="message"
             style="color: black; font-size: 14px; font-weight: bold;"></div>
        <!-- Start of Product Items List -->
            <div class="row text-center">
                <div class="col-sm-2" style="-ms-flex: 0 0 10%; flex: 0 0 10%; max-width: 15%;">
                    <div class="thumbnail">
                        <div class="card-body text-center">
                            <p style="font-weight: bold; font-size: 15px">PRODUCT FILTER</p>
                            <form action="search" method="get" id="searchfilter">
                                <p class='text-left' style="margin-left: 8px">By Price</p>
                                <input type="number" placeholder="From $" name="from" style="width: 39%;" value="<%=request.getParameter("from") != null ? request.getParameter("from") : "0"%>" id='frominp' onchange="changeCash(this)"/> - <input style="width: 39%" type="number" placeholder="To $" name="to" value='<%=request.getParameter("to") != null ? request.getParameter("to") : "999999"%>' id='toinp' onchange="changeCash(this)"/>                                
                                <script>
                                    function changeCash(ele) {
                                        if(ele.id === 'frominp') {
                                            let to = document.getElementById("toinp");
                                            if(parseInt(to.value) < parseInt(ele.value)) {
                                                ele.value = to.value;
                                            }
                                            if(parseInt(ele.value) < 0) {
                                                ele.value = 0;
                                            }
                                        } else {
                                            let to = document.getElementById("frominp");
                                            if(parseInt(to.value) > parseInt(ele.value)) {
                                                ele.value = to.value;
                                            }
                                        }
                                    }
                                </script>
                                <hr>
                                <p class='text-left' style="margin-left: 8px">By Rate</p>
                                <input type="radio" name="stars" value="5 star" id="star" <%=(request.getParameter("stars") != null) ? (request.getParameter("stars").equals("5 star") ? "checked" : "") : ""%>/>
                                <label for="star">5 Star and above</label><br/>
                                <input type="radio" name="stars" value="4 star" id="star" <%=(request.getParameter("stars") != null) ? (request.getParameter("stars").equals("4 star") ? "checked" : "") : ""%>/>
                                <label for="star">4 Star and above</label><br/>
                                <input type="radio" name="stars" value="3 star" id="star" <%=(request.getParameter("stars") != null) ? (request.getParameter("stars").equals("3 star") ? "checked" : "") : ""%>/>
                                <label for="star">3 Star and above</label><br/>
                                <input type="radio" name="stars" value="2 star" id="star" <%=(request.getParameter("stars") != null) ? (request.getParameter("stars").equals("2 star") ? "checked" : "") : ""%>/>
                                <label for="star">2 Star and above</label><br/>
                                <input type="radio" name="stars" value="1 star" id="star" <%=(request.getParameter("stars") != null) ? (request.getParameter("stars").equals("1 star") ? "checked" : "") : ""%>/>
                                <label for="star">1 Star and above</label><br/>
                                <input type="hidden" name="search" value="<%=search%>" id="search"/>
                                <p class='text-left' style="margin-left: 8px">By Category</p>
                                <label for="category">Category:</label>
                                <select id="category" name="category">
                                    <option value="" disabled selected hidden>Category</option>
                                    <option value="bda" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bda") ? "selected" : "") : ""%>>BDA-Dragon</option>
                                    <option value="bfu" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bfu") ? "selected" : "") : ""%>>BFU-FURY</option>
                                    <option value="bja" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bja") ? "selected" : "") : ""%>>BJA-Jacoby</option>
                                    <option value="bdp" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bdp") ? "selected" : "") : ""%>>BDP-David Potts</option>
                                    <option value="bka" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bka") ? "selected" : "") : ""%>>BKA-Kaofa</option>
                                    <option value="bml" <%=(request.getParameter("category") != null) ? (request.getParameter("category").equals("bml") ? "selected" : "") : ""%>>BML-Maple Leaf</option>
                                </select>
                                <p class='text-left' style="margin-left: 8px">By Price</p>
                                <select id="price" name="price">
                                    <option value="" disabled selected hidden>Default</option>
                                    <option value="LtH" <%=(request.getParameter("price") != null) ? (request.getParameter("price").equals("LtH") ? "selected" : "") : ""%>>Low To High</option>
                                    <option value="HtL" <%=(request.getParameter("price") != null) ? (request.getParameter("price").equals("HtL") ? "selected" : "") : ""%>>High To Low</option>
                                </select>
                            </form>
                            <br>
                        </div>
                    </div>
                </div>
                <div class="col-sm-11" style="-ms-flex: 0 0 90%; flex: 0 0 90%; max-width: 85%;">
                <%
                for (int i = 0; i < (products.size() > 18 ? 18 : products.size()); i++) {
                    Product product = products.get(i);
                %>
                <div class="col-sm-2" style='height: 250px;'>
                    <div class="thumbnail">
                        <a href="product?pid=<%=product.getProdId()%>">
                            <% 
                                        byte[] ab = new byte[product.getProdImage().available()];
                                        product.getProdImage().read(ab, 0, ab.length);
                            %>
                        <img src="data:image/png;base64,<%=ImageConverter.gI().encode(ab)%>" alt="Product"
                             style="height: 100px; max-width: 100px">
                        <%
                        String prodName = product.getProdName();
                        prodName = prodName.substring(0, Math.min(prodName.length(), 12));
                        if(prodName.length() != product.getProdName().length()) {
                            prodName += "...";
                        }
                        %>
                        <p class="productname" style="font-size: 20px"><%=prodName%>
                        </p>
                        </a>
                        <%
                        String description = product.getProdInfo();
                        description = description.substring(0, Math.min(description.length(), 25));
                        %>
                        <p class="productinfo"><%=description%>..
                        </p>
                        <p class="price" style="color: #d9534f">
                            <%=product.getProdPrice()%>$
                        </p>
                    </div>
                </div>
                <%
                }
                %>
                </div>
            </div>
        <!-- ENd of Product Items List -->


        <%@ include file="footer.html"%>

    </body>
</html>