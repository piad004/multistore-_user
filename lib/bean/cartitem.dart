class CartItem{

  dynamic _id;
  dynamic product_name;
  dynamic qnty;
  dynamic price;
  dynamic unit;
  dynamic add_qnty;
  dynamic varient_id;
  dynamic product_img;

  CartItem(this._id, this.product_name, this.qnty, this.price, this.unit,
      this.add_qnty, this.varient_id, this.product_img);

  factory CartItem.fromJson(dynamic json){
    return CartItem(json['_id'], json['product_name'], json['qnty'], json['price'], json['unit'], json['add_qnty'], json['varient_id'], json['product_img']);
  }

  @override
  String toString() {
    return 'CartItem{_id: $_id, product_name: $product_name, qnty: $qnty, price: $price, unit: $unit, add_qnty: $add_qnty, varient_id: $varient_id, product_img: $product_img}';
  }
}