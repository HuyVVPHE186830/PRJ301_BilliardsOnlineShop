<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.*, Service.*, java.util.*, java.io.*, java.text.SimpleDateFormat, dal.DAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Profile Details</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changes.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body style="background-color: white;">

        <%
        DAO dao = new DAO();
        User u = (User) session.getAttribute("User");
        String pid = request.getParameter("pid");
        if(pid == null) {

                response.sendRedirect("index?message=Wrong Product!!");
                return;
        }

        if (u == null) {

                response.sendRedirect("login?message=Session Expired, Login Again!!");
                return;
        }
        int id = Integer.parseInt(pid);
        Product p = dao.getProduct(id);
        %>



        <jsp:include page="header.jsp" />

        <div class="container bg-secondary">
            <div class="row">
                <div class="col">
                    <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="index">Home</a></li>
                            <li class="breadcrumb-item"><a href="index?type=<%=p.getProdType()%>"><%=p.getProdType()%></a></li>
                            <li class="breadcrumb-item"><a href="#"><%=p.getProdName()%></a></li>
                        </ol>
                    </nav>
                </div>
            </div>
            <% ProductDetails pd = dao.getDetails(p.getProdId()); %>
            <form action = "changeImage" method = "post" enctype = "multipart/form-data">
                <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" name="sideUpload" type="file" id="sideFileinput" multiple/>
                <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type = "text" name = "type" value="addSideIMG"/>
                <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type = "submit" id = "sideUpload"/>
                <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" name="pid" type="text" value="<%=p.getProdId()%>"/>
                <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" name="url" type="text" value="product?pid=<%=p.getProdId()%>"/>
            </form>
            <div class="thumbnail">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="card mb-4">
                            <div class="card-body text-center">
                                <a onclick="changeImage()">
                                    <% 
                                
                        InputStream[] arr = pd.getImages().keySet().toArray(new InputStream[pd.getImages().keySet().size()]);
                        for (int i = 0; i < arr.length; i++) {
                            for (int j = i; j < arr.length; j++) {
                                if(arr[i].available() > arr[j].available()) {
                                    InputStream temp = arr[i];
                                    arr[i] = arr[j];
                                    arr[j] = temp;
                                }
                            }
                        }
                                                byte[] prod = new byte[p.getProdImage().available()];
                                                p.getProdImage().read(prod, 0, prod.length);
                                    %>
                                    <img src="data:image/png;base64,<%=ImageConverter.gI().encode(prod)%>" id="mainIMG" class="rounded-circle img-fluid"
                                         style="width: 300px; height: 300px">
                                    <div id="mainVID" style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;">
                                    </div>
                                </a>
                                <!-- <p class="text-muted mb-1">Full Stack Developer</p>
                                <p class="text-muted mb-4">Bay Area, San Francisco, CA</p> -->
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="card mb-4">
                            <div class="card-body">
                                <p style="font-size: 30px"><%=p.getProdName()%></p>
                                <p style="font-size: 15px"><%=pd.getRate()%>
                                    <%
                                        ArrayList<Order> list = dao.getOrderList(u.getName(), p.getProdId());
                                        boolean check = false;
                                        if(!list.isEmpty()) {
                                            for(int i = 0; i < list.size(); i++) {
                                                if(list.get(i).isShipped() && !list.get(i).getStatus().equals("ORDER DECLINED")) {
                                                    check = true;
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <span style="background: linear-gradient(to right, gold 0% <%=(int)(pd.getRate()/5 * 100) %>%, #bdbdbd <%=(int)(pd.getRate()/5 * 100)%>% 100%); color: #bdbdbd; -webkit-background-clip: text; -webkit-text-fill-color: transparent;">&#x2605;&#x2605;&#x2605;&#x2605;&#x2605;</span>
                                    | <%=pd.getRateTime()%> Rates | <%=p.getSold()%> Sold</p>
                                <p style="color:#0B1E33; font-weight: bold; font-size: 20px" class="text-muted mb-0"><%=p.getProdPrice()%>$</p>
                                <hr>
                                <div class="row">
                                    <div class="col-sm-9">
                                        <p class="text-muted mb-0"><%=p.getProdInfo()%>
                                        </p>
                                    </div>
                                </div>
                                <br>
                                <br>
                                <div class="row">
                                    <div class="col-sm-2">
                                        <p class="mb-0">Amount</p>
                                    </div>
                                    <script>
                                        function minusAmount() {
                                            let val = document.getElementById("amount").value;
                                            if (val > 1) {
                                                document.getElementById("amount").value = val - 1;
                                            }
                                        }
                                        function plusAmount() {
                                            let val = document.getElementById("amount").value;
                                            if (val < <%=p.getProdQuantity()%>) {
                                                document.getElementById("amount").value = parseInt(val) + 1;
                                            }
                                        }
                                        function changeAmount() {
                                            let val = document.getElementById("amount").value;
                                            if (val > <%=p.getProdQuantity()%>) {
                                                document.getElementById("amount").value = <%=p.getProdQuantity()%>;
                                            }
                                            if (val <= 0) {
                                                document.getElementById("amount").value = 1;
                                            }
                                        }
                                    </script>
                                    <%
                                        if(p.getProdQuantity() != 0) {
                                    %>
                                    <form method="post">
                                        <input style="width: 20px; height: 10%" type="button" value="-" onclick="minusAmount()"/>
                                        <input style="width: 50px" type="number" id="amount" name="pqty" value="1" onchange="changeAmount()"/> <!--<%=p.getProdQuantity()%>-->
                                        <input style="width: 20px; height: 10%" type="button" value="+" onclick="plusAmount()"/>
                                        <span class="text-muted"><%=p.getProdQuantity()%> Available</span>
                                        <br>
                                        <br>
                                        <%if(!u.isAdmin()) {%>
                                        <button type="submit"
                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=p.getProdId()%>"
                                                class="btn btn-success" style="background: #0B1E33; border: none;">Add to Cart</button>
                                        &nbsp;&nbsp;&nbsp;
                                        <button type="submit"
                                                formaction="AddtoCart?uid=<%=u.getName()%>&pid=<%=p.getProdId()%>&buy=true"
                                                class="btn btn-primary" style="background: #d9534f; border: none;">Buy Now</button>
                                        <%} else {%>
                                        <button type="submit"
                                                formaction="RemoveProduct?prodid=<%=p.getProdId()%>"
                                                class="btn btn-danger">Remove Product</button>
                                        &nbsp;&nbsp;&nbsp;
                                        <button type="submit"
                                                formaction="updateProduct?prodid=<%=p.getProdId()%>"
                                                class="btn btn-primary">Edit Product</button>
                                        <%}%>
                                    </form>
                                    <%
                                        } else {
                                    %>
                                    <p style="color: #d9534f; font-weight: bold">SOLD OUT</p>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="thumbnail">
                <h4>RATE AND COMMENT</h4>
                <div class="thumbnail">
                    <%int userid = dao.getRate(p.getProdId(), u.getName());%>
                    <script>
                        function onStar(star) {
                            let id = star.id.toString() + "L";
                            let i = parseInt(star.id.toString().charAt(star.id.toString().length - 1));
                            for (var j = i + 1; j < 6; j++) {
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.background = "gold";
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.webkitBackgroundClip = "text";
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.webkitTextFillColor = "transparent";
                            }
                            for (var j = i - 1; j > 0; j--) {
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.background = "#bdbdbd";
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.webkitBackgroundClip = "text";
                                document.getElementById(star.id.toString().replace(i.toString(), j.toString()) + "L").style.webkitTextFillColor = "transparent";
                            }
                            document.getElementById(id).style.background = "gold";
                            document.getElementById(id).style.webkitBackgroundClip = "text";
                            document.getElementById(id).style.webkitTextFillColor = "transparent";
                        }
                    </script>
                    <%
                        String pages = request.getParameter("page");
                        if(check && userid == -1) {%>
                    <script>
                        function getImages() {
                            document.getElementById("files").click();
                            document.getElementById("files").onchange = function () {
                                let len = document.getElementById("files").files.length;
                                document.getElementById("imgs").innerHTML = '';
                                if (len > 10) {
                                    alert("You can only choose max to 10 files!");
                                    document.getElementById("files").files = new Array();
                                    return;
                                }
                                for (var i = 0; i < len; i++) {
                                    var extension = document.getElementById("files").files[i].type;
                                    if (extension.startsWith("image")) {
                                        let img = document.createElement("img");
                                        img.style.width = "7.5vw";
                                        img.style.marginLeft = "1vw";
                                        img.style.height = "15vh";
                                        img.src = window.URL.createObjectURL(document.getElementById("files").files[i]);
                                        document.getElementById("imgs").appendChild(img);
                                    } else {
                                        let img = document.createElement("video");
                                        img.style.width = "7.5vw";
                                        img.style.marginLeft = "1vw";
                                        img.preload = "metadata";
                                        img.controls = "controls";
                                        let src = document.createElement("source");
                                        src.type = extension;
                                        src.src = window.URL.createObjectURL(document.getElementById("files").files[i]);
                                        img.appendChild(src);
                                        document.getElementById("imgs").appendChild(img);
                                    }
                                }
                            };
                        }
                    </script>
                    <form action="addRate" method="post" enctype="multipart/form-data">
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" id="star-5" value="start-1" type="radio" name="star" onclick="onStar(this)"/>
                        <label id="star-5L" style="background: gold; margin-left: 1vw; font-size: 25px; -webkit-background-clip: text; -webkit-text-fill-color: transparent;" for="star-5">&#x2605;</label>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;"  id="star-4" value="start-2" type="radio" name="star" onclick="onStar(this)"/>
                        <label style="background: gold; font-size: 25px; -webkit-background-clip: text; -webkit-text-fill-color: transparent;" id="star-4L" for="star-4">&#x2605;</label>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;"  id="star-3" value="start-3" type="radio" name="star" onclick="onStar(this)"/>
                        <label style="background: gold; font-size: 25px; -webkit-background-clip: text; -webkit-text-fill-color: transparent;" id="star-3L" for="star-3">&#x2605;</label>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;"  id="star-2" value="start-4" type="radio" name="star" onclick="onStar(this)"/>
                        <label style="background: gold; font-size: 25px; -webkit-background-clip: text; -webkit-text-fill-color: transparent;" id="star-2L" for="star-2">&#x2605;</label>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" checked id="star-1" value="start-5" type="radio" name="star" onclick="onStar(this)"/>
                        <label style="background: gold; font-size: 25px; -webkit-background-clip: text; -webkit-text-fill-color: transparent;" id="star-1L" for="star-1">&#x2605;</label>
                        <textarea style="width: 54vw; margin-top: 1vh" placeholder="Comment" name="comment"></textarea> <button class="btn btn-success" style="margin-bottom: 5vh; background: #0B1E33; border: none;" type="submit">Send</button>
                        <button class="btn btn-primary" style="margin-bottom: 5vh; background: #F5A201; border: none;" onclick="getImages()" id="test" type="button">Files</button>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" type="file" id="files" name="files" accept="image/*,video/*"  multiple/>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" value="<%=p.getProdId()%>" name="pid"/>
                        <input style="overflow: hidden; width: 0px; height: 0px; visibility: hidden;" value="<%=u.getName()%>" name="uid"/>
                        <div id="imgs">
                        </div>
                    </form>
                    <%} else {%>
                    <% if(pages == null) {%>
                    <p style="font-size: 30px; margin-left: 2.5vw"><%=pd.getRate()%>/5 <button style="margin-left: 5vw ;font-size: 15px; background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=5 Stars'">5 Stars</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=4 Stars'">4 Stars</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=3 Stars'">3 Stars</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=2 Stars'">2 Stars</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=1 Stars'">1 Stars</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=content'">Have images/videos</button><button style="margin-left: 1vw;font-size: 15px;background: #0B1E33; border: none;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>'">All</button></p>
                    <%} else {%>
                    <p style="font-size: 30px; margin-left: 2.5vw"><%=pd.getRate()%>/5 <button style="margin-left: 5vw ;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=5 Stars&page=<%=pages%>'">5 Stars</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=4 Stars&page=<%=pages%>'">4 Stars</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=3 Stars&page=<%=pages%>'">3 Stars</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=2 Stars&page=<%=pages%>'">2 Stars</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=1 Stars&page=<%=pages%>'">1 Stars</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=content&page=<%=pages%>'">Have images/videos</button><button style="margin-left: 1vw;font-size: 15px" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&page=<%=pages%>'">All</button></p>
                    <%}%>
                    <span style="margin-left: 1vw; font-size: 30px;background: linear-gradient(to right, gold 0% <%=(int)(pd.getRate()/5 * 100) %>%, #bdbdbd <%=(int)(pd.getRate()/5 * 100)%>% 100%); color: #bdbdbd; -webkit-background-clip: text; -webkit-text-fill-color: transparent;">&#x2605;&#x2605;&#x2605;&#x2605;&#x2605;</span>
                    <%}%>
                </div>
                <%
                    String filterType = request.getParameter("filter");
                    ArrayList<Rate> allRates = new ArrayList();
                    if(filterType != null) {
                        allRates = dao.getRateFilter(p.getProdId(), filterType);
                    } else {
                        allRates = dao.getAllRate(p.getProdId());
                    }
                    if(allRates.isEmpty()) {
                %>
                <p>No Comment Yet</p>
                <%} else {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
                    if(allRates.size() <= 6) {
                    for(int i = 0; i < allRates.size(); i++) {
                        User tempU = dao.getUser(allRates.get(i).getUid());
                %>
                <hr>
                <div class="row">
                    <div class="col-lg-1">
                        <div class="card">
                            <div class="card-body text-center">
                                <a>
                                    <%
                                        byte[] uimg = new byte[tempU.getImage().available()];
                                        tempU.getImage().read(uimg, 0, uimg.length);
                                    %>
                                    <img src="data:image/png;base64,<%=ImageConverter.gI().encode(uimg)%>"
                                         style="width: 2.5vw; height: 2.5vw; border-radius: 50%; margin-left: 1vw">
                                </a>
                                <!-- <p class="text-muted mb-1">Full Stack Developer</p>
                                <p class="text-muted mb-4">Bay Area, San Francisco, CA</p> -->
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="row">
                                    <span><%=tempU.getDisplayname()%></span>
                                </div>
                                <div class="row" id="rate">
                                    <span style="font-size:15px; background: linear-gradient(to right, gold 0% <%=(int)((double)allRates.get(i).getRate()/5 * 100) %>%, #bdbdbd <%=(int)((double)allRates.get(i).getRate()/5 * 100)%>% 100%); color: #bdbdbd; -webkit-background-clip: text; -webkit-text-fill-color: transparent;">&#x2605;&#x2605;&#x2605;&#x2605;&#x2605;</span>
                                </div>
                                <div class="row">
                                    <p style="font-size:10px; color: gray; font-family: 'sans-serif'"><%=format.format(allRates.get(i).getTime())%></p>
                                </div>
                                <div class="row" id="comment">
                                    <%if(!allRates.get(i).getComment().isEmpty()) {%>
                                    <%String[] cmtArr = allRates.get(i).getComment().split("\n");
                                        for(int ci = 0; ci < cmtArr.length; ci++) {
                                    %>
                                    <p><%=cmtArr[ci]%></p>
                                    <%}}%>
                                </div>
                                <div class="row" style="display:flex" id="content">
                                    <%if(!allRates.get(i).getContent().isEmpty()) {%>
                                    <%  int j = 0;
                                        for(InputStream in : allRates.get(i).getContent().keySet()) {
                                        if(allRates.get(i).getContent().get(in).startsWith("image")) {%>
                                    <script>
                                        function showImg(image) {
                                            let divCon = image.parentElement.parentElement.querySelector("#divshow");
                                            let img = divCon.querySelector("#show");
                                            let vid = divCon.querySelector("#vshow");
                                            if (img.name) {
                                                if (img.name === image.name) {
                                                    img.src = null;
                                                    img.name = null;
                                                    img.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                } else {
                                                    img.src = image.src;
                                                    img.name = image.name;
                                                    img.style = "overflow: hidden; max-width:300px; width:100% height: 100%; max-height: 300px";
                                                    if (vid) {
                                                        divCon.removeChild(vid);
                                                    }
                                                }
                                            } else {
                                                img.src = image.src;
                                                img.name = image.name;
                                                img.style = "overflow: hidden; max-width:300px; width:100% height: 100%; max-height: 300px";
                                                if (vid) {
                                                    divCon.removeChild(vid);
                                                }
                                            }
                                        }
                                    </script>
                                    <%
                                        
                                        byte[] ab1 = new byte[in.available()];
                                        in.read(ab1, 0, ab1.length);
                                    %>
                                    <img name="img-<%=j%>" onclick="showImg(this)" style="flex: 1; margin-left: 5px" src="data:<%=allRates.get(i).getContent().get(in)%>;base64,<%=ImageConverter.gI().encode(ab1)%>" width="100px" height="100px"/>
                                    <%} else {%>
                                    <script>
                                        function showVid(vid) {
                                            let divCon = vid.parentElement.parentElement.querySelector("#divshow");
                                            let img = divCon.querySelector("#vshow");
                                            let imgs = divCon.querySelector("#show");
                                            let image = vid.children[0];
                                            if (img) {
                                                if (img.name === vid.id) {
                                                    divCon.removeChild(img);
                                                } else {
                                                    img.name = vid.id;
                                                    img.children[0].src = image.src;
                                                    img.children[0].type = image.type;
                                                    if (imgs.name) {
                                                        imgs.src = null;
                                                        imgs.name = null;
                                                        imgs.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                    }
                                                }
                                            } else {
                                                img = document.createElement("video");
                                                img.preload = "metadata";
                                                img.controls = "controls";
                                                img.id = "vshow";
                                                img.name = vid.id;
                                                img.style = "max-width: 500px; max-height: 500px;";
                                                let src = document.createElement("source");
                                                src.src = image.src;
                                                src.type = image.type;
                                                img.appendChild(src);
                                                divCon.appendChild(img);
                                                if (imgs.name) {
                                                    imgs.src = null;
                                                    imgs.name = null;
                                                    imgs.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                }
                                            }
                                        }
                                    </script>
                                    <video id="vid-<%=j%>" onclick="showVid(this)" style="flex: 1; margin-left: 5px" width="100px" height="100px"/>
                                    <%
                                        
                                        byte[] ab2 = new byte[in.available()];
                                        in.read(ab2, 0, ab2.length);
                                    %>
                                    <source src="data:<%=allRates.get(i).getContent().get(in)%>;base64,<%=ImageConverter.gI().encode(ab2)%>" type="<%=allRates.get(i).getContent().get(in)%>">
                                    </video>
                                    <%}
                                    j++;
                                    }%>
                                    <%}%>
                                </div>
                                <div id="divshow" class="row">
                                    <img id="show"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%if(tempU.getName().equals(u.getName())) {%>
                    <a id="deletebtn" style="margin-left: 50vw; color: #d9534f; font-size: 20px" href="updateComment?isDelete=true&pid=<%=p.getProdId()%>&uid=<%=u.getName()%>" class="fa fa-trash"></a>
                    <%}%>
                    <p id = "output"></p>
                </div>
                <%}
                    } else {
                    int pageN = 0;
                    if(pages != null) {
                        pageN = Integer.parseInt(pages);
                    }
                for(int i = 0+pageN*6; i < (6+pageN*6 > allRates.size() ? allRates.size() : 6+pageN*6); i++) {
                        User tempU = dao.getUser(allRates.get(i).getUid());
                %>
                <hr>
                <div class="row">
                    <div class="col-lg-1">
                        <div class="card">
                            <div class="card-body text-center">
                                <a>
                                    <%
                                        byte[] uimg = new byte[tempU.getImage().available()];
                                        tempU.getImage().read(uimg, 0, uimg.length);
                                    %>
                                    <img src="data:image/png;base64,<%=ImageConverter.gI().encode(uimg)%>"
                                         style="width: 2.5vw; height: 2.5vw; border-radius: 50%; margin-left: 1vw">
                                </a>
                                <!-- <p class="text-muted mb-1">Full Stack Developer</p>
                                <p class="text-muted mb-4">Bay Area, San Francisco, CA</p> -->
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="row">
                                    <span><%=tempU.getDisplayname()%></span>
                                </div>
                                <div class="row">
                                    <span style="font-size:15px; background: linear-gradient(to right, gold 0% <%=(int)((double)allRates.get(i).getRate()/5 * 100) %>%, #bdbdbd <%=(int)((double)allRates.get(i).getRate()/5 * 100)%>% 100%); color: #bdbdbd; -webkit-background-clip: text; -webkit-text-fill-color: transparent;">&#x2605;&#x2605;&#x2605;&#x2605;&#x2605;</span>
                                </div>
                                <div class="row">
                                    <p style="font-size:10px; color: gray; font-family: 'sans-serif'"><%=format.format(allRates.get(i).getTime())%></p>
                                </div>
                                <%if(!allRates.get(i).getComment().isEmpty()) {%>
                                <div class="row">
                                    <p><%=allRates.get(i).getComment()%></p>
                                </div>
                                <%}%>
                                <%if(!allRates.get(i).getContent().isEmpty()) {%>
                                <div class="row" style="display: flex">
                                    <%  int j = 0;
                                        for(InputStream in : allRates.get(i).getContent().keySet()) {
                                        if(allRates.get(i).getContent().get(in).startsWith("image")) {%>
                                    <script>
                                        function showImg(image) {
                                            let divCon = image.parentElement.parentElement.querySelector("#divshow");
                                            let img = divCon.querySelector("#show");
                                            let vid = divCon.querySelector("#vshow");
                                            if (img.name) {
                                                if (img.name === image.name) {
                                                    img.src = null;
                                                    img.name = null;
                                                    img.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                } else {
                                                    img.src = image.src;
                                                    img.name = image.name;
                                                    img.style = "overflow: hidden; max-width:300px; width:100% height: 100%; max-height: 300px";
                                                    if (vid) {
                                                        divCon.removeChild(vid);
                                                    }
                                                }
                                            } else {
                                                img.src = image.src;
                                                img.name = image.name;
                                                img.style = "overflow: hidden; max-width:300px; width:100% height: 100%; max-height: 300px";
                                                if (vid) {
                                                    divCon.removeChild(vid);
                                                }
                                            }
                                        }
                                    </script>

                                    <%
                                        
                                        byte[] ab3 = new byte[in.available()];
                                        in.read(ab3, 0, ab3.length);
                                    %>
                                    <img name="img-<%=j%>" onclick="showImg(this)" style="flex: 1; margin-left: 5px" src="data:<%=allRates.get(i).getContent().get(in)%>;base64,<%=ImageConverter.gI().encode(ab3)%>" width="100px" height="100px"/>
                                    <%} else {%>
                                    <script>
                                        function showVid(vid) {
                                            let divCon = vid.parentElement.parentElement.querySelector("#divshow");
                                            let img = divCon.querySelector("#vshow");
                                            let imgs = divCon.querySelector("#show");
                                            let image = vid.children[0];
                                            if (img) {
                                                if (img.name === vid.id) {
                                                    divCon.removeChild(img);
                                                } else {
                                                    img.name = vid.id;
                                                    img.children[0].src = image.src;
                                                    img.children[0].type = image.type;
                                                    if (imgs.name) {
                                                        imgs.src = null;
                                                        imgs.name = null;
                                                        imgs.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                    }
                                                }
                                            } else {
                                                img = document.createElement("video");
                                                img.preload = "metadata";
                                                img.controls = "controls";
                                                img.id = "vshow";
                                                img.name = vid.id;
                                                img.style = "max-width: 500px; max-height: 500px;";
                                                let src = document.createElement("source");
                                                src.src = image.src;
                                                src.type = image.type;
                                                img.appendChild(src);
                                                divCon.appendChild(img);
                                                if (imgs.name) {
                                                    imgs.src = null;
                                                    imgs.name = null;
                                                    imgs.style = "overflow: hidden; width: 0px; height: 0px; visibility: hidden;";
                                                }
                                            }
                                        }
                                    </script>
                                    <video id="vid-<%=j%>" onclick="showVid(this)" style="flex: 1; margin-left: 5px" width="100px" height="100px"/>

                                    <%
                                        
                                        byte[] ab4 = new byte[in.available()];
                                        in.read(ab4, 0, ab4.length);
                                    %>
                                    <source src="data:<%=allRates.get(i).getContent().get(in)%>;base64,<%=ImageConverter.gI().encode(ab4)%>" type="<%=allRates.get(i).getContent().get(in)%>">
                                    </video>
                                    <%}
                                    j++;
                                    }%>
                                </div>
                                <div class="row" id="divshow">
                                    <img id="show"/>
                                </div>
                                <%}%>
                            </div>
                        </div>
                    </div>
                    <%if(tempU.getName().equals(u.getName())) {%>
                    <a style="margin-left: 50vw; margin-top: 2vh; color: gray; font-size: 15px" class="fa fa-edit" href="index"></a>
                    <a style="margin-left: 0.25vw; color: red; font-size: 15px" href="index" class="fa fa-trash"></a>
                    <%}%>
                </div>
                <%}
                    }
                }%>
                <hr>
                <p>
                    <%
                    int pageN = 0;
                    if(pages != null) {
                        pageN = Integer.parseInt(pages);
                    }
                    %>
                    <script>
                        function changePage(page) {
                            if (page.value <= 0) {
                                return;
                            }
                        <%if(filterType != null) {%>
                            window.location.href = 'product?pid=<%=p.getProdId()%>&filter=<%=filterType%>&page=' + (page.value - 1);
                        <%}else {%>
                            window.location.href = 'product?pid=<%=p.getProdId()%>&page=' + (page.value - 1);
                        <%}%>
                        }
                    </script>
                    <%
                    if(filterType == null) {
                    %>
                    <button class="btn btn-success" style="background: #0B1E33;border: none; width: 5vw; margin-left: 27vw; margin-right: 0.5vw;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%><%=pageN == 0 ? "" : "&page="+(pageN-1)%>'"><</button>
                    <input class="text-center" style="width: 50px" type="number" value="<%=pageN == 0 ? 1 : pageN + 1%>" min="1" onchange="changePage(this)"/>
                    <button class="btn btn-success" style="background: #0B1E33;border: none; width: 5vw; margin-left: 0.5vw; " onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&page=<%=pageN+1%>'">></button>
                    <%} else {%>
                    <button class="btn btn-success" style="background: #0B1E33;border: none; width: 5vw; margin-left: 27vw; margin-right: 0.5vw;" onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=<%=filterType%><%=pageN == 0 ? "" : "&page="+(pageN-1)%>'"><</button>
                    <input class="text-center" style="width: 50px" type="number" value="<%=pageN == 0 ? 1 : pageN + 1%>" min="1" onchange="changePage(this)"/>
                    <button class="btn btn-success" style="background: #0B1E33;border: none; width: 5vw; margin-left: 0.5vw; " onclick="window.location.href = 'product?pid=<%=p.getProdId()%>&filter=<%=filterType%>&page=<%=pageN+1%>'">></button>
                    <%}%>
                </p>
            </div>
        </div>

        <br>
        <br>
        <br>

        <%@ include file="footer.html"%>

    </body>
</html>