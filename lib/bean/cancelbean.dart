class CancelProductList{

  dynamic res_id;
  dynamic reason;

  CancelProductList(this.res_id, this.reason);

  factory CancelProductList.fromJson(dynamic json){
    return CancelProductList(json['res_id'],json['reason']);
  }

  @override
  String toString() {
    return 'CancelProductList{res_id: $res_id, reason: $reason}';
  }
}