//var imageBaseUrl = "https://project.primacyinfotech.com/multistore/";
var imageBaseUrl = "https://project.primacyinfotech.com/multistore/new/";
var baseUrl = imageBaseUrl+"api/";
var registerApi = Uri.parse(baseUrl + "user_register");
var verifyPhone = Uri.parse(baseUrl + "verify_phone");
var userRegistration = Uri.parse(baseUrl + "checkuser");
var userProfile = Uri.parse(baseUrl + "myprofile");
var forgotPassword = Uri.parse(baseUrl + "forgot_password");
var forgotPasswordVerify = Uri.parse(baseUrl + "verify_otp");
var changePassword = Uri.parse(baseUrl + "change_password");
var nearByStore = Uri.parse(baseUrl + "nearbystore");
var bannerUrl = (baseUrl + "adminbanner");
var categoryList = Uri.parse(baseUrl + "appcategory");
var subCategoryList = Uri.parse(baseUrl + "appsubcategory");
var productListWithVarient = Uri.parse(baseUrl + "appproduct");
var vendorUrl = Uri.parse(baseUrl + "vendorcategory");
var bestDealUrl = Uri.parse(baseUrl + "bestdeal");
var bestRatingUrl = Uri.parse(baseUrl + "bestrating");
var addToCart = Uri.parse(baseUrl + "order");
var timeSlots = Uri.parse(baseUrl + "timeslot");
var applyCoupon = Uri.parse(baseUrl + "apply_coupon");
var couponList = Uri.parse(baseUrl + "coupon_list");
var checkOut = Uri.parse(baseUrl + "checkout");
var addAddress = Uri.parse(baseUrl + "add_address");
var showAddress = Uri.parse(baseUrl + "show_address");
var area_city_charges = Uri.parse(baseUrl + "area_city_charges");
var selectAddress = Uri.parse(baseUrl + "select_address");
var removeAddress = Uri.parse(baseUrl + "remove_address");
var editAddress = Uri.parse(baseUrl + "edit_address");
var vendorBanner = Uri.parse(baseUrl + "vendorbanner");
var categoryBanner = (baseUrl + "categorybanner");
var onGoingOrdersUrl = Uri.parse(baseUrl + "ongoingorders");
var completeOrders = Uri.parse(baseUrl + "completed_orders1");
var cancelOrders = Uri.parse(baseUrl + "cancelorderhistory");
var cityList = Uri.parse(baseUrl + "city");
var areaLists = Uri.parse(baseUrl + "area");
var address_selection = Uri.parse(baseUrl + "address_selection");
var cancelReasonList = Uri.parse(baseUrl + "showcomplain");
var cancelOrderApi = Uri.parse(baseUrl + "cancel_order");
var rewardvalues = Uri.parse(baseUrl + "rewardvalues");
var search_keyword = Uri.parse(baseUrl + "search_keyword");
var after_order_reward_msg = Uri.parse(baseUrl + "after_order_reward_msg");
var rewardhistory = Uri.parse(baseUrl + "rewardhistory");
var redeem = Uri.parse(baseUrl + "redeem");
var showWalletAmount = Uri.parse(baseUrl + "showcredit");
var creditHistroy = Uri.parse(baseUrl + "credit_history");
var termcondition = Uri.parse(baseUrl + "termcondition");
var aboutus = Uri.parse(baseUrl + "aboutus");
var support = Uri.parse(baseUrl + "support");
var reffermessage = Uri.parse(baseUrl + "reffermessage");
var paymentvia = Uri.parse(baseUrl + "payment_gateways"); //vendor_id
var currencyuri = Uri.parse(baseUrl + "currency"); //vendor_id
var notificationlist = Uri.parse(baseUrl + "notificationlist"); //vendor_id
var dealproductUrl = Uri.parse(baseUrl + "dealproduct"); //vendor_id
var notificationby = Uri.parse(baseUrl + "notificationby"); //vendor_id
var promocode_regenerate = Uri.parse(baseUrl + "promocode_regenerate"); //vendor_id
var country_code = Uri.parse(baseUrl + "country_code"); //vendor_id
var wallet_plans = Uri.parse(baseUrl + "wallet_plans"); //vendor_id
var wallet_recharge = Uri.parse(baseUrl + "wallet_recharge"); //vendor_id
// resturant model
var resturant_banner = Uri.parse(baseUrl+"resturant_banner");
var homecategoryss = Uri.parse(baseUrl+"homecategory");
var popular_item = Uri.parse(baseUrl+"popular_item");
var returant_order = Uri.parse(baseUrl+"returant_order");
var orderplaced = Uri.parse(baseUrl+"orderplaced");
var order_cancel = Uri.parse(baseUrl+"order_cancel");
var resturantsearchingFor = Uri.parse(baseUrl+"resturantsearchingFor");
var user_completed_orders = Uri.parse(baseUrl+"user_completed_orders");
var user_cancel_order_history = Uri.parse(baseUrl+"user_cancel_order_history");
var user_ongoing_order = Uri.parse(baseUrl+"user_ongoing_order");

//pharmacy
var pharmacy_banner = Uri.parse(baseUrl+"pharmacy_banner");
var pharmacy_homecategory = Uri.parse(baseUrl+"pharmacy_homecategory");
var pharmacy_popular_item = Uri.parse(baseUrl+"pharmacy_popular_item");
var pharmacy_order = Uri.parse(baseUrl+"pharmacy_order");
var pharmacy_orderplaced = Uri.parse(baseUrl+"pharmacy_orderplaced");
var pharmacy_order_cancel = Uri.parse(baseUrl+"pharmacy_order_cancel");
var pharmacy_user_completed_orders = Uri.parse(baseUrl+"pharmacy_user_completed_orders");
var pharmacy_user_cancel_order_history = Uri.parse(baseUrl+"pharmacy_user_cancel_order_history");
var pharmacy_user_ongoing_order = Uri.parse(baseUrl+"pharmacy_user_ongoing_order");
var after_order_reward_msg_new = Uri.parse(baseUrl+"after_order_reward_msg_new");

// parcel
var parcel_banner = Uri.parse(baseUrl+"parcel_banner");
var parcel_detail = Uri.parse(baseUrl+"parcel_detail");//add to cart
var parcel_charges = Uri.parse(baseUrl+"parcel_charges");
var parcel_orderplaced = Uri.parse(baseUrl+"parcel_orderplaced");//checkout
var parcel_listcharges = Uri.parse(baseUrl+"parcel_listcharges");
var parcel_after_order_reward_msg = Uri.parse(baseUrl+"parcel_after_order_reward_msg");
var parcel_user_ongoing_order = Uri.parse(baseUrl+"parcel_user_ongoing_order");
var parcel_user_cancel_order = Uri.parse(baseUrl+"parcel_user_cancel_order");
var parcel_user_completed_order = Uri.parse(baseUrl+"parcel_user_completed_order");
var cancelOrderParcelApi = Uri.parse(baseUrl+"cancel_order_parcel");

//new api
var orderList = Uri.parse('${baseUrl}orderlist');
var firebase = Uri.parse('${baseUrl}firebase');
var verifyotpfirebase = Uri.parse('${baseUrl}verifyotpfirebase');
var resend_otp = Uri.parse('${baseUrl}resend_otp');
var mapByApi = Uri.parse('${baseUrl}show_map');


// note donot alter this one at any cost
var paymentApiUrl = Uri.parse('https://api.stripe.com/v1/payment_intents');
var orderApiRazorpay = Uri.parse('https://api.razorpay.com/v1/orders');

//paymongo api base
var baseUrlPaymongo = Uri.parse('api.paymongo.com');
var paymentIntent = Uri.parse('https://api.paymongo.com/v1/payment_intents');
var paymentMethod = Uri.parse('https://api.paymongo.com/v1/payment_methods');

var appname = "PimStore";
