import 'dart:ui';

import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:fybe/Widget/NumberSelection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  ProductPage(this.data, {this.specialty});

  var specialty;
  var data;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<CartModel>? cart = [];

  calltransaction(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    network.getUserCart().then((value) {
      cart = value;
      if (cart?[0].name == "empty") {
        network.setCart("0");
      } else {
        network.setCart(cart?.length.toString());
      }
    });
  }

  recalltransaction(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    network.getUserCart().then((value) async {
      cart = value;
      if (cart?[0].name == "empty") {
        network.setCart("0");
      } else {
        network.setCart(cart?.length.toString());
      }
      Navigator.pop(context);
      await showTextToast(
        text: 'Successfully added to Cart.',
        context: context,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    calltransaction(context);
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: true);
    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
        floatingActionButton: StatefulBuilder(builder: (ctx, sets) {
          return FloatingActionButton.extended(
            onPressed: () {
              noteDialog() {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: AlertDialog(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          content: Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Note!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF3A843D),
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.63,
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 15),
                                      child:  Text(
                                          'Ordering from more than one restaurant will include an additional delivery fee per restaurant. would you like to continue?',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.3,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
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
                                              var network =
                                                  Provider.of<WebServices>(
                                                      context,
                                                      listen: false);
                                              final box = GetStorage();
                                              box.write('shown', "shown");
                                              Navigator.pop(context);
                                              circularCustom(context);
                                              network.AddCartUpload(
                                                vendor: widget.data.vendor,
                                                context: context,
                                                specialty: widget.specialty,
                                                menuID: widget.data.menu == null
                                                    ? widget.data.id
                                                    : widget.data.menu,
                                                quantity: quantity,
                                              ).then((value) {
                                                network.getProfile();
                                                setState(() {
                                                  recalltransaction(context);
                                                });
                                              });
                                            },
                                            color: Color(0xFF3A843D),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                            padding: EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          26)),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 190.0,
                                                    minHeight: 53.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Yes",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            color: Color(0xFF3A843D),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                            padding: EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          26)),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 190.0,
                                                    minHeight: 53.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "No",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
              }





              loginDialog() {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: AlertDialog(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                          content: Container(
                            height: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Note!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF3A843D),
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.63,
                                      padding:
                                      EdgeInsets.only(top: 15, bottom: 15),
                                      child:  Text(
                                        'Login into your account',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.3,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(26),
                                        elevation: 2,
                                        child: Container(
                                          height: 35,
                                          width: 220,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF3A843D)),
                                              borderRadius:
                                              BorderRadius.circular(26)),
                                          child: FlatButton(
                                            onPressed: () {
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
                                            color: Color(0xFF3A843D),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            padding: EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      26)),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 220.0,
                                                    minHeight: 53.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Login/Register",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:12.0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(26),
                                          elevation: 2,
                                          child: Container(
                                            height: 35,
                                            width: 220,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFF3A843D)),
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Color(0xFF3A843D),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(26)),
                                              padding: EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        26)),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 220.0,
                                                      minHeight: 53.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "cancel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
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
              }


              final box = GetStorage();
              var  token = box.read('token');

              if(token == null || token == 'null' || token == '' || token.isEmpty){
                loginDialog();
              }else{

              var network = Provider.of<WebServices>(context, listen: false);
              circularCustom(context);
              network.checkUserVendor(
                  vendor: widget.data.vendor,
                  context:context).then((value) async {
                final box = GetStorage();
                var shown = box.read('shown');
                if (shown == null ||
                    shown == 'null' ||
                    shown == '' ||
                    shown.isEmpty) {
                  if (value == true) {
                    print('sssss');
                    Navigator.pop(context);
                    noteDialog();
                  } else if (value == false) {
                    print('iiiiii');
                    network.AddCartUpload(
                      vendor: widget.data.vendor,
                      context: context,
                      specialty: widget.specialty,
                      menuID: widget.data.menu == null
                          ? widget.data.id
                          : widget.data.menu,
                      quantity: quantity,
                    ).then((value) {
                      network.getProfile();
                      setState(() {
                        recalltransaction(context);
                      });
                    });
                  }
                } else {
                  print('eeeee');
                  network.AddCartUpload(
                    vendor: widget.data.vendor,
                    context: context,
                    specialty: widget.specialty,
                    menuID: widget.data.menu == null
                        ? widget.data.id
                        : widget.data.menu,
                    quantity: quantity,
                  ).then((value) {
                    network.getProfile();
                    setState(() {
                      recalltransaction(context);
                    });
                  });
                }
              });
            }},
            label: Text(
              'ADD to BASKET',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xFF5D7567),
          );
        }),
        key: scaffoldKey,
        backgroundColor: const Color(0xfff7f7f7),
        appBar: AppBar(
          backgroundColor: Color(0xFF0D833C),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
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
                icon: Stack(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      size: 30,
                    ),
                    Container(
                      height: 17,
                      child: Center(
                          child: Text(
                        "${network.cart}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                      width: 17,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                    ),
                  ],
                ))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              size: 28,
            ),
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.width,
                  child:
                      Image.network('${widget.data.image}', fit: BoxFit.cover)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      )),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Text(
                              '${widget.data.name}',
                              style: GoogleFonts.openSans(
                                  fontSize: 27,
                                  color: Color(0xFF063D1C),
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '₦${widget.data.price}',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 400,
                              child: NumberSelection(
                                theme: NumberSelectionTheme(
                                  draggableCircleColor: Colors.white,
                                  iconsColor: Colors.white,
                                  numberColor: Color(0xFF0D833C),
                                  backgroundColor: Color(0xFF0D833C),
                                ),
                                initialValue: 1,
                                minValue: 1,
                                maxValue: 100,
                                direction: Axis.horizontal,
                                withSpring: true,
                                onChanged: (int value) {
                                  quantity = value;
                                },
                                enableOnOutOfConstraintsAnimation: true,
                                onOutOfConstraints: () =>
                                    print("This value is too high or too low"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8),
                                      child: Text(
                                        'Description',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF0D833C),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 80),
                                    child: Text(
                                      '${widget.data.description}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: Align(
                        //       alignment: Alignment.center,
                        //       child: Text('You may also want to add')),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
