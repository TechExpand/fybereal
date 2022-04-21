

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorAdmin.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorList.dart';
import 'package:fybe/Screen/Admin/admin.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Screen/Home/Account.dart';
import 'package:fybe/Screen/Home/OrderHistory.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Screen/Home/TopUp.dart';
import 'package:fybe/Screen/Home/Wallet.dart';
import 'package:fybe/Screen/Vendor/SeeAllVendors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    final box = GetStorage();
    var  token = box.read('token');
    return SafeArea(
        child: Container(
          // decoration: BoxDecoration(
          //   image: Image.asset('name')
          // ),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Container(
                color: Color(0xFF0D833C),
                height: 120,
                child: Container(
                  margin: EdgeInsets.only(top: 18),
                  //alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(

                              child: Image.asset(
                                "assets/images/fybe.png",
                                fit: BoxFit.cover,
                              )),
                          Text('...Eat well-Vibe well...', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),)
                        ],
                      ),
                      token == null || token == 'null' || token == '' || token.isEmpty? InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return SignIn();
                              },
                              transitionsBuilder: (context,
                                  animation,
                                  secondaryAnimation,
                                  child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Login into your account',
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ): Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Hello! ${network.fullname}',
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              InkWell(
                  onTap: () async {
                  Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 40,
                    child: ListTile(
                      leading: Icon(Icons.home_outlined,
                          size: 25, color: Color(0xFF0D833C)),
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                      ),
                      minLeadingWidth: 10,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'HOME',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )),
              Divider(),

             network.myemail=="fybelogistics@gmail.com"?Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return  Admin();
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

                      },
                      child: SizedBox(
                        height: 45,
                        child: ListTile(
                          leading: Stack(
                            children: [
                              Icon(
                                  Icons.store_outlined,
                                  size: 25, color: Color(0xFF0D833C)),
                            ],
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          minLeadingWidth: 10,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'ADMIN',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )),
                  Divider(),
                ],
              ):Container(),

              InkWell(
                  onTap: () {
                    Navigator.push(
                       context,
                       PageRouteBuilder(
                         pageBuilder:
                             (context, animation, secondaryAnimation) {
                           return VendorSeeAll();
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

                  },
                  child: SizedBox(
                    height: 45,
                    child: ListTile(
                      leading: Stack(
                        children: [
                          Icon(
                              Icons.store_outlined,
                              size: 25, color: Color(0xFF0D833C)),
                        ],
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                      ),
                      minLeadingWidth: 10,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          'VENDORS',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )),
              Divider(),

              InkWell(
                onTap: () {
                  Navigator.push(
                     context,
                     PageRouteBuilder(
                       pageBuilder:
                           (context, animation, secondaryAnimation) {
                         return ShoppingCart();
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
                },
                child: SizedBox(
                  height: 45,
                  child: ListTile(
                    leading:
                    Icon(Icons.shopping_basket_outlined,
                        size: 25, color: Color(0xFF0D833C)),
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ),
                    minLeadingWidth: 10,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'SHOPPING BASKET',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),

              Column(
                children: [

                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Account();
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
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 45,
                        child: ListTile(
                          leading:
                          Icon(Icons.person_outline,
                              size: 25, color: Color(0xFF0D833C)),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          minLeadingWidth: 10,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'MY ACCOUNT',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )),
                  Divider(),
                ],
              ),

              Column(
                children: [

                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Wallet();
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
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 45,
                        child: ListTile(
                          leading:
                          Icon(Icons.account_balance_wallet_outlined,
                              size: 25, color: Color(0xFF0D833C)),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          minLeadingWidth: 10,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'WALLET',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )),
                  Divider(),
                ],
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return  OrderHistory();
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
                },
                child: SizedBox(
                  height: 40,
                  child: ListTile(
                    leading: Icon(Icons.task_alt_outlined,
                        size: 25,
                        color: Color(0xFF0D833C)),
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ),
                    minLeadingWidth: 10,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'ORDERS',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              Column(
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return TopUp();
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
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 45,
                        child: ListTile(
                          leading:
                          Icon(Icons.cached_sharp,
                              size: 25, color: Color(0xFF0D833C)),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          minLeadingWidth: 10,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'TOPUP',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )),
                  Divider(),
                ],
              ),

              token == null || token == 'null' || token == '' || token.isEmpty?Container(): GestureDetector(
                onTap: () async {
                  return showDialog(
                      context: context,
                      builder: (ctx) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AlertDialog(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(32.0))),
                            content: Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Oops!!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF0D833C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 15, bottom: 15),
                                        child: Center(
                                          child: Text(
                                            'DO YOU WANT TO LOGOUT?',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: [
                                        Material(
                                          borderRadius: BorderRadius.circular(26),
                                          elevation: 2,
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFF0D833C)),
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            child: FlatButton(
                                              onPressed: ()async{
                                                // SharedPreferences prefs = await SharedPreferences.getInstance();
                                                // prefs.clear();
                                                //ScaffoldMessenger.of(context).dispose();
                                                final box = GetStorage();
                                                box.erase();
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                      return SignIn(); //SignUpAddress();
                                                    },
                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                      (route) => false,
                                                );
                                              },
                                              color: Color(0xFF0D833C),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(26)),
                                              padding: EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(26)),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 190.0, minHeight: 53.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Yes",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          borderRadius: BorderRadius.circular(26),
                                          elevation: 2,
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFF0D833C)),
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Color(0xFF0D833C),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(26)),
                                              padding: EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(26)),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 190.0, minHeight: 53.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "No",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      });

                },
                child: SizedBox(
                  height: 45,
                  child: ListTile(
                    leading: Icon(Icons.logout,
                        size: 25, color: Color(0xFF0D833C)),
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ),
                    minLeadingWidth: 10,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
