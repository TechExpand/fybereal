import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fl_toast/fl_toast.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Screen/Admin/RecomendaAdmin/RecomendedList.dart';
import 'package:fybe/Screen/Admin/SlideAdmin/SlideList.dart';
import 'package:fybe/Screen/Admin/TrendingAdmin/TrendignList.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/CartegoryVendor.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/MenuList.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorList.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Screen/Home/Home.dart';

String mainurl = "https://fybe.herokuapp.com";

class WebServices extends ChangeNotifier {
  String token = "";
  var path = '';
  String myemail = "";
  String fullname = "";
  String id = "";
  String cart = "0";
  String vendorID = "";
  int deliveryAmount = 0;
  int userDeliveryAmount = 0;
  String wallet = "0";

  setPath(value) {
    path = value;
    notifyListeners();
  }

  setWallet(value){
    wallet = value;
    notifyListeners();
  }

  setVendor(value) {
    vendorID = value;
    notifyListeners();
  }

  setCart(value) {
    cart = value;
    notifyListeners();
  }

  setToken(value) {
    token = value;
    notifyListeners();
  }

  final box = GetStorage();

  setInitials() {
    token = box.read('token');
    myemail = box.read('myemail');
    fullname = box.read('fullname');
    id = box.read('id');
    notifyListeners();
  }

  Future<dynamic> SignUp({context, email, password, fullname}) async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/signup'),
          body: jsonEncode(<String, String>{
            'email': email.toString(),
            'password': password.toString(),
            'fullname': fullname.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        this.fullname = body['fullname'];
        this.userDeliveryAmount = int.parse(body['deliveryfee'].toString());
        myemail = body['email'];
        token = body['token'];
        id = body['id'];
        box.write('token', token);
        box.write('myemail', myemail);
        box.write('fullname', this.fullname);
        box.write('id', id);

        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return MainHome();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else if (body.containsKey("message")) {

        Navigator.pop(context);
        await showTextToast(
          text: body['message'],
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'A Problem was Encountered.',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      Navigator.pop(context);
      print(e);
    }
  }

  Future<dynamic> updateFullName({context, fullname}) async {
    try {
      var response = await http.put(Uri.parse('$mainurl/api/profile'),
          body: jsonEncode(<String, String>{
            'name': fullname.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$token',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {


        this.fullname = body['name'];
        // box.write('token', token);
        // box.write('type', 'user');
        showTextToast(
          text: 'full name updated',
          context: context,
        );
      } else {

        await showTextToast(
          text: response.body,
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      print(e);
    }
  }




  Future<dynamic> getProfile() async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/profile'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$token',
          });
      print(response.body);

      var body = jsonDecode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        userDeliveryAmount = int.parse(body['deliveryfee'].toString());
      } else {
      }
      notifyListeners();
    }
    catch (e) {
      print(e);
    }
  }



  Future getTrends() async {
    try {
      var response = await http.get(Uri.parse('$mainurl/api/trend'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }



  Future getWallet() async {
      var response = await http.get(Uri.parse('$mainurl/api/wallet/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 50));
      var body = json.decode(response.body);
      Map body1 = body;
      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
         return body1;
      } else {
        return "failed";
      }
    }




  Future getCreditNotification() async {
    print(id);
    var response = await http.get(Uri.parse('$mainurl/api/credit/$id'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Authorization': 'Token $token',
    }).timeout(Duration(seconds: 20));
    var body = json.decode(response.body);
    Map body1 = body;

    notifyListeners();
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      return body1;
    } else {
      return "failed";
    }
  }




  Future getSlide() async {
    try {
      var response = await http.get(Uri.parse('$mainurl/api/slide'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future getRecomend() async {
    try {
      var response =
          await http.get(Uri.parse('$mainurl/api/recomend'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode <= 300) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [MenuModel(name: 'empty')];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future getVendors() async {
    try {
      var response = await http.get(Uri.parse('$mainurl/api/vendor'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<Vendors> UsertransLists = body1.map((data) {
        return Vendors.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<Vendors> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<Vendors> defaul = [Vendors(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<Vendors> defaul = [Vendors(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<Vendors> defaul = [Vendors(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future getVendorCategory(vendorid) async {
    try {
      var response = await http
          .get(Uri.parse('$mainurl/api/category/${vendorid}'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Token $token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<CategoryModel> UsertransLists = body1.map((data) {
        return CategoryModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<CategoryModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<CategoryModel> defaul = [CategoryModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<CategoryModel> defaul = [CategoryModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<CategoryModel> defaul = [CategoryModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }


  Future getWalletTransaction() async {
    try {
      var response = await http.get(
          Uri.parse('$mainurl/api/transaction/$id'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': 'Token $token',
          }).timeout(Duration(seconds: 50));
      var body = json.decode(response.body);

      List body1 = body;
      List<TransactionModel> UsertransLists = body1.map((data) {
        return TransactionModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<TransactionModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<TransactionModel> defaul = [TransactionModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<TransactionModel> defaul = [TransactionModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<TransactionModel> defaul = [TransactionModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }




  Future getVendorMenu(vendorid, catid) async {
    try {
      var response = await http.get(
          Uri.parse('$mainurl/api/vendormenu/${vendorid}/${catid}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': 'Token $token',
          }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }




  Future deleteUserCart(vendor,id) async {
    try {
      var response =
          await http.delete(Uri.parse('$mainurl/api/cartv2/${id}/${this.id}'),
              headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      }).timeout(Duration(seconds: 20));


      var body = json.decode(response.body);
      userDeliveryAmount = int.parse(body['deliveryfee'].toString());
      notifyListeners();
   print(int.parse(body['deliveryfee'].toString()));
      List body1 = body;
      List<CartModel> UsertransLists = body1.map((data) {
        return CartModel.fromJson(data);
      }).toList();


      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {

        return "done";
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future deleteTrends(id) async {
    try {
      var response =
          await http.delete(Uri.parse('$mainurl/api/trend/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }




  Future deleteCreditNotification(id) async {
      var response =
      await http.delete(Uri.parse('$mainurl/api/credit/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return 'done';
      } else {
        print('failed');
      }
  }



  Future deleteRecomend(id) async {
    try {
      var response =
          await http.delete(Uri.parse('$mainurl/api/recomend/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future deleteSlide(id) async {
    try {
      var response =
          await http.delete(Uri.parse('$mainurl/api/slide/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<MenuModel> UsertransLists = body1.map((data) {
        return MenuModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<MenuModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<MenuModel> defaul = [MenuModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future getUserCart() async {
    try {
      var response = await http.get(Uri.parse('$mainurl/api/cartv2/'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<CartModel> UsertransLists = body1.map((data) {
        return CartModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode <= 300) {
        if (UsertransLists.isEmpty) {
          List<CartModel> defaul = [
            CartModel(name: 'empty', quantity: "0", menu: {
              'price': "0",
              'vendor': {
                'name': '',
              },
            })
          ];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<CartModel> defaul = [CartModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }

  Future getDeliveryfee() async {
    try {
      var response =
          await http.get(Uri.parse('$mainurl/api/getamount/'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': '$token',
      });
      var body = json.decode(response.body);
      Map body1 = body;

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        deliveryAmount = body1['message'];
        notifyListeners();
      } else {
        print('failed');
      }
    } catch (e) {
      print('General Error: $e');
    }
  }

  Future getOrderHistory() async {
    try {
      var response = await http.get(Uri.parse('$mainurl/api/order/'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      }).timeout(Duration(seconds: 20));
      var body = json.decode(response.body);

      List body1 = body;
      List<OrderHistoryModel> UsertransLists = body1.map((data) {
        return OrderHistoryModel.fromJson(data);
      }).toList();

      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        if (UsertransLists.isEmpty) {
          List<OrderHistoryModel> defaul = [];
          return defaul;
        } else {

          return UsertransLists;
        }
      } else {
        print('failed');
      }
    } on TimeoutException catch (e) {
      List<OrderHistoryModel> defaul = [OrderHistoryModel(name: 'network')];
      return defaul;
    } on SocketException catch (e) {
      List<OrderHistoryModel> defaul = [OrderHistoryModel(name: 'network')];
      print('Socket Error: $e');
      return defaul;
    } on Error catch (e) {
      List<OrderHistoryModel> defaul = [OrderHistoryModel(name: 'network')];
      print('General Error: $e');
      return defaul;
    }
  }




  Future<dynamic> checkPaymentReferenceFundWallet({
    reference,
    context,
    amount,
  }) async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/fundwallet/$reference'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
            'email': myemail.toString(),
            'amount': amount.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
         showTextToast(
          text: "FUNDED SUCCESSFUL.",
          context: context,
        );
         setWallet(body['amount']);
      } else if (body.containsKey("message")) {

        await showTextToast(
          text: body['message'],
          context: context,
        );
      } else {

        await showTextToast(
          text: 'A Problem was Encountered.',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      print(e);
      await showTextToast(
        text: 'A Problem was Encountered.',
        context: context,
      );
    }
  }




  Future<dynamic> payWithWallet({
    context,
    phone,
    amount,
    nearestbusstop,
    vendor,
    deliverylocation,
    description,
  }) async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/wallet_orderv2/'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
            'email':myemail.toString(),
            'amount': amount.toString(),
            'phone': phone.toString(),
            'vendor': vendor.toString(),
            'description': description.toString(),
            'deliverylocation': deliverylocation.toString(),
            'nearestbusstop': nearestbusstop.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        Navigator.pop(context);
        setCart('0');
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return MainHome();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
              (route) => false,
        );
         showTextToast(
          text: "ORDER SUCCESSFUL.",
          context: context,
        );
      } else if (body.containsKey("message")) {
        Navigator.pop(context);
        await showTextToast(
          text: body['message'],
          context: context,
        );
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: 'A Problem was Encountered.',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      print(e);
      await showTextToast(
        text: 'A Problem was Encountered.',
        context: context,
      );
    }
  }


  Future<dynamic> checkPaymentReference({
    reference,
    context,
    phone,
    nearestbusstop,
    vendor,
    deliverylocation,
    description,
  }) async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/orderv2/$reference'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
            'phone': phone.toString(),
            'vendor': vendor.toString(),
            'description': description.toString(),
            'deliverylocation': deliverylocation.toString(),
            'nearestbusstop': nearestbusstop.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        setCart('0');
        await showTextToast(
          text: "ORDER SUCCESSFUL.",
          context: context,
        );
      } else if (body.containsKey("message")) {

        await showTextToast(
          text: body['message'],
          context: context,
        );
      } else {

        await showTextToast(
          text: 'A Problem was Encountered.',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      print(e);
      await showTextToast(
        text: 'A Problem was Encountered.',
        context: context,
      );
    }
  }

  Future<dynamic> Reset({context, email}) async {
    try {
      var response =
          await http.post(Uri.parse('$mainurl/api/reset?email=$email'),
              body: jsonEncode(<String, String>{
                'email': email.toString(),
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SignIn(data: 1);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        showTextToast(
          duration: Duration(seconds: 6),
          text: 'New Password has been sent to your Registered Email',
          context: context,
        );
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: body['message'],
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      Navigator.pop(context);
      await showTextToast(
        text: 'something went wrong',
        context: context,
      );
    }
  }





  Future<dynamic> checkUserVendor({vendor, context}) async {
    try {
      var response =
      await http.post(Uri.parse('$mainurl/api/vendor-verify'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
            'vendor': vendor.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      var body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
       return body['message'];
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: 'Failed to add to cart',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      await showTextToast(
        text: 'something went wrong',
        context: context,
      );
    }
  }












  Future<dynamic> Login({context, email, password}) async {
    try {
      var response = await http.post(Uri.parse('$mainurl/api/login'),
          body: jsonEncode(<String, String>{
            'email': email.toString(),
            'password': password.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(response.body);


      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        fullname = body['fullname'];
        myemail = body['email'];
        this.userDeliveryAmount = int.parse(body['deliveryfee'].toString());
        token = body['token'];
        id = body['id'];
        // box.write('token', token);
        box.write('token', token);
        box.write('myemail', myemail);
        box.write('fullname', fullname);
        box.write('id', id);

        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return MainHome();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else if (body.containsKey("message")) {

        Navigator.pop(context);
        await showTextToast(
          text: body['message'],
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'A Problem was Encountered.',
          context: context,
        );
      }
      notifyListeners();
    } catch (e) {

      Navigator.pop(context);

    }
  }

  // category
  Future<dynamic> CategoryUpload({
    context,
    categoryName,
    vendorID,
    vendorname,
  }) async {
    String imageName = '';
    try {
      var res = await http.post(Uri.parse('$mainurl/api/category'),
          body: jsonEncode(<String, String>{
            'title': categoryName.toString(),
            'vendor': vendorID.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });

      var body = jsonDecode(res.body);

      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return CartegoryList(vendorID, vendorname);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully uploaded a category.',
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      await showTextToast(
        text: 'There was a problem processing.',
        context: context,
      );
    }
    return imageName;
  }

  Future<dynamic> AddTrending({
    context,
    name,
    menu,
    description,
    price,
    path,
    vendorname,
    vendorID,
    categoryID,
  }) async {
    try {
      var res = await http.post(Uri.parse('$mainurl/api/trend'),
          body: jsonEncode(<String, String>{
            'category': categoryID.toString(),
            'vendor': vendorID.toString(),
            'title': name.toString(),
            'menu': menu.toString(),
            'description': description.toString(),
            'price': price.toString(),
            'image': path.toString(),
            'vendortitle': vendorname.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });
      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return TrendingList();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully added to Trends.',
          context: context,
        );
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }

      return 'done';
    } catch (e) {
      Navigator.pop(context);
      await showTextToast(
        text: 'upload failed.',
        context: context,
      );
    }
  }

  Future<dynamic> AddRecomend({
    context,
    name,
    description,
    price,
    menu,
    path,
    vendorname,
    vendorID,
    categoryID,
  }) async {
    try {
      var res = await http.post(Uri.parse('$mainurl/api/recomend'),
          body: jsonEncode(<String, String>{
            'category': categoryID.toString(),
            'vendor': vendorID.toString(),
            'title': name.toString(),
            'menu': menu.toString(),
            'description': description.toString(),
            'price': price.toString(),
            'image': path.toString(),
            'vendortitle': vendorname.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });
      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return RecomnededList();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully added to Trends.',
          context: context,
        );
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }

      return 'done';
    } catch (e) {
      Navigator.pop(context);
      await showTextToast(
        text: 'upload failed.',
        context: context,
      );
    }
  }

  Future<dynamic> AddCartUpload({context, menuID,vendor, specialty, quantity}) async {
    try {
      var res = await http.post(Uri.parse('$mainurl/api/cart'),
          body: jsonEncode(<String, String>{
            'user': id.toString(),
            'menu': menuID.toString(),
            "vendor": vendor.toString(),
            'specialty': specialty.toString(),
            'quantity': quantity.toString(),
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'Authorization': 'Bearer $bearer',
          });
      notifyListeners();


      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {
          return "done";
      } else {
        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }

      return 'done';
    } catch (e) {
      Navigator.pop(context);
      await showTextToast(
        text: 'upload failed.',
        context: context,
      );
    }
  }

  Future<dynamic> VendorUpload({
    context,
    name,
    specialty,
    location,
    end,
    start,
    path,
    deliveryfee,
    deliverytime,
  }) async {
    String imageName = '';
    try {
      var upload =
          http.MultipartRequest('POST', Uri.parse('$mainurl/api/vendor/'));
      // upload.headers['Authorization'] = 'Bearer $bearer';
      upload.headers['Content-type'] = 'application/json';
      var file = await http.MultipartFile.fromPath('image', path);
      upload.fields['name'] = name.toString();
      upload.fields['specialty'] = specialty.toString();
      upload.fields['end'] = end.toString().split(" ").join("");
      upload.fields['start'] = start.toString().split(" ").join("");
      upload.fields['deliverytime'] = deliverytime.toString();
      upload.fields['location'] = location.toString();
      upload.fields['deliveryfee'] = deliveryfee.toString();
      upload.files.add(file);

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);
      var body = jsonDecode(res.body);

      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return VendorList();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully uploaded a vendor.',
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      await showTextToast(
        text: 'There was a problem processing.',
        context: context,
      );
    }
    return imageName;
  }

  Future<dynamic> MenuUpload({
    context,
    name,
    description,
    price,
    path,
    vendorname,
    vendorID,
    categoryID,
    container,
    containerAmount,
  }) async {
    String imageName = '';
    try {
      var upload =
          http.MultipartRequest('POST', Uri.parse('$mainurl/api/menu/'));
      // upload.headers['Authorization'] = 'Bearer $bearer';
      upload.headers['Content-type'] = 'application/json';
      var file = await http.MultipartFile.fromPath('image', path);
      upload.fields['title'] = name.toString();
      upload.fields['vendortitle'] = vendorname.toString();
      upload.fields['price'] = price.toString();
      upload.fields['description'] = description.toString();
      upload.fields['vendor'] = vendorID.toString();
      upload.fields['category'] = categoryID.toString();
      upload.fields['container'] = container.toString();
      upload.fields['containerAmount'] = containerAmount.toString();
      upload.files.add(file);

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);
      var body = jsonDecode(res.body);
      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return MenuList(vendorID, categoryID, vendorname);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully uploaded a vendor.',
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      await showTextToast(
        text: 'There was a problem processing.',
        context: context,
      );
    }
    return imageName;
  }

  Future<dynamic> SlideUpload({
    context,
    path,
  }) async {
    String imageName = '';
    try {
      var upload =
          http.MultipartRequest('POST', Uri.parse('$mainurl/api/slide/'));
      // upload.headers['Authorization'] = 'Bearer $bearer';
      upload.headers['Content-type'] = 'application/json';
      var file = await http.MultipartFile.fromPath('image', path);
      upload.files.add(file);

      final stream = await upload.send();
      var res = await http.Response.fromStream(stream);
      var body = jsonDecode(res.body);
      notifyListeners();

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 202) {

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideList();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
        await showTextToast(
          text: 'Successfully uploaded a slide.',
          context: context,
        );
      } else {

        Navigator.pop(context);
        await showTextToast(
          text: 'upload failed.',
          context: context,
        );
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      await showTextToast(
        text: 'There was a problem processing.',
        context: context,
      );
    }
    return imageName;
  }

  Future searchV1({searchquery, context}) async {
    try {
      var response = await http
          .get(Uri.parse('$mainurl/api/search?search=$searchquery'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var body = json.decode(response.body);
      List result = body;
      List<Search> serviceList = result.map((data) {
        return Search.fromJson(data);
      }).toList();
      notifyListeners();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return serviceList;
      } else {
        showTextToast(
          text: 'search failed.',
          context: context,
        );
      }
    } catch (e) {
      showTextToast(
        text: 'search failed.',
        context: context,
      );
    }
  }
}

class NetworkError {
  String network;

  NetworkError({required this.network});
}
