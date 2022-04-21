

import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Screen/Home/Search.dart';
import 'package:fybe/Widget/generalBuild.dart';
import 'package:intl/intl.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Screen/Vendor/SeeAllTrending.dart';
import 'package:fybe/Screen/Vendor/SeeAllVendors.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();


  List<CartModel> ?cart = [];
  List<MenuModel> ?menu;
  List<MenuModel> slide = [];

  calltransaction5(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getSlide().then((value) {
      setState(() {
        slide = value ;
      });
    });
  }

  calltransaction4(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getTrends().then((value) {
      setState(() {
        menu = value ;
      });
    });
  }




  String foodTime() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'BREAKFAST?';
    }
    if (hour < 17) {
      return 'LUNCH?';
    }
    return 'DINNER?';
  }

  bool determineClosed(start, end){
    var value = false;
     var hour = DateTime.now().hour;
     var df =  DateFormat("h:mma");

     var formatedEndTime = df.parse(end.toString().toUpperCase()).hour;
    // var formatedEndTime =  DateFormat('h').format(enddt);

     var formatedStartTime = df.parse(start.toString().toUpperCase()).hour;
     // var formatedStartTime =  DateFormat('h').format(startdt);

    if(hour > formatedEndTime || hour <   formatedStartTime){
      value = true;
      print(hour);
      print(formatedStartTime);
    }else{
      value = false;
    }
    return value;
  }


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

  List<Vendors> ?vendors;
  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendors().then((value) {
      setState(() {
        vendors = value ;
      });
    });
  }




  callCredit(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getCreditNotification().then((value) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        checkMessageDialog(value)async{
          generalGuild(
            showdot: true,
            context: context,
            message:
            """${value["message"]}.""",
            opacity: 0.9,
            height: 55.0,
            alignment: Alignment.topRight,
            whenComplete: () {
               network.deleteCreditNotification(value['_id']);
            },
          );
        }
       if(value["message"] == "empty"){

       }else{
         checkMessageDialog(value);
       }
      });

    });
  }



  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      vendors = null;
      menu = null;
      calltransaction3(context);
      calltransaction(context);
      calltransaction4(context);
      calltransaction5(context);
    });

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    print('doneeeeeeeeeeeeee');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }


  @override
  void initState(){
    super.initState();

    callCredit(context);
    calltransaction3(context);
    calltransaction(context);
    calltransaction4(context);
    calltransaction5(context);
    var network = Provider.of<WebServices>(context, listen: false);
    network.getProfile();
  }
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: true);
    return Scaffold(
      backgroundColor:Colors.white,
      key: _scaffoldkey,
    drawer: SizedBox(
      width: 250,
      child: Drawer(
        elevation: 0,
        child: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors.white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: DrawerWidget()),
      ),
    ),
        body: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView(
              physics: ScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.asset(
                        "assets/images/icons.png",
                        fit: BoxFit.cover,
                      ),
                      color: Color(0xFF0D833C),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: ListView(
                        // shrinkWrap: true,
                        // physics: ScrollPhysics(),
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 13, right: 13),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _scaffoldkey.currentState?.openDrawer();
                                        // print('hffwwwgf');
                                        // Scaffold.of(context).openDrawer();
                                      },
                                      icon: Container(
                                        height: 17,
                                          width: 17,
                                          child: Image.asset(
                                            "assets/images/menu.png",
                                            fit: BoxFit.cover,
                                          ))),
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
                                          Icon(Icons.shopping_basket_outlined,
                                            color: Colors.white,
                                            size: 30,),
                                          Container(
                                            height: 17,
                                            child: Center(child: Text("${network.cart}",style:
                                            TextStyle(fontWeight:
                                            FontWeight.bold,
                                            color: Colors.white
                                            ),)),
                                            width: 17,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation){
                                    return SearchPage();
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
                            child: Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 30),
                                height: 40,
                                child: Center(
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Color(0xFF0D833C),
                                      ),
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      hintText: "Search for a vendor or food",
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),



                menu?[0].name=="network"?Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/hungry.jpeg"),
                      Center(child: Text("Loading Failed", style: TextStyle(
                          color: Colors.black45,
                          fontSize: 21,
                          height: 1.4,
                          fontWeight: FontWeight.bold)),),
                      Center(child: Text("Pull to refresh", style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: FontWeight.w500)),),
                    ],
                  ),
                ) : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('What do you want for'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),


                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${foodTime()}".toUpperCase(),
                          style: TextStyle(
                              color: Color(0xFF0D833C),
                              fontSize: 40,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Trending foods'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF426454),
                                    fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return TrendinFood();
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
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('See all >',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Color(0xFF5BA381))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: 160,
                          child: Builder(
                              builder: (context) {
                                return menu == null ? Center(child: Column(
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
                                )): menu!.isEmpty ?
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Text("No Trends Available", style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 21,
                                        height: 1.4,
                                        fontWeight: FontWeight.w500)),),
                                  ],
                                ) :
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child:   ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) => Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) {
                                                  return ProductPage(menu![index], specialty: 'trends',);
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
                                          child: Container(
                                            width: 170,
                                            child: Card(
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(7),
                                                    child: Container(
                                                        width: 170,
                                                        height: 100,
                                                        child:  FadeInImage.memoryNetwork(
                                                          placeholder: kTransparentImage,
                                                          image: "${menu?[index].image}",fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: 100,
                                                              child: Text('${menu?[index].name}',
                                                                  style: TextStyle(fontSize: 14),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              maxLines: 1,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 115,
                                                              child: Text(
                                                                '${menu?[index].vendortitle}',
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF5BA381)),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                                maxLines: 1,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 3.0),
                                                          child: Text('₦${menu?[index].price}',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 12)),
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



                              })
                      ),


                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 17,
                              right: 17,
                              top:20.0,
                              bottom: 8
                          ),
                          child:  slide.isEmpty?Container():  Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    // left: 2,
                                    // right: 2,
                                    bottom: 4,
                                    top: 4
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5,
                                      )
                                    ),
                                      height: 150.0,
                                      width: 350.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child:  Carousel(
                                          boxFit: BoxFit.cover,
                                          images: [
                                            for(var value in slide) NetworkImage("${value.image}")
                                          ],
                                          showIndicator: true,
                                          borderRadius: true,
                                          dotBgColor: Colors.transparent,
                                          radius: Radius.circular(20),
                                          moveIndicatorFromBottom: 0.0,
                                          noRadiusForIndicator: false,
                                          overlayShadow: false,
                                          overlayShadowColors: Colors.white,
                                          overlayShadowSize: 0.0,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),


                      Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom:3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('vendors'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF426454),
                                    fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return VendorSeeAll();
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
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('See all >',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Color(0xFF5BA381))),
                              ),
                            )
                          ],
                        ),
                      ),


                      Builder(
                          builder: (context) {
                            return vendors == null ? Center(child: Column(
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
                            )):vendors?[0].name=="network"?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text("Loading Failed", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500)),),
                              ],
                            ) : vendors!.isEmpty ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text("No Vendor Available", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500)),),
                              ],
                            ) :
                            Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child:  ListView.builder(
                                itemCount: vendors!.length<=10?vendors!.length:10,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  vendors!.reversed;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0,bottom: 15),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) {
                                              return VendorPage(vendors![index], determineClosed(vendors![index].start.toString(), vendors![index].end.toString()));
                                            },
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );

                                        network.setVendor(vendors![index].id);

                                      },
                                      child: Container(
                                        width: 170,
                                        height: 220,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(7),
                                                    child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 150,
                                                        child: FadeInImage.memoryNetwork(
                                                          placeholder: kTransparentImage,
                                                          image: "${vendors?[index].image}",fit: BoxFit.cover,),),
                                                  ),

                                                  determineClosed(vendors![index].start.toString(), vendors![index].end.toString())?ClipRRect(
                                                    borderRadius: BorderRadius.circular(7),
                                                    child: Container(
                                                        color: Colors.black54,
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 150,
                                                        child: Center(child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text('CLOSED',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 36,
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                            Text('opens at: ${vendors![index].start.toString()}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w400),
                                                            ),
                                                          ],
                                                        ))),
                                                  ):Container(),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 200,
                                                            child: Text(vendors![index].name.toString(),
                                                              style: TextStyle(fontSize: 15, color: Color(0xFF5BA381),
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            vendors![index].specialty.toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black87),
                                                          ),
                                                          Container(
                                                            width: 200,
                                                            child: Text(
                                                              vendors![index].location.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black87),
                                                              softWrap: true,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 3.0, top: 15),
                                                      child: Column(
                                                        children: [
                                                          Text('Delivery fee ₦${network.deliveryAmount}',
                                                              style: TextStyle(
                                                                  color: Colors.black45,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 12)),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.access_time, size: 16, color: Colors.black45,),
                                                              Text('${vendors![index].deliverytime.toString()} mins',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.black45,
                                                                      fontSize: 12)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                            );



                          })
                    ],
                  ),
                )

              ],
      ),
            ),

    );
  }
}
