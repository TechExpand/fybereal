import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Screen/Home/CheckOut.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:fybe/Widget/NumberSelection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<CartModel>? cart = [CartModel(name: 'loading')];
  Set vendorName = Set();

  getVendorName() {
    for (var value in cart!) {
      vendorName.add(value.menu?['vendor']['name']);
    }
  }




  calltransaction(context) async {
    total = 0;
    var network = Provider.of<WebServices>(context, listen: false);
    network.getUserCart().then((value) {
      setState(() {
        cart = value;
        if(cart?[0].name == "empty"){
          network.setCart("0");
        }else{
          network.setCart(cart?.length.toString());
          for (var value in cart!) {
            total = total +
                (int.parse(value.menu?['price'])*
                    int.parse(value.quantity.toString()));
          }
        }
      });
    });
  }

  recallTransaction(context) async {
    total = 0;
    var network = Provider.of<WebServices>(context, listen: false);
    network.getUserCart().then((value) {
      Navigator.pop(context);

      setState(() {
        cart = value;
        if(cart?[0].name == "empty"){
          network.setCart("0");
        }else{
          network.setCart(cart?.length.toString());
          for (var value in cart!) {
            total = total +
                (int.parse(value.menu?['price'])*
                    int.parse(value.quantity.toString()));
          }
        }
      });
    });
  }

  int total = 0;

  List<MenuModel>? menu;

  calltransaction4(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    network.getRecomend().then((value) {
      setState(() {
        menu = value;
      });
    });
  }



  @override
  void initState() {
    calltransaction4(context);
    calltransaction(context);
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      menu = null;
      cart = [CartModel(name: 'loading')];
      calltransaction4(context);
      calltransaction(context);
    });
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var  token = box.read('token');
    getVendorName();
    // getContainerFee();
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 84,
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Material(
                  elevation: 2,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Total: ₦$total',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF0D833C),
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: cart?[0].name=="loading"?(){

                }:() {
                  if (cart?.length == 0 || cart?[0].name=="empty") {
                    showTextToast(
                      text: 'Basket is empty, add an item into your basket.',
                      context: context,
                    );
                  } else if (cart?[0].name == "network" ||
                      menu?[0].name == "network") {
                    showTextToast(
                      text: 'Failed to checkout',
                      context: context,
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return CheckOut(
                              cart,
                              total,
                              vendorName.toString().substring(
                                  1, vendorName.toString().length - 1));
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
                  }
                },
                child: Container(
                  color: Color(0xFF0D833C),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        'CHECKOUT(${cart?.length == 0 || cart?[0].name=="empty"?0:cart?.length})',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF0D833C),
          title: Text('Shoping Basket'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left_sharp,
              size: 30,
            ),
          ),
        ),
        body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: token == null || token == 'null' || token == '' || token.isEmpty?
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/hungry.jpeg"),
                  Center(
                    child: Text("Login into your account",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 21,
                            height: 1.4,
                            fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(0xFF364B41)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(54.0),
                            ))),
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text('Login/Register'),
                    ),
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
                  )
                ],
              ),
            ):
            menu?[0].name == "network" || cart?[0].name == "network"
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/hungry.jpeg"),
                        Center(
                          child: Text("Loading Failed",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 21,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Center(
                          child: Text("Pull to refresh",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      Builder(builder: (context) {
                        return cart == null
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.asset(
                                      "assets/images/loader.gif",
                                      fit: BoxFit.cover,
                                    ),
                                    height: 70,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Loading',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ))

                                : cart!.isEmpty || cart?[0].name =="empty"
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                                "No Menu Available in Basket",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 21,
                                                    height: 1.4,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      )
                                    :  cart?[0].name == "loading"
                        ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/images/loader.gif",
                              fit: BoxFit.cover,
                            ),
                            height: 70,
                          ),
                        SizedBox(
                        height: 10,
                        ),
                        Text('Loading',
                        style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                        ],
                        )): Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: ListView.builder(
                                          itemCount: cart!.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            cart!.reversed;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    elevation: 2,
                                                    child: Container(
                                                        child: Row(children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 1.0,
                                                                    right: 1,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                '${cart![index].menu!['vendor']['name']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black26,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Container(
                                                              child:FadeInImage.memoryNetwork(
                                                                placeholder: kTransparentImage,
                                                                image: '${cart![index].menu?['image']}',fit: BoxFit.cover,),
                                                              width: 180.0,
                                                              height: 110.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            1.0,
                                                                            1.0),
                                                                    blurRadius:
                                                                        .3,
                                                                    spreadRadius:
                                                                        .3,
                                                                  ),
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            9),
                                                                    color: Colors.white70 ,
                                                                border: Border.all(
                                                                    width: 0.5,
                                                                    color: Colors
                                                                        .black12),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width:100,
                                                              child: Text(
                                                                '${cart![index].menu?['title']}',
                                                                style: GoogleFonts.openSans(
                                                                    fontSize: 15,
                                                                    color: Color(
                                                                        0xFF0D833C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                maxLines: 2,
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),

                                                            Text(
                                                              '₦${cart![index].menu?['price']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF0D833C),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100)),
                                                                height: 30,
                                                                width: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    cart![index]
                                                                        .quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ])),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      var network = Provider.of<
                                                              WebServices>(
                                                          context,
                                                          listen: false);
                                                      circularCustom(context);
                                                      network
                                                          .deleteUserCart(
                                                          cart![index].menu?['vendor'],
                                                              cart![index].menu?['_id'])
                                                          .then((value) {
                                                        setState(() {
                                                          recallTransaction(
                                                              context);
                                                        });
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.clear,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black26),
                                                      ),
                                                    ),
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                      }),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 160,
                            child: Builder(builder: (context) {
                              return menu == null
                                  ? Center(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            "assets/images/loader.gif",
                                            fit: BoxFit.cover,
                                          ),
                                          height: 70,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Loading',
                                            style: TextStyle(
                                                color: Color(0xFF0D833C),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ))
                                  : menu!.isEmpty || menu![0].name == "empty"
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text("No Recommendation Available",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 21,
                                                      height: 1.4,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder: (_, index) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) {
                                                          return ProductPage(
                                                            menu![index],
                                                            specialty:
                                                                'Recomended',
                                                          );
                                                        },
                                                        transitionsBuilder:
                                                            (context,
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
                                                  child: Container(
                                                    width: 170,
                                                    child: Card(
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            child: Container(
                                                                width: 170,
                                                                height: 100,
                                                                child:FadeInImage.memoryNetwork(
                                                                  placeholder: kTransparentImage,
                                                                  image: "${menu?[index].image}",fit: BoxFit.cover,),

                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        '${menu?[index].name}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14)),
                                                                    Text(
                                                                      '${menu?[index].vendortitle}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Color(0xFF0D833C)),
                                                                    )
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          3.0),
                                                                  child: Text(
                                                                      '₦${menu?[index].price}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: menu?.length,
                                          ),
                                        );
                            })),
                      ),
                    ],
                  )));
  }
}
