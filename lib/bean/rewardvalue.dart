class RewardValue {
  dynamic reedem_id;
  dynamic reward_point;
  dynamic value;

  RewardValue(this.reedem_id, this.reward_point, this.value);

  factory RewardValue.fromJson(dynamic json){
    return RewardValue(json['reedem_id'], json['reward_point'], json['value']);
  }

  @override
  String toString() {
    return 'RewardValue{reedem_id: $reedem_id, reward_point: $reward_point, value: $value}';
  }
}


class RewardHistory{
  dynamic reward_id;
  dynamic cart_id;
  dynamic total_amount;
  dynamic reward_points;
  dynamic user_id;
  dynamic created_at;

  RewardHistory(this.reward_id, this.cart_id, this.total_amount,
      this.reward_points, this.user_id, this.created_at);

  factory RewardHistory.fromJson(dynamic json){
    return RewardHistory(json['reward_id'], json['cart_id'], json['total_amount'], json['reward_points'], json['user_id'], json['created_at']);
  }

  @override
  String toString() {
    return 'RewardHistory{reward_id: $reward_id, cart_id: $cart_id, total_amount: $total_amount, reward_points: $reward_points, user_id: $user_id, created_at: $created_at}';
  }
}


class WalletHistory{
  dynamic wallet_id;
  dynamic amount;
  dynamic type;
  dynamic user_id;
  dynamic created_at;

  WalletHistory(this.wallet_id, this.amount, this.type, this.user_id, this.created_at);

  factory WalletHistory.fromJson(dynamic json){
    return WalletHistory(json['wallet_id'], json['amount'], json['type'], json['user_id'], json['created_at']);
  }

  @override
  String toString() {
    return 'RewardHistory{reward_id: $wallet_id, cart_id: $amount, total_amount: $type, user_id: $user_id, created_at: $created_at}';
  }
}

