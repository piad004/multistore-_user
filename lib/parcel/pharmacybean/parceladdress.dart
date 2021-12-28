
class ParcelAddress{
  dynamic houseno;
  dynamic pincode;
  dynamic city;
  dynamic landmark;
  dynamic address;
  dynamic state;
  dynamic lat;
  dynamic lng;
  dynamic sendername;
  dynamic sendercontact;
  dynamic areaName;
  dynamic areaid;
  dynamic areacharge;

  ParcelAddress(this.houseno, this.pincode, this.city, this.landmark,
      this.address, this.state,this.lat,this.lng,this.sendername,this.sendercontact,this.areaName,this.areaid,this.areacharge);

  @override
  String toString() {
    return 'Name : $sendername\nContact Number : $sendercontact\nHouse No : $houseno\nLandmark : $landmark\nAddress : $address\nArea : $areaName\nCity : $city\nState : $state ($pincode)';
  }
}