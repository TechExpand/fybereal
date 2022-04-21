import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class VendorPage extends StatefulWidget {
  var data;
  bool close;

  VendorPage(this.data, this.close);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VendorPageSTATE();
  }
}

class VendorPageSTATE extends State<VendorPage>
    with SingleTickerProviderStateMixin {
  late List<CategoryModel> category = [];
  List<MenuModel>? menu;


  List<CartModel> ?cart = [];




  calltransaction3(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getUserCart().then((value) {
        cart = value ;
        if(cart?[0].name == "empty"){
          network.setCart("0");
        }else{
          network.setCart(cart?.length.toString());
        }
    });
  }


  late TabController _tabController;
  late TabController _tabController1;

  int index = 0;
  int length = 0;

  calltransaction(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendorCategory(widget.data.id).then((value) {
      setState(() {
        category = value;
        _tabController =
            new TabController(length: category.length, vsync: ScaffoldState());
        calltransaction2(context, category[0].id);
      });
    });
  }

  calltransaction2(context, catID) async {
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendorMenu(widget.data.id, catID).then((value) {
      setState(() {
        menu = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    calltransaction(context);
    calltransaction3(context);
    _tabController1 = new TabController(length: 0, vsync: ScaffoldState());
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    var network = Provider.of<WebServices>(context, listen: true);
    return Scaffold(
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
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

                    Icon(Icons.shopping_basket_outlined, size: 30,),
                    Container(
                      height: 17,
                      child: Center(child: Text("${network.cart}",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),)),
                      width: 17,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                      ),
                    ),
                  ],
                ))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left_sharp,
              size: 28,
            ),
          ),
        ),
        body: DefaultTabController(
          length: 4,
          child: Container(
              child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                          "${widget.data.image}",
                          fit: BoxFit.cover)),
            widget.close?Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('CLOSED',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text('opens at: ${widget.data.start.toString()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ):Container()
                ],
              ),
              Material(
                elevation: 2,
                child: Container(
                    height: 90.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                '${widget.data.name}'.toString().toUpperCase(),
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: Color(0xFF063D1C),
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 220,
                                      child: Text(
                                        "${widget.data.location.toString()}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    Text(
                                      '${widget.data.specialty}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      'Delivery fee ₦${network.deliveryAmount}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5E816E),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Color(0xFF0D833C),
                                        ),
                                        Text(
                                          '${widget.data.deliverytime} mins',
                                          style: TextStyle(
                                            color: Color(0xFF0D833C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ]),
                    )),
              ),
             if(category.length != 0 && category[0].name !="network") Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Material(
                        elevation: 2,
                        child: TabBar(
                            controller: category == null
                                ? _tabController1
                                : _tabController,
                            onTap: (value) {
                              setState(() {
                                index = value;
                                calltransaction2(context, category[index].id);
                              });
                            },
                            indicatorColor: Color(0xFF0D833C),
                            isScrollable: true,
                            unselectedLabelColor: Colors.black38,
                            labelColor: Colors.black,
                            tabs: [
                                    for (var i in category)
                                      Tab(
                                          child: Text(
                                              i.name.toString().toUpperCase()))
                                  ]),
                      ),
                    ),
              if(category.length != 0)  ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:Text(
                              '${category[index].name=="network"?"":category[index].name}',
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38),
                              textAlign: TextAlign.left,
                            ),
                    ),
                  ),
                  Builder(builder: (context) {
                          return menu == null
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
                              : menu!.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text("No Menu Available",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 21,
                                                  height: 1.4,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return ProductPage(
                                                          menu?[index],
                                                          specialty: widget
                                                              .data.specialty);
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
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  elevation: 2,
                                                  child: Container(
                                                      child: Row(children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Container(
                                                        child:   FadeInImage.memoryNetwork(
                                                          placeholder: kTransparentImage,
                                                          image: "${menu?[index].image}",fit: BoxFit.cover,),
                                                        width: 140.0,
                                                        height: 90.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset:
                                                                  const Offset(
                                                                      1.0, 1.0),
                                                              blurRadius: .3,
                                                              spreadRadius: .3,
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              color: Colors.white70 ,
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black12),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 35.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 150,
                                                            child:  Text(
                                                              '${menu?[index].name}',
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFF0D833C),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              overflow:
                                                              TextOverflow
                                                                  .visible,
                                                            ),
                                                          ),

                                                          Text(
                                                            '₦${menu?[index].price}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ])),
                                                ),
                                              )),
                                        ),
                                        itemCount: menu?.length,
                                      ),
                                    );
                        }),
                ],
              ),
              if(category.length == 0)Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Loading...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              height: 1.4,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              )
            ],
          )),
        ));
  }


}
