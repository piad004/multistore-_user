import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:user/Locale/languages.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Languages language = Languages();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': language.english(),
    'hi': language.hindi(),
    'es': language.spanish(),
  };


  String get alertloc11 {
    return _localizedValues[locale.languageCode]['alertloc11'];
  }

  String get presstoallow {
    return _localizedValues[locale.languageCode]['presstoallow'];
  }

  String get locationheading {
    return _localizedValues[locale.languageCode]['locationheading'];
  }

  String get locationheadingSub {
    return _localizedValues[locale.languageCode]['locationheadingSub'];
  }

  String get ok {
    return _localizedValues[locale.languageCode]['ok'];
  }

  String get externalwallet {
    return _localizedValues[locale.languageCode]['externalwallet'];
  }

  String get enteryouraddress {
    return _localizedValues[locale.languageCode]['enteryouraddress'];
  }

  String get selectlanguage {
    return _localizedValues[locale.languageCode]['selectlanguage'];
  }

  String get spanishh {
    return _localizedValues[locale.languageCode]['spanish'];
  }

  String get hindih {
    return _localizedValues[locale.languageCode]['hindi'];
  }

  String get englishh {
    return _localizedValues[locale.languageCode]['english'];
  }

  String get addressline1 {
    return _localizedValues[locale.languageCode]['addressline1'];
  }

  String get addressline2 {
    return _localizedValues[locale.languageCode]['addressline2'];
  }



  String get enteryourpincode {
    return _localizedValues[locale.languageCode]['enteryourpincode'];
  }

  String get housenotext {
    return _localizedValues[locale.languageCode]['housenotext'];
  }

  String get addaddresstext {
    return _localizedValues[locale.languageCode]['addaddresstext'];
  }

  String get selectaddresstypetext {
    return _localizedValues[locale.languageCode]['selectaddresstypetext'];
  }

  String get selectcitytext {
    return _localizedValues[locale.languageCode]['selectcitytext'];
  }

  String get othertext {
    return _localizedValues[locale.languageCode]['othertext'];
  }

  String get officetext {
    return _localizedValues[locale.languageCode]['officetext'];
  }

  String get addnewadd {
    return _localizedValues[locale.languageCode]['addnewadd'];
  }

  String get entermessage1 {
    return _localizedValues[locale.languageCode]['entermessage1'];
  }

  String get yourmessage {
    return _localizedValues[locale.languageCode]['yourmessage'];
  }

  String get phonenumber {
    return _localizedValues[locale.languageCode]['phonenumber'];
  }

  String get debitcard {
    return _localizedValues[locale.languageCode]['debitcard'];
  }

  String get credticard {
    return _localizedValues[locale.languageCode]['credticard'];
  }

  String get bodyText1 {
    return _localizedValues[locale.languageCode]['bodyText1'];
  }

  String get bodyText2 {
    return _localizedValues[locale.languageCode]['bodyText2'];
  }

  String get mobileText {
    return _localizedValues[locale.languageCode]['mobileText'];
  }

  String get validmobilenumber {
    return _localizedValues[locale.languageCode]['validmobilenumber'];
  }

  String get settingProgressMsg {
    return _localizedValues[locale.languageCode]['settingprogressmsg'];
  }

  String get settingheding {
    return _localizedValues[locale.languageCode]['settingheding'];
  }

  String get savetext {
    return _localizedValues[locale.languageCode]['savetext'];
  }

  String get notificationtext {
    return _localizedValues[locale.languageCode]['notificationtext'];
  }

  String get languagetext {
    return _localizedValues[locale.languageCode]['languagetext'];
  }

  String get settingsupdatedtext {
    return _localizedValues[locale.languageCode]['settingsupdatedtext'];
  }

  String get smstext {
    return _localizedValues[locale.languageCode]['smstext'];
  }

  String get emailtext {
    return _localizedValues[locale.languageCode]['emailtext'];
  }

  String get inapptext {
    return _localizedValues[locale.languageCode]['inapptext'];
  }

  String get continueText {
    return _localizedValues[locale.languageCode]['continueText'];
  }

  String get createNewAccountText {
    return _localizedValues[locale.languageCode]['createNewAccountText'];
  }

  String get fullNameText {
    return _localizedValues[locale.languageCode]['fullNameText'];
  }

  String get emailAddressText {
    return _localizedValues[locale.languageCode]['emailAddressText'];
  }

  String get applyreferralText {
    return _localizedValues[locale.languageCode]['applyreferralText'];
  }

  String get termsandconditionText1 {
    return _localizedValues[locale.languageCode]['termsandconditionText1'];
  }

  String get termsandconditionText2 {
    return _localizedValues[locale.languageCode]['termsandconditionText2'];
  }

  String get enteryourfullnameText {
    return _localizedValues[locale.languageCode]['enteryourfullnameText'];
  }

  String get valiedEmailText {
    return _localizedValues[locale.languageCode]['valiedEmailText'];
  }

  String get signUpText {
    return _localizedValues[locale.languageCode]['signUpText'];
  }

  String get verificationText {
    return _localizedValues[locale.languageCode]['verificationText'];
  }

  String get verifynumberText {
    return _localizedValues[locale.languageCode]['verifynumberText'];
  }

  String get otpcodeText {
    return _localizedValues[locale.languageCode]['otpcodeText'];
  }

  String get didnotrecivecodeText {
    return _localizedValues[locale.languageCode]['didnotrecivecodeText'];
  }

  String get resendCodeText {
    return _localizedValues[locale.languageCode]['resendCodeText'];
  }

  String get verifyText {
    return _localizedValues[locale.languageCode]['verifyText'];
  }

  String get gotDeliveredText {
    return _localizedValues[locale.languageCode]['gotDeliveredText'];
  }

  String get everythingYouNeedText {
    return _localizedValues[locale.languageCode]['everythingYouNeedText'];
  }

  String get noOfferText {
    return _localizedValues[locale.languageCode]['noOfferText'];
  }

  String get homeText {
    return _localizedValues[locale.languageCode]['homeText'];
  }

  String get orderText {
    return _localizedValues[locale.languageCode]['orderText'];
  }

  String get accountText {
    return _localizedValues[locale.languageCode]['accountText'];
  }

  String get updateText {
    return _localizedValues[locale.languageCode]['updateText'];
  }

  String get myAccount {
    return _localizedValues[locale.languageCode]['myAccount'];
  }

  String get savedAddresses {
    return _localizedValues[locale.languageCode]['savedAddresses'];
  }

  String get tnc {
    return _localizedValues[locale.languageCode]['tnc'];
  }

  String get support {
    return _localizedValues[locale.languageCode]['support'];
  }

  String get aboutUs {
    return _localizedValues[locale.languageCode]['aboutUs'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  String get walletText {
    return _localizedValues[locale.languageCode]['walletText'];
  }

  String get rewardsText {
    return _localizedValues[locale.languageCode]['rewardsText'];
  }

  String get referEarnText {
    return _localizedValues[locale.languageCode]['referEarnText'];
  }

  String get loggingOutText {
    return _localizedValues[locale.languageCode]['loggingOutText'];
  }

  String get areYouSureText {
    return _localizedValues[locale.languageCode]['areYouSureText'];
  }

  String get noText {
    return _localizedValues[locale.languageCode]['noText'];
  }

  String get yesText {
    return _localizedValues[locale.languageCode]['yesText'];
  }

  String get myOrdersText {
    return _localizedValues[locale.languageCode]['myOrdersText'];
  }

  String get ongoingText {
    return _localizedValues[locale.languageCode]['ongoingText'];
  }

  String get cancelledText {
    return _localizedValues[locale.languageCode]['cancelledText'];
  }

  String get completedText {
    return _localizedValues[locale.languageCode]['completedText'];
  }

  String get noOrderFoundText1 {
    return _localizedValues[locale.languageCode]['noOrderFoundText1'];
  }

  String get noOrderFoundText2 {
    return _localizedValues[locale.languageCode]['noOrderFoundText2'];
  }

  String get shopNowText {
    return _localizedValues[locale.languageCode]['shopNowText'];
  }

  String get fetchingOrdersText {
    return _localizedValues[locale.languageCode]['fetchingOrdersText'];
  }

  String get dateSlotText {
    return _localizedValues[locale.languageCode]['dateSlotText'];
  }

  String get someThingWentText {
    return _localizedValues[locale.languageCode]['someThingWentText'];
  }

  String get uploadprescriptionText {
    return _localizedValues[locale.languageCode]['uploadprescriptionText'];
  }


  String get uploadPhotoText {
    return _localizedValues[locale.languageCode]['uploadPhotoText'];
  }

  String get timeSlotText {
    return _localizedValues[locale.languageCode]['timeSlotText'];
  }

  String get fetchingTimeSlotText {
    return _localizedValues[locale.languageCode]['fetchingTimeSlotText'];
  }

  String get noTimeSlotText {
    return _localizedValues[locale.languageCode]['noTimeSlotText'];
  }

  String get deliveryAddressText {
    return _localizedValues[locale.languageCode]['deliveryAddressText'];
  }


  String get clickaddressText {
    return _localizedValues[locale.languageCode]['clickaddressText'];
  }

  String get placeOrderRequestText {
    return _localizedValues[locale.languageCode]['placeOrderRequestText'];
  }

  String get pleaseuploadlistText {
    return _localizedValues[locale.languageCode]['pleaseuploadlistText'];
  }

  String get pleaseselectaddressText {
    return _localizedValues[locale.languageCode]['pleaseselectaddressText'];
  }


  String get searchCategoryText {
    return _localizedValues[locale.languageCode]['searchCategoryText'];
  }

  String get noValueCartText {
    return _localizedValues[locale.languageCode]['noValueCartText'];
  }

  String get dealOfferZoneText {
    return _localizedValues[locale.languageCode]['dealOfferZoneText'];
  }

  String get noCategoryFoundStoreText {
    return _localizedValues[locale.languageCode]['noCategoryFoundStoreText'];
  }

  String get searchStoreText {
    return _localizedValues[locale.languageCode]['searchStoreText'];
  }

  String get storesFoundText {
    return _localizedValues[locale.languageCode]['storesFoundText'];
  }

  String get storesClosedText {
    return _localizedValues[locale.languageCode]['storesClosedText'];
  }

  String get noStoresFoundText {
    return _localizedValues[locale.languageCode]['noStoresFoundText'];
  }

  String get fetchingStoresText {
    return _localizedValues[locale.languageCode]['fetchingStoresText'];
  }

  String get inconvenienceNoticeText1 {
    return _localizedValues[locale.languageCode]['inconvenienceNoticeText1'];
  }

  String get inconvenienceNoticeText2 {
    return _localizedValues[locale.languageCode]['inconvenienceNoticeText2'];
  }

  String get clearText {
    return _localizedValues[locale.languageCode]['clearText'];
  }


  String get addText {
    return _localizedValues[locale.languageCode]['addText'];
  }

  String get viewCartText {
    return _localizedValues[locale.languageCode]['viewCartText'];
  }

  String get itemsText {
    return _localizedValues[locale.languageCode]['itemsText'];
  }

  String get noProductAvailableText {
    return _localizedValues[locale.languageCode]['noProductAvailableText'];
  }

  String get productSearchText {
    return _localizedValues[locale.languageCode]['productSearchText'];
  }

  String get outoffStockText {
    return _localizedValues[locale.languageCode]['outoffStockText'];
  }

  String get deliveryRangeText {
    return _localizedValues[locale.languageCode]['deliveryRangeText'];
  }

  String get addonsText {
    return _localizedValues[locale.languageCode]['addonsText'];
  }

  String get addonsaddproductText {
    return _localizedValues[locale.languageCode]['addonsaddproductText'];
  }

  String get parcelpagehedingText {
    return _localizedValues[locale.languageCode]['parcelpagehedingText'];
  }

  String get deliveringToText {
    return _localizedValues[locale.languageCode]['deliveringToText'];
  }

  String get doYouFindSomeText {
    return _localizedValues[locale.languageCode]['doYouFindSomeText'];
  }

  String get categoriesText {
    return _localizedValues[locale.languageCode]['categoriesText'];
  }

  String get productsOrderedText {
    return _localizedValues[locale.languageCode]['productsOrderedText'];
  }

  String get viewAllText {
    return _localizedValues[locale.languageCode]['viewAllText'];
  }

  String get storeText {
    return _localizedValues[locale.languageCode]['storeText'];
  }

  String get hotSaleText {
    return _localizedValues[locale.languageCode]['hotSaleText'];
  }

  String get productText {
    return _localizedValues[locale.languageCode]['productText'];
  }

  String get informationText {
    return _localizedValues[locale.languageCode]['informationText'];
  }

  String get goToCartText {
    return _localizedValues[locale.languageCode]['goToCartText'];
  }

  String get cartClearText {
    return _localizedValues[locale.languageCode]['cartClearText'];
  }

  String get confirmOrderText {
    return _localizedValues[locale.languageCode]['confirmOrderText'];
  }

  String get paymentInfoText {
    return _localizedValues[locale.languageCode]['paymentInfoText'];
  }

  String get subTotalText {
    return _localizedValues[locale.languageCode]['subTotalText'];
  }

  String get serviceFeeText {
    return _localizedValues[locale.languageCode]['serviceFeeText'];
  }

  String get amountPayText {
    return _localizedValues[locale.languageCode]['amountPayText'];
  }

  String get changeText {
    return _localizedValues[locale.languageCode]['changeText'];
  }

  String get clickShopNowText {
    return _localizedValues[locale.languageCode]['clickShopNowText'];
  }

  String get plsSelectDeliveryTimeText {
    return _localizedValues[locale.languageCode]['plsSelectDeliveryTimeText'];
  }

  String get payText {
    return _localizedValues[locale.languageCode]['payText'];
  }

  String get checkOutText {
    return _localizedValues[locale.languageCode]['checkOutText'];
  }

  String get cashText {
    return _localizedValues[locale.languageCode]['cashText'];
  }
  String get selectPymntMthdText {
    return _localizedValues[locale.languageCode]['selectPymntMthdText'];
  }

  String get onlinePaymentText {
    return _localizedValues[locale.languageCode]['onlinePaymentText'];
  }
  String get promoCodeText {
    return _localizedValues[locale.languageCode]['promoCodeText'];
  }
  String get stripeText {
    return _localizedValues[locale.languageCode]['stripeText'];
  }
  String get goToHomeText {
    return _localizedValues[locale.languageCode]['goToHomeText'];
  }
  String get orderPlacedText11 {
    return _localizedValues[locale.languageCode]['orderPlacedText1-1'];
  }
  String get orderPlacedText12 {
    return _localizedValues[locale.languageCode]['orderPlacedText1-2'];
  }
  String get orderPlacedText13 {
    return _localizedValues[locale.languageCode]['orderPlacedText1-3'];
  }

  String get orderPlacedText2 {
    return _localizedValues[locale.languageCode]['orderPlacedText2'];
  }

  String get vegetableText {
    return _localizedValues[locale.languageCode]['vegetableText'];
  }

  String get foodText {
    return _localizedValues[locale.languageCode]['foodText'];
  }

  String get meatText {
    return _localizedValues[locale.languageCode]['meatText'];
  }

  String get medicineText {
    return _localizedValues[locale.languageCode]['medicineText'];
  }

  String get petText {
    return _localizedValues[locale.languageCode]['petText'];
  }

  String get customText {
    return _localizedValues[locale.languageCode]['customText'];
  }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  String get cancelOrderReasonList {
    return _localizedValues[locale.languageCode]['Cancel Order Reason List'];
  }
  String get invoiceprint {
    return _localizedValues[locale.languageCode]['invoiceprint'];
  }
  String get cancel {
    return _localizedValues[locale.languageCode]['Cancel'];
  }
  String get pleaseSelectReasonToCancelTheProduct {
    return pleaseSe;
  }

  String get productNotCanceled {
    return _localizedValues[locale.languageCode]['Product not canceled.'];
  }
  String get productsNotFound {
    return _localizedValues[locale.languageCode]['Products not found'];
  }
  String get noValueInTheCart {
    return _localizedValues[locale.languageCode]['No Value in the cart!'];
  }
  String get searchItem {
    return _localizedValues[locale.languageCode]['Search item...'];
  }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>reference
  String get add {
    return addText;
  }
  String get noMoreStockAvailable {
    return _localizedValues[locale.languageCode]["No more stock available!"];
  }
  String get noDealFound {
    return _localizedValues[locale.languageCode]['No deal found!'];
  }
  String get loadingData {
    return _localizedValues[locale.languageCode]['Loading data.......'];
  }
  String get selectNearByArea {
    return _localizedValues[locale.languageCode]['Select near by area'];
  }

  String get loadingPleaseWait {
    return _localizedValues[locale.languageCode]['Loading please wait!....'];
  }
  String get enterAllDetailsCareFully{
    return _localizedValues[locale.languageCode]['Enter all details carefully'];
  }
  String get addressSavedSuccessfully{
    return _localizedValues[locale.languageCode]['Address Saved Successfully'];
  }
  String get editAddress{
    return _localizedValues[locale.languageCode]['Edit Address'];
  }
  String get updateAddress{
    return _localizedValues[locale.languageCode]['Update address'];
  }
  String get addressUpdatedSuccessfully{
    return _localizedValues[locale.languageCode]['Address updated Successfully'];
  }
  String get saveAddress{
    return savedAddresses;
  }
  String get noAddressFound{
    return _localizedValues[locale.languageCode]['No address found!'];
  }
  String get weAreNotDeliveryThisAddress{
    return _localizedValues[locale.languageCode]['We are not delivery this address'];
  }
  String get fetchingAddress{
    return _localizedValues[locale.languageCode]['Fetching address'];
  }
  String get unableToSelectAddress{
    return _localizedValues[locale.languageCode]['Unable to select address'];
  }
  String get pleaseTryAgain{
    return _localizedValues[locale.languageCode]['Please try again!'];
  }
  String get OrWriteUsYourQueries{
    return _localizedValues[locale.languageCode]['Or Write us your queries'];
  }
  String get yourWordsMeansALotToUs{
    return _localizedValues[locale.languageCode]['Your words means a lot to us.'];
  }
  String get submit{
    return _localizedValues[locale.languageCode]['Submit'];
  }
  String get pleaseEnterValidMobileNoAndMessage{
    return _localizedValues[locale.languageCode]['Please enter valid mobile no. and message is not less then 100 words'];
  }
  String get termsAndCondition{
    return _localizedValues[locale.languageCode]["Term and Condition"];
  }
  String get termsOfUse{
    return _localizedValues[locale.languageCode]['Terms of use'];
  }
  String get photoLibrary{
    return _localizedValues[locale.languageCode]['Photo Library'];
  }
  String get camera{
    return _localizedValues[locale.languageCode]['Camera'];
  }
  String get deliveryPartner{
    return _localizedValues[locale.languageCode]['Delivery Partner'];
  }
  String get deliveryBoyNotAssignYet{
    return _localizedValues[locale.languageCode]['Delivery boy not assigned yet'];
  }
  String get paymentInfo{
    return _localizedValues[locale.languageCode]['PAYMENT INFO'];
  }
  String get subTotal{
    return subTotalText;
  }

  String get couponDiscount{
    return _localizedValues[locale.languageCode]['Coupon Discount'];
  }
  String get paidByWallet{
    return _localizedValues[locale.languageCode]['Paid by wallet'];
  }
  String get paymentStatus{
    return _localizedValues[locale.languageCode]['Payment Status'];
  }
  String get cashOnDelivery{
    return _localizedValues[locale.languageCode]['Cash on Delivery'];
  }
  String get noNotificationFound{
    return _localizedValues[locale.languageCode]['No Notification found!'];
  }
  String get noItemAssociatedWithThisOrder{
    return _localizedValues[locale.languageCode]['No Items associated with this order'];
  }
  String get orderDate{
    return _localizedValues[locale.languageCode]['Order Date'];
  }
  String get orderStatus{
    return _localizedValues[locale.languageCode]['Order Status'];
  }
  String get paymentMethod{
    return _localizedValues[locale.languageCode]['Payment Method'];
  }
  String get timeSlot{
    return timeSlotText;
  }
  String get orderAmt{
    return _localizedValues[locale.languageCode]['Order Amt.'];
  }
  String get deliveryCharge{
    return _localizedValues[locale.languageCode]['deliverycharges'];
  }
  String get chargesToBePaid{
    return _localizedValues[locale.languageCode]['Charges To be paid'];
  }
  String get locationPermissionIsRequired{
    return _localizedValues[locale.languageCode]['Location permission is required!'];
  }
  String get enterLocation{
    return _localizedValues[locale.languageCode]['Enter Location'];
  }
  String get setDeliveryLocation{
    return _localizedValues[locale.languageCode]['Set delivery location'];
  }
  String get continueField{
    return _localizedValues[locale.languageCode]["Continue"];
  }
  String get walletAmount{
    return _localizedValues[locale.languageCode]['Wallet Amount'];
  }
  String get couponAmount{
    return _localizedValues[locale.languageCode]['Coupon Amount'];
  }
  String get orderAmount{
    return _localizedValues[locale.languageCode]['Order Amount'];
  }
  String get couponCodeNotApplicable{
    return _localizedValues[locale.languageCode]['coupon code not applicable!'];
  }
  String get apply{
    return _localizedValues[locale.languageCode]['Apply'];
  }
  String get placeOrder{
    return _localizedValues[locale.languageCode]['Place Order'];
  }
  String get proceedToPayment{
    return _localizedValues[locale.languageCode]['Proceed to payment'];
  }
  String get somethingWentwrong{
    return someThingWentText;
  }
  String get addressNotFound{
    return _localizedValues[locale.languageCode]["Address not found!"];
  }
  String get checkout{
    return checkOutText;//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  }
  String get senderAddress{
    return _localizedValues[locale.languageCode]['Sender Address'];
  }
  String get receiverAddress{
    return _localizedValues[locale.languageCode]['Receiver Address'];
  }
  String get parcelDescription{
    return _localizedValues[locale.languageCode]['Parcel Description'];
  }
  String get distaceInfo{
    return _localizedValues[locale.languageCode]['Distance Info'];
  }
  String get distace{
    return _localizedValues[locale.languageCode]['Distance'];
  }
  String get parcelCharges{
    return _localizedValues[locale.languageCode]['Parcel Charges'];
  }
  String get addressDetails{
    return _localizedValues[locale.languageCode]['Address detail\'s'];
  }
  String get senderName{
    return _localizedValues[locale.languageCode]['Sender Name'];
  }
  String get senderContactNo{
    return _localizedValues[locale.languageCode]['Sender Contact No.'];
  }
  String get address{
    return _localizedValues[locale.languageCode]['Address'];
  }
  String get houseNoAndFlatNo{
    return _localizedValues[locale.languageCode]['House No/Flat No'];
  }
  String get pinCode{
    return _localizedValues[locale.languageCode]['Pin Code'];
  }
  String get city{
    return _localizedValues[locale.languageCode]['City'];
  }
  String get landMark{
    return _localizedValues[locale.languageCode]['Landmark'];
  }
  String get state{
    return _localizedValues[locale.languageCode]['State'];
  }
  String get pleaseEnterAllDetailsToContinue{
    return _localizedValues[locale.languageCode]['please enter all details to continue!'];
  }
  String get order{
    return _localizedValues[locale.languageCode]['Order #'];
  }
  String get parcelDetailFrom{
    return _localizedValues[locale.languageCode]['Parcel detial\'s form'];
  }
  String get parcelWeight{
    return _localizedValues[locale.languageCode]['Parcel weight'];
  }
  String get KG{
    return _localizedValues[locale.languageCode]['KG'];
  }
  String get pickupDate{
    return _localizedValues[locale.languageCode]['Pickup date'];
  }
  String get pickupTime{
    return _localizedValues[locale.languageCode]['Pickup time'];
  }
  String get length{
    return _localizedValues[locale.languageCode]['Length'];
  }
  String get width{
    return _localizedValues[locale.languageCode]['Width'];
  }
  String get height{
    return _localizedValues[locale.languageCode]['Height'];
  }
  String get parcelDetail{
    return _localizedValues[locale.languageCode]['Parcel Detail'];
  }
  String get pleaseWaitWhileWeLoadingYourRequest{
    return _localizedValues[locale.languageCode]['please wait while we loading your request!'];
  }

  String get pleaseSelectAReasonToCancelTheProduct{
    return pleaseSe;
  }
  String get selectPaymentMethod{
    return selectPymntMthdText;
  }
  String get wallet{
    return walletText;
  }
  String get walletUsedAmount{
    return _localizedValues[locale.languageCode]['Wallet Used Amount'];
  }

  String get cash{
    return cashText;
  }
  String get onlinePayment{
    return onlinePaymentText;
  }
  String get promoCode{
    return promoCodeText;
  }
  String get receiverName{
    return _localizedValues[locale.languageCode]['Receiver Name'];
  }
  String get receiverContactNo{
    return _localizedValues[locale.languageCode]['Receiver Contact No.'];
  }
  String get pleaseWaitWhileWeSettingYourCart{
    return _localizedValues[locale.languageCode]['please wait while we setting your cart'];
  }
  String get weNotProvideServiceInThisArea{
    return _localizedValues[locale.languageCode]['we not provide service in this area!'];
  }
  String get pleaseSe{
    return _localizedValues[locale.languageCode]['Please select a reason to cancel the product!'];
  }
  String get enterYourPromoCode{
    return _localizedValues[locale.languageCode]["Enter Your promo code"];
  }
  String get addFirstProductToAddAddon{
    return _localizedValues[locale.languageCode]['Add first product to add addon!'];
  }
  String get addNewitem{
    return _localizedValues[locale.languageCode]['Add New Item'];
  }
  String get options{
    return _localizedValues[locale.languageCode]['Options'];
  }
  String get goToCart{
    return goToCartText;
  }
  String get storeClosedNow{
    return storesClosedText;
  }
  String get clear{
    return clearText;
  }
  String get no{
    return noText;
  }
  String get orderFromDifferentStoreInSingleOrderIsNotAllowed{
    return _localizedValues[locale.languageCode]["Order from different store in single order is not allowed. Sorry for inconvenience"];
  }
  String get inconvenienceNotice{
    return _localizedValues[locale.languageCode]["Inconvenience Notice"];
  }
  String get popularItems{
    return _localizedValues[locale.languageCode]['Popular Items'];
  }
  String get fetchingPopularItemPleaseWait{
    return _localizedValues[locale.languageCode]['Fetching popular item please wait...'];
  }
  String get noPopularItemFoundAtThisMoment{
    return _localizedValues[locale.languageCode]['No popular item found at this moment...'];
  }
  String get restaurant{
    return _localizedValues[locale.languageCode]["Restaurant"];
  }
  String get restaurantAreClosedNow{
    return _localizedValues[locale.languageCode]['Restaurant are closed now!'];
  }
  String get noStoreFoundAtYourLocation{
    return noStoresFoundText;
  }
  String get fetchingStores{
    return fetchingStoresText;//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  }
  String get productOrderList{
    return _localizedValues[locale.languageCode]["Product Ordered List"];
  }
  String get about{
    return _localizedValues[locale.languageCode]['About'];
  }
  String get deliveryBoy{
    return _localizedValues[locale.languageCode]['Delivery Boy'];
  }
  String get arrow{
    return _localizedValues[locale.languageCode]['arrow'];
  }
  String get rate{
    return _localizedValues[locale.languageCode]['Rate'];
  }
  String get code{
    return _localizedValues[locale.languageCode]['99+'];
  }
  String get fiveSix{
    return _localizedValues[locale.languageCode]['56'];
  }
  String get fourFive{
    return _localizedValues[locale.languageCode]['45'];
  }
  String get oneTwo{
    return _localizedValues[locale.languageCode]['12'];
  }
  String get five{
    return _localizedValues[locale.languageCode]['5'];
  }
  String get name{
    return _localizedValues[locale.languageCode]['name'];
  }
  String get review{
    return _localizedValues[locale.languageCode]['review'];
  }
  String get time{
    return _localizedValues[locale.languageCode]['time'];
  }
  String get foodAndMeals{
    return foodText;
  }
  String get exit{
    return _localizedValues[locale.languageCode]['Exit'];
  }
  String get search{
    return _localizedValues[locale.languageCode]['Search'];
  }
  String get history{
    return _localizedValues[locale.languageCode]['History'];
  }
  String get clearAll{
    return _localizedValues[locale.languageCode]['Clear all'];
  }
  String get viewMore{
    return _localizedValues[locale.languageCode]['View More'];
  }
  String get suggestions{
    return _localizedValues[locale.languageCode]['Suggestions'];
  }
  String get approximately123Result{
    return _localizedValues[locale.languageCode]['Approximately 134 results'];
  }
  String get searchProductOrStore{
    return _localizedValues[locale.languageCode]['Search Product or Store..'];
  }
  String get storeNotFound{
    return _localizedValues[locale.languageCode]['Store not found'];
  }
  String get addSomeProductIntoContinue{
    return _localizedValues[locale.languageCode]['Add some product into cart to continue!'];
  }
  String get variant{
    return _localizedValues[locale.languageCode]['Variant'];
  }
  String get description{
    return _localizedValues[locale.languageCode]['Description'];
  }
  String get inviteNEarn{
    return _localizedValues[locale.languageCode]['Invite n Earn'];
  }
  String get sahreYourCode{
    return _localizedValues[locale.languageCode]['Share your the code below or ask them to enter it during they signup. Earn when your friends signup on our app.'];
  }
  String get codeCpied{
    return _localizedValues[locale.languageCode]['Code Copied'];
  }
  String get tapTOCopy{
    return _localizedValues[locale.languageCode]['Tap to copy'];
  }
  String get generateYourSharedCodeFirst{
    return _localizedValues[locale.languageCode]['Generate your shared code first.'];
  }
  String get inviteFriends{
    return _localizedValues[locale.languageCode]['Invite Friends'];
  }
  String get noHistoryFound{
    return _localizedValues[locale.languageCode]['No history found!'];
  }
  String get rewardPoints{
    return _localizedValues[locale.languageCode]['Reward Points'];
  }
  String get redeem{
    return _localizedValues[locale.languageCode]['Redeem'];
  }
  String get earned{
    return _localizedValues[locale.languageCode]['Earned'];
  }
  String get zero{
    return _localizedValues[locale.languageCode]['0'];
  }
  String get spent{
    return _localizedValues[locale.languageCode]['Spent'];
  }
  String get have{
    return _localizedValues[locale.languageCode]['Have'];
  }
  String get sNo{
    return _localizedValues[locale.languageCode]['S No.'];
  }
  String get orderId{
    return orderPlacedText11;
  }
  String get rewardPoint{
    return _localizedValues[locale.languageCode]['Reward Point'];
  }
  String get fetchingRewardPoints{
    return _localizedValues[locale.languageCode]['Fetching reward points'];
  }
  String get walletHistory{
    return _localizedValues[locale.languageCode]['Wallet History'];
  }
  String get type{
    return _localizedValues[locale.languageCode]['Type'];
  }
  String get noWalletHistoryFound{
    return _localizedValues[locale.languageCode]["No wallet history found!.."];
  }
  String get fetchingWalletHistory{
    return _localizedValues[locale.languageCode]["Fetching wallet history"];
  }
  String get rechargeWallet{
    return _localizedValues[locale.languageCode]['Recharge Wallet'];
  }
  String get creditDebitCard{
    return _localizedValues[locale.languageCode]['Credit/Debit Card'];
  }
  String get onlinePayemnt{
    return onlinePaymentText;
  }
  String get myWallet{
    return _localizedValues[locale.languageCode]['My Wallet'];
  }
  String get walletBalane{
    return _localizedValues[locale.languageCode]['Wallet Balance'];
  }
  String get rechargePlan{
    return _localizedValues[locale.languageCode]['Recharge Plans'];
  }
  String get fetchingWalletAmount{
    return _localizedValues[locale.languageCode]['Fetching wallet amount'];
  }
  String get searchyourlocation{
    return _localizedValues[locale.languageCode]['searchyourlocation'];
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
