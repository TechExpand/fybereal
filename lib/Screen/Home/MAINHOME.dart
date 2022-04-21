import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fybe/Screen/Home/Home.dart';
import 'package:fybe/Screen/Home/OrderHistory.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:new_version/new_version.dart';

import 'Account.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showVersionChecker(context);
  }


  _showVersionChecker (BuildContext context){
    try{
      NewVersion(
        iOSId: 'com.fybe',//dummy IOS bundle ID
        androidId: 'com.fybe.fybe',//dummy android ID
      ).showAlertIfNecessary(context: context);
    }catch(e){
      debugPrint("error=====>${e.toString()}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Container(
        decoration: BoxDecoration(
            color: Color(0xFF0D833C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )
        ),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // showSelectedLabels: true,
          // showUnselectedLabels: true,
          // unselectedLabelStyle: TextStyle(fontSize: 14),
          // backgroundColor: Color(0xFF0D833C),
          children: [
            Tab(
                iconMargin: EdgeInsets.zero,
                child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 14, ),),
                icon: Icon(Icons.home_outlined,color:Colors.white)),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation,
                        secondaryAnimation) {
                      return ShoppingCart();
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
              child: Tab(
                iconMargin: EdgeInsets.zero,
                  // backgroundColor: Color(0xFF0D833C),
                  child: Text('Basket', style: TextStyle(color: Colors.white, fontSize: 14, ),),
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.shopping_basket_outlined,color:Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation,
                        secondaryAnimation) {
                      return OrderHistory();
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
              child: Tab(
                  iconMargin: EdgeInsets.zero,
                  child: Text('Orders', style: TextStyle(color: Colors.white, fontSize: 14, ),),
                  icon: Icon(Icons.task_alt_outlined,color:Colors.white)),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation,
                        secondaryAnimation) {
                      return Account();
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
              child: Tab(
                iconMargin: EdgeInsets.zero,
                  child: Text('My Account', style: TextStyle(color: Colors.white, fontSize: 14, ),),
                  icon: Icon(Icons.person_outline,color:Colors.white)),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          showDialog(
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
                                color: Color(0xFF3A843D),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Center(
                                  child: Text(
                                    'DO YOU WANT TO EXIT THIS APP?',
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
                                            color: Color(0xFF3A843D)),
                                        borderRadius:
                                        BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        exit(0);
                                      },
                                      color: Color(0xFF3A843D),
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
                                            color: Color(0xFF3A843D)),
                                        borderRadius:
                                        BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color:Color(0xFF3A843D),
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
          return true;
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Home(),
            // ShoppingCart(),
            // OrderHistory(),
            // Account(),
          ],
        ),
      ),
    );
  }
}
