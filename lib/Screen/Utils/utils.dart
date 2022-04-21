import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';


class Utils with ChangeNotifier {
  String randomNum = '';
  bool isExpanded = false;
  String fcmToken = '';
  bool isExpanded1 = true;
  bool isLoading = false;
  String nearestBusStop = "";



  setLoading(value){
    isLoading = value;
    notifyListeners();
  }


  setNearestBusStop(value){
    nearestBusStop = value;
    notifyListeners();
  }

  // static DateTime toDateTime(Timestamp value) {
  //   if (value == null) return null;
  //
  //   return value.toDate();
  // }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    randomNum = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return randomNum;
  }

  setFCMToken(value) {
    fcmToken = value;
    notifyListeners();
  }

  compareDate(date) {
    if(date == null || date.runtimeType.toString() == 'String'){
      return '...';
    }
    else{
      var value = formatYear(date.toDate());
      return value;
    }
  }


  compareDateChat(DateTime date) {
    if(date == null){
      return '...';
    }
    else if (date.difference(DateTime.now()).inHours.abs() <= 22) {
      var value = formatTime(date);
      return value;
    } else if (date.difference(DateTime.now()).inHours.abs() >= 22 &&
        date.difference(DateTime.now()).inHours.abs() <= 48) {
      var value = formatTime(date);
      return 'yesterday at $value';
    } else {
      var value = formatYear(date);
      return value;
    }
  }

  formatDate(DateTime now) {
    final DateFormat formatter = DateFormat('yyyy-MMMM-dd hh:mm');
    final String formatted = formatter.format(now);
    notifyListeners();
    return formatted;
  }

  formatTime(DateTime now) {
    final DateFormat formatter = DateFormat().add_jm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  formatYear(DateTime now) {
    final DateFormat formatter = DateFormat('yyyy/MMMM/dd');
    final String formatted = formatter.format(now==null?DateTime.now():now);
    return formatted;
  }


  late XFile selectedImage  =  XFile('');
  final picker = ImagePicker();
  Future selectimage({required ImageSource source, context}) async {
    var image = await picker.pickImage(source: source);
    selectedImage = image!;
    notifyListeners();
  }




  late XFile selectedImage2 =  XFile('');

  Future selectimage2({required ImageSource source, context}) async {
     var images = await picker.pickImage(source: source);
    selectedImage2 = images!;

    notifyListeners();
  }



  late XFile ediproductImage = XFile('');
  Future selectProductImage({required ImageSource source, context}) async {
    var images = await picker.pickImage(source: source);
    ediproductImage = images!;
    notifyListeners();
  }


  selectProductImagetoNull(){
    // ediproductImage = ;
    notifyListeners();
  }

  selectedImage2toNull(){
// selectedImage2 = null;
notifyListeners();
  }

}

extension CapExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String get capitalizeFirstOfEach =>
      this.split(" ").map((str) => str == "" ? "" : str.capitalize()).join(" ");
}

String formatCurrency(String country, double number) =>
    NumberFormat.simpleCurrency(name: country, decimalDigits: 2).format(number);

String formatDecimal(double number) =>
    NumberFormat('#########0.0').format(number);

String currencySymbol(String currencyCode) =>
    NumberFormat().simpleCurrencySymbol(currencyCode);
