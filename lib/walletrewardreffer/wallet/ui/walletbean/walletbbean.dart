

class WalletRechargeDetail{

  dynamic status;
  dynamic message;
  List<NormalPlanWallet> nornal_plan;
  List<OfferPlanWallet> offer_plan;

  WalletRechargeDetail(
      this.status, this.message, this.nornal_plan, this.offer_plan);

  factory WalletRechargeDetail.fromJson(dynamic json){
    var normalP = json['Nornal Plan'] as List;
    var offerP = json['Offer Plan'] as List;
    List<NormalPlanWallet> _tags = [];
    if(normalP!=null){
      _tags = normalP.map((tagJson) => NormalPlanWallet.fromJson(tagJson)).toList();
    }
    List<OfferPlanWallet> _tagd = [];
    if(offerP!=null){
      _tagd = offerP.map((tagJson) => OfferPlanWallet.fromJson(tagJson)).toList();
    }
    return WalletRechargeDetail(json['status'], json['message'], _tags, _tagd);
  }

  @override
  String toString() {
    return 'WalletRechargeDetail{status: $status, message: $message, nornal_plan: $nornal_plan, offer_plan: $offer_plan}';
  }
}

class NormalPlanWallet{

  dynamic plan_id;
  dynamic plans;

  NormalPlanWallet(this.plan_id, this.plans);

  factory NormalPlanWallet.fromJson(dynamic json){
    return NormalPlanWallet(json['plan_id'], json['plans']);
  }

  @override
  String toString() {
    return 'NormalPlanWallet{plan_id: $plan_id, plans: $plans}';
  }
}


class OfferPlanWallet{

  dynamic wallet_id;
  dynamic offer_amount;
  dynamic type;
  dynamic maximum_offer;
  dynamic offer_image;
  dynamic value;


  OfferPlanWallet(this.wallet_id, this.offer_amount, this.type,
      this.maximum_offer, this.offer_image, this.value);

  factory OfferPlanWallet.fromJson(dynamic json){
    return OfferPlanWallet(json['wallet_id'], json['offer_amount'], json['type'], json['maximum_offer'], json['offer_image'], json['value']);
  }

  @override
  String toString() {
    return 'OfferPlanWallet{wallet_id: $wallet_id, offer_amount: $offer_amount, type: $type, maximum_offer: $maximum_offer, offer_image: $offer_image, value: $value}';
  }
}