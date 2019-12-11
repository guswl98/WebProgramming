<%@ page import = "java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%

String id=session.getAttribute("id").toString();


ArrayList<Integer> pid_list = new ArrayList<Integer>();
ArrayList<String> pname_list = new ArrayList<String>();
ArrayList<Integer> seller_list = new ArrayList<Integer>();
ArrayList<Double> price_list = new ArrayList<Double>();
ArrayList<Integer> status_list = new ArrayList<Integer>();
ArrayList<Integer> amount_list = new ArrayList<Integer>();

int total = 0;
int page_num = 1; 
int cur_page = 1; // start from 1 page
int cur_status = 0; // select all

// current item idx range
int cur_start = 1; 
int cur_end = 0;

int wish_num = 0; 
int cart_num = 0;

String seller_name = "";
String img_path = "";

if(request.getParameter("cur_page") != null){
    cur_page = Integer.parseInt(request.getParameter("cur_page"));
}

if(request.getParameter("cur_status") != null){
    cur_status = Integer.parseInt(request.getParameter("cur_status"));
}



%>


<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="description" content="">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

  <title>SKKU Flea Market | Product List</title>

  <!-- Favicon  -->
  <link rel="icon" href="img/core-img/favicon.ico">

  <link rel="stylesheet" href="css/core-style.css">
  <link rel="stylesheet" href="css/header-style.css">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="css/product_list-style.css">
</head>
<body>
     <%@ include file="header.jsp" %>

    <input type="hidden" id="cur_status" value="<%=cur_status%>">
    <%
    // cur_status : 0 - all, 1 - auction, 2 - in progress, 3 - sold out
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/final_project?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "root");

        String query = "Select * from product_info";

        /*if(cur_status > 0) {
            query += " where status=0";

        }*/


        PreparedStatement pst = conn.prepareStatement(query);
        ResultSet rs = pst.executeQuery();

        while(rs.next()){
            pid_list.add(rs.getInt("pid"));
            pname_list.add(rs.getString("name"));
            seller_list.add(rs.getInt("seller_id"));
            price_list.add(rs.getDouble("price"));
            status_list.add(rs.getInt("status"));
            amount_list.add(rs.getInt("amount"));
            total += 1;
        }

        page_num = total / 6 + 1; // total page number

    %>

    <input type="hidden" id="cur_page" value="<%=cur_page%>">

    <% 
    cur_start = (cur_page - 1) * 6 + 1;

    if(cur_page < page_num) { cur_end = cur_start + 5; }
    else if (cur_page == page_num){ cur_end = cur_start + total % 6 - 1; }

    //System.out.println("cur_page: " + cur_page);
    //System.out.println("cur_start: " + cur_start);
    //System.out.println("cur_end: " + cur_end);



    %>
	<div class="product-list-buyer-area">
        <div class="shop_sidebar_area">


            <!-- ##### Single Widget ##### -->
            <div class="widget brands mb-50">
                <!-- Widget Title -->
                <h6 class="widget-title mb-30">Status</h6>

                <div class="widget-desc">
                    <!-- Single Form Check -->
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="amado">
                        <label class="form-check-label" for="all">All</label>
                    </div>
                    <!-- Single Form Check -->
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="amado">
                        <label class="form-check-label" for="auction">Auction</label>
                    </div>
                    <!-- Single Form Check -->
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="ikea">
                        <label class="form-check-label" for="progress">SELLING</label>
                    </div>
                    <!-- Single Form Check -->
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="furniture">
                        <label class="form-check-label" for="sold_out">Sold Out</label>
                    </div>
                </div>
            </div>
            
        </div>

        <div class="area">
            <div class="container-fluid">

                <div class="row">
                    <div class="col-12">
                        <div class="product-topbar d-xl-flex align-items-end justify-content-between">
                            <!-- Total Products -->
                            <div class="total-products">
                                <p>Showing <%=cur_start%>-<%=cur_end%> 0f <%=total %></p>
                                <!--<div class="view d-flex">
                                    <a href="#"><i class="fa fa-th-large" aria-hidden="true"></i></a>
                                    <a href="#"><i class="fa fa-bars" aria-hidden="true"></i></a>
                                </div>-->
                            </div>

                            <!-- ##### Single Widget ##### -->
                            <div class="widget price">
                                <!-- Widget Title -->
                                <h6 class="widget-title">Price</h6>

                                <div class="widget-desc">
                                    <div class="slider-range">
                                        <div data-min="10" data-max="1000" data-unit="$" class="slider-range-price ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all" data-value-min="10" data-value-max="1000" data-label-result="">
                                            <div class="ui-slider-range ui-widget-header ui-corner-all"></div>
                                            <span class="ui-slider-handle ui-state-default ui-corner-all" tabindex="0"></span>
                                            <span class="ui-slider-handle ui-state-default ui-corner-all" tabindex="0"></span>
                                        </div>
                                        <div class="range-price">$10 - $1000</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Sorting -->
                            <div class="product-sorting d-flex">
                                <div class="sort-by-date d-flex align-items-center mr-15">
                                    <p>Sort by</p>
                                    <form action="#" method="get">
                                        <select name="select" id="sortBydate">
                                            <option value="value">Newest</option>
                                            <option value="value">Price</option>
                                            <option value="value">Popular</option>
                                        </select>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">

                    <%
                    for(int i = cur_start - 1; i < cur_end; i++){

                
                    %>
                    <!-- Single Product Area -->
                    <div class="col-12 col-sm-6 col-md-12 col-xl-6">
                        <div class="single-product-wrapper">
                            <!-- Product Image -->
                            <div class="product-img">
                                <% 
                                PreparedStatement img_pst = conn.prepareStatement("Select * from img_info where pid=?");
                                img_pst.setInt(1, pid_list.get(i));
                                ResultSet img_rs = img_pst.executeQuery();
                                if(img_rs.next()) {img_path = img_rs.getString("path"); }
                                %>
                                <img src="<%=img_path%>" alt="">
                                <!-- Hover Thumb -->
                                <!--<img class="hover-img" src="img/product-img/product2.jpg" alt="">-->
                            </div>

                            <!-- Product Description -->
                            <div class="product-description d-flex align-items-center justify-content-between">
                                <!-- Product Meta Data -->
                                <div class="product-meta-data">
                                    <div class="line"></div>
                                    <div class="product-status-name">
                                        <% if(status_list.get(i) == 0){%>
                                        <p class="product-status" style="color: blue; ">AUCTION</p>
                                        <%}
                                        if(status_list.get(i) == 1){%>
                                        <p class="product-status">IN PROGRESS</p>
                                        <%}
                                        if(status_list.get(i) == 2){%>
                                        <p class="product-status" style="color: red;">SOLD OUT</p>
                                        <%}%>

                                        <a href="product-details.jsp?pid=<%=pid_list.get(i)%>" class="product-name">
                                            <p><%= pname_list.get(i)%></p>
                                        </a>
                                    </div>
                                    <div class="product-price-seller">
                                        <p class="product-price">$<%= price_list.get(i)%></p>
                                        <% 
                                        PreparedStatement seller_pst = conn.prepareStatement("Select * from user_info where uid=?");
                                        seller_pst.setInt(1, seller_list.get(i));
                                        ResultSet seller_rs = seller_pst.executeQuery();
                                        if(seller_rs.next()) seller_name = seller_rs.getString("id");
                                        %>
                                        <p class="product-seller"><%=seller_name%></p>
                                    </div>
                                </div>
                                <!-- Ratings & Cart -->
                                <div class="ratings-cart text-right">
                                    <div class="wish">
                                        <% 
                                        PreparedStatement wish_pst = conn.prepareStatement("Select * from wish_cart_info where prod_id=?");
                                        wish_pst.setInt(1, pid_list.get(i));
                                        ResultSet wish_rs = wish_pst.executeQuery();
                                        wish_num = 0;
                                        while(wish_rs.next()){ 
                                            if(wish_rs.getInt("status") == 0) wish_num += 1; 
                                        }
                                        %>
                                        <p><%=wish_num%></p>
                                        <a href="cart.html" data-toggle="tooltip" data-placement="left" title="Add to wish list"><img src="img/core-img/wish-star.png" alt=""></a>
                                    </div>
                                    <div class="cart_">
                                        <% 
                                        PreparedStatement cart_pst = conn.prepareStatement("Select * from wish_cart_info where prod_id=?");
                                        cart_pst.setInt(1, pid_list.get(i));
                                        ResultSet cart_rs = cart_pst.executeQuery();
                                        cart_num = 0;
                                        while(cart_rs.next()){ 
                                            if(cart_rs.getInt("status") == 1) cart_num += 1; 
                                        }
                                        %>
                                        <p><%=cart_num%></p>
                                        <a href="cart.html" data-toggle="tooltip" data-placement="left" title="Add to Cart"><img src="img/core-img/cart.png" alt=""></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } 
                    if(cur_end % 2 == 1){
                        %> <div class="col-12 col-sm-6 col-md-12 col-xl-6"> </div>
                    <%}
                    %>

                    
                </div>

                <div class="row">
                    <div class="col-12">
                        <!-- Pagination -->
                        <nav aria-label="navigation">
                            <ul class="pagination justify-content-end mt-50">
                                <% for(int i = 1; i <= page_num; i++) {
                                    if(i != cur_page) {
                                %>
                                    <li class="page-item"><a class="page-link" href="product_list_buyer.jsp?cur_page=<%=i%>">0<%=i%>.</a></li>
                                <% }
                                    else{ %>
                                    <li class="page-item active"><a class="page-link" href="product_list_buyer.jsp?cur_page=<%=i%>">0<%=i%>.</a></li>
                                <%} }%>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    </div>
    <!-- ##### Main Content Wrapper End ##### -->

    <!-- ##### Footer Area Start ##### -->
    <footer class="footer_area">
        <div class="container">
            <div class="row align-items-center">
                <!-- Single Widget Area -->
                <div class="col-12 col-lg-4">
                    <div class="single_widget_area">
                        <!-- Logo -->
                        <div class="footer-logo mr-50">
                            <a href="index.html"><img src="img/core-img/logo2.png" alt=""></a>
                        </div>
                        <!-- Copywrite Text -->
                        <p class="copywrite"><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                    </div>
                </div>
                <!-- Single Widget Area -->
                <div class="col-12 col-lg-8">
                    <div class="single_widget_area">
                        <!-- Footer Menu -->
                        <div class="footer_menu">
                            <nav class="navbar navbar-expand-lg justify-content-end">
                                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#footerNavContent" aria-controls="footerNavContent" aria-expanded="false" aria-label="Toggle navigation"><i class="fa fa-bars"></i></button>
                                <div class="collapse navbar-collapse" id="footerNavContent">
                                    <ul class="navbar-nav ml-auto">
                                        <li class="nav-item active">
                                            <a class="nav-link" href="index.html">Home</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="Product_list_seller.html">Product List (Seller)</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="product-details.html">ëì¤ì ì¹´íê³ ë¦¬ ìì í ì í´ì§ë©´ ê³ ì¹¨</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="cart.html">Cart</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="checkout.html">Checkout</a>
                                        </li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- ##### Footer Area End ##### -->

    <!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="js/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap.min.js"></script>
    <!-- Plugins js -->
    <script src="js/plugins.js"></script>
    <!-- Active js -->
    <script src="js/active.js"></script>


</body>
</html>
<% 
    rs.close();
    conn.close();

} catch(Exception e) {
	out.println("Something went wrong !! Please try again");
}
%>