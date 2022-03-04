class CompletedOrder {
  dynamic orderStatus;
  dynamic deliveryDate;
  dynamic timeSlot;
  dynamic paymentMethod;
  dynamic paymentStatus;
  dynamic paidByWallet;
  dynamic cartId;
  dynamic price;
  dynamic delCharge;
  dynamic remainingAmount;
  dynamic couponDiscount;
  dynamic deliveryBoyName;
  dynamic deliveryBoyPhone;
  dynamic vendorName;
  dynamic vendorId;
  dynamic address;
  dynamic vendorLoc;
  List<Data> data;
  ReviewRating reviewRating;

  CompletedOrder(
      {this.orderStatus,
        this.deliveryDate,
        this.timeSlot,
        this.paymentMethod,
        this.paymentStatus,
        this.paidByWallet,
        this.cartId,
        this.price,
        this.delCharge,
        this.remainingAmount,
        this.couponDiscount,
        this.deliveryBoyName,
        this.deliveryBoyPhone,
        this.vendorName,
        this.vendorId,
        this.address,
        this.vendorLoc,
        this.data,
        this.reviewRating});

  CompletedOrder.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'];
    deliveryDate = json['delivery_date'];
    timeSlot = json['time_slot'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    paidByWallet = json['paid_by_wallet'];
    cartId = json['cart_id'];
    price = json['price'];
    delCharge = json['del_charge'];
    remainingAmount = json['remaining_amount'];
    couponDiscount = json['coupon_discount'];
    deliveryBoyName = json['delivery_boy_name'];
    deliveryBoyPhone = json['delivery_boy_phone'];
    vendorName = json['vendor_name'];
    vendorId = json['vendor_id'];
    address = json['address'];
    vendorLoc = json['vendor_loc'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    reviewRating = (json['review_rating'] != null)?
         new ReviewRating.fromJson(json['review_rating'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status'] = this.orderStatus;
    data['delivery_date'] = this.deliveryDate;
    data['time_slot'] = this.timeSlot;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['paid_by_wallet'] = this.paidByWallet;
    data['cart_id'] = this.cartId;
    data['price'] = this.price;
    data['del_charge'] = this.delCharge;
    data['remaining_amount'] = this.remainingAmount;
    data['coupon_discount'] = this.couponDiscount;
    data['delivery_boy_name'] = this.deliveryBoyName;
    data['delivery_boy_phone'] = this.deliveryBoyPhone;
    data['vendor_name'] = this.vendorName;
    data['vendor_id'] = this.vendorId;
    data['address'] = this.address;
    data['vendor_loc'] = this.vendorLoc;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.reviewRating != null) {
      data['review_rating'] = this.reviewRating.toJson();
    }
    return data;
  }
}

class Data {
  dynamic storeOrderId;
  dynamic productName;
  dynamic quantity;
  dynamic unit;
  dynamic varientId;
  dynamic qty;
  dynamic price;
  dynamic totalMrp;
  dynamic orderCartId;
  dynamic orderDate;
  dynamic varientImage;
  dynamic addonName;
  dynamic addonId;
  dynamic addonPrice;
  dynamic description;

  Data(
      {this.storeOrderId,
        this.productName,
        this.quantity,
        this.unit,
        this.varientId,
        this.qty,
        this.price,
        this.totalMrp,
        this.orderCartId,
        this.orderDate,
        this.varientImage,
        this.addonName,
        this.addonId,
        this.addonPrice,
        this.description});

  Data.fromJson(Map<String, dynamic> json) {
    storeOrderId = json['store_order_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    unit = json['unit'];
    varientId = json['varient_id'];
    qty = json['qty'];
    price = json['price'];
    totalMrp = json['total_mrp'];
    orderCartId = json['order_cart_id'];
    orderDate = json['order_date'];
    varientImage = json['varient_image'];
    addonName = json['addon_name'];
    addonId = json['addon_id'];
    addonPrice = json['addon_price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_order_id'] = this.storeOrderId;
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['varient_id'] = this.varientId;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['total_mrp'] = this.totalMrp;
    data['order_cart_id'] = this.orderCartId;
    data['order_date'] = this.orderDate;
    data['varient_image'] = this.varientImage;
    data['addon_name'] = this.addonName;
    data['addon_id'] = this.addonId;
    data['addon_price'] = this.addonPrice;
    data['description'] = this.description;
    return data;
  }
}

class ReviewRating {
  dynamic id;
  dynamic cartId;
  dynamic userId;
  dynamic vendorId;
  dynamic review;
  dynamic rating;
  dynamic createdAt;

  ReviewRating(
      {this.id,
        this.cartId,
        this.userId,
        this.vendorId,
        this.review,
        this.rating,
        this.createdAt});

  ReviewRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    review = json['review'];
    rating = json['rating'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_id'] = this.cartId;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    return data;
  }
}
