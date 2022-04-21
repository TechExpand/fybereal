import 'dart:convert';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class BankProvider with ChangeNotifier {


  String baseUrl = '$mainurl/api/vendor';
  // String bearer = 'FLWSECK-71230ccbd14863ff68afb87741acdbec-X';

  List<Vendors> allBankList = [];
  // List<LGA> allLga = [];
  Vendors ?selectedBank;

  List<MenuModel>  menu = [];
  // LGA ?selectedLga;

setMenuEmpty(){
  menu = [];
  selectedBank2 = null;
  notifyListeners();
}

  List<CategoryModel> allBankList2 = [];
  // List<LGA> allLga = [];
  CategoryModel ?selectedBank2;


  Future<dynamic> getAllBank() async {
    try {
      var response = await http
          .get(Uri.parse(baseUrl)
          , headers: {
            "Content-type": "application/json",
            // 'Authorization': 'Bearer $bearer',
          });

      var body = json.decode(response.body);
      List body1 = body;
      List<Vendors> vendorList = body1.map((data) {
        return Vendors.fromJson(data);
      }).toList();

      allBankList = vendorList;
      print(allBankList);
      notifyListeners();
    } catch (e) {
      print(e);
      print('na error b tat');
    }
  }

  // changeBank(Bank services) {
  //   selectedService = services;
  //   print(selectedService.service);
  //   notifyListeners();
  // }
  //
  changeSelectedBank(Vendors bank) {
    selectedBank = bank;
    notifyListeners();
  }




  Future<dynamic> getAllBank2(vendorid) async {
    try {
      var response = await http
          .get(Uri.parse("$mainurl/api/category/$vendorid")
          , headers: {
            "Content-type": "application/json",
            // 'Authorization': 'Bearer $bearer',
          });

      var body = json.decode(response.body);
      List body1 = body;
      List<CategoryModel> catList = body1.map((data) {
        return CategoryModel.fromJson(data);
      }).toList();

      allBankList2 = catList;
      print(allBankList2);
      notifyListeners();
    } catch (e) {
      print(e);
      print('na error b tat');
    }
  }

  // changeBank(Bank services) {
  //   selectedService = services;
  //   print(selectedService.service);
  //   notifyListeners();
  // }
  //
  changeSelectedBank2(CategoryModel bank) {
    selectedBank2 = bank;
    notifyListeners();
  }






  Future getVendorMenu(vendorid, catid) async {
    try{
      var response = await http.get(
          Uri.parse(
              '$mainurl/api/vendormenu/${vendorid}/${catid}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': 'Token $token',
          }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);
      print(response.body.toString()+'lllllllll');
      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        menu = UsertransLists;
      } else {
        print('failed');
      }
    }catch (e) {
      print('na error be that');
    }
  }


}




