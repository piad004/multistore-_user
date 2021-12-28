class OrderArray{

  int qty;
  int variant_id;


  OrderArray(this.qty, this.variant_id);

  @override
  String toString() {
    return '{\"qty\": $qty, \"variant_id\": $variant_id}';
  }
}

class OrderArrayGrocery{

  int qty;
  int varient_id;


  OrderArrayGrocery(this.qty, this.varient_id);

  @override
  String toString() {
    return '{\"qty\": $qty, \"varient_id\": $varient_id}';
  }
}



class OrderAdonArray{
  int addonid;

  OrderAdonArray(this.addonid);

  @override
  String toString() {
    return '{\"addon_id\": $addonid}';
  }
}