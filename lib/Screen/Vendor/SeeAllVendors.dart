import 'package:flutter/material.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Home/Search.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

class VendorSeeAll extends StatefulWidget {
  const VendorSeeAll({Key? key}) : super(key: key);

  @override
  _VendorSeeAllState createState() => _VendorSeeAllState();
}

class _VendorSeeAllState extends State<VendorSeeAll> {
  List<Vendors> ?vendors;
  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendors().then((value) {
      setState(() {
        vendors = value ;
      });
    });
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


  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      vendors = null;
      calltransaction(context);
    });
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    calltransaction(context);
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  void initState(){
    super.initState();
    calltransaction(context);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      backgroundColor:Colors.white,
      key: _scaffoldkey,
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: DrawerWidget(),
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
                    height: 190,
                    child: Image.asset(
                      "assets/images/icons.png",
                      fit: BoxFit.cover,
                    ),
                    color: Color(0xFF0D833C),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    child: ListView(
                      // shrinkWrap: true,
                      // physics: ScrollPhysics(),
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 20.0, left: 13, right: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text('VENDORS FOODS', style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),),
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
                                pageBuilder: (context, animation, secondaryAnimation) {
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
                              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
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
                                    hintText: "Search for a vendor or product",
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),



              vendors?[0].name=="network"?Container(
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
              ) :Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                ),
                child: Padding(
                    padding: const EdgeInsets.only(top:0.0),
                    child:  Builder(
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
                              padding: EdgeInsets.zero,
                              itemCount: vendors!.length,
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
                                            return VendorPage(vendors![index],determineClosed(vendors![index].start.toString(), vendors![index].end.toString()));
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
                                                        image: "${vendors?[index].image}",fit: BoxFit.cover,)),
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
                                                        Text('Delivery fee ₦${network.deliveryAmount.toString()}',
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



                        }),

                  ),
              ),


            ],
          ),
      ),
    );
  }
}
