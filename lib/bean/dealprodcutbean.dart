class DealProductList {

  dynamic stock;
  dynamic price;
  dynamic deal_price;
  dynamic varient_image;
  dynamic quantity;
  dynamic unit;
  dynamic description;
  dynamic product_name;
  dynamic product_image;
  dynamic varient_id;
  dynamic product_id;
  dynamic valid_to;
  dynamic valid_from;
  dynamic timediff;
  dynamic hoursmin;
  dynamic add_qnty;

  DealProductList(
      this.stock,
      this.price,
      this.deal_price,
      this.varient_image,
      this.quantity,
      this.unit,
      this.description,
      this.product_name,
      this.product_image,
      this.varient_id,
      this.product_id,
      this.valid_to,
      this.valid_from,
      this.timediff,
      this.hoursmin,
      this.add_qnty);

  factory DealProductList.fromJson(dynamic json){
    return DealProductList(json['stock'], json['price'], json['dealprice'],json['varient_image'], json['quantity'], json['unit'], json['description'], json['product_name'], json['product_image'], json['varient_id'], json['product_id'], json['valid_to'], json['valid_from'], json['timediff'], json['hoursmin'],0);
  }

  @override
  String toString() {
    return 'DealProductList{stock: $stock, price: $price, varient_image: $varient_image, quantity: $quantity, unit: $unit, description: $description, product_name: $product_name, product_image: $product_image, varient_id: $varient_id, product_id: $product_id, valid_to: $valid_to, valid_from: $valid_from, timediff: $timediff, hoursmin: $hoursmin, add_qnty: $add_qnty}';
  }
}