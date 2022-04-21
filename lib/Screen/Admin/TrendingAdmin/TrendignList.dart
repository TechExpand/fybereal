import 'package:flutter/material.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Admin/TrendingAdmin/AddTrending.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/CartegoryVendor.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorAdmin.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';

class TrendingList extends StatefulWidget {
  const TrendingList({Key? key}) : super(key: key);

  @override
  _TrendingListState createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {

  List<MenuModel> ?menu;

  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getTrends().then((value) {
      setState(() {
        menu = value ;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    calltransaction(context);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: DrawerWidget(),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Image.asset(
                  "assets/images/icons.png",
                  fit: BoxFit.cover,
                ),
                color: Color(0xFF0D833C),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView(
                  // shrinkWrap: true,
                  // physics: ScrollPhysics(),
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 40.0, left: 13, right: 13),
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
                          Text('TRENDING FOOD', style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return  AddTrending();
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
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),

          Builder(
              builder: (context) {
                return menu == null ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Theme(
                        data: Theme.of(context).copyWith(
                          accentColor: Color(0xFF00A85A),),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF00A85A)),
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                          //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Loading',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ],
                )) : menu!.isEmpty ?
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
                  child:   GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: (){

                            },
                            child: Container(
                              width: 180,
                              child: Card(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Container(
                                          width: 170,
                                          height: 125,
                                          child: Image.network(
                                            "${menu?[index].image}",
                                            fit: BoxFit.cover,
                                          )),
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
                                              Text('${menu![index].name}',
                                                  style: TextStyle(fontSize: 14)),
                                              Text(
                                                '${menu![index].vendortitle}',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF5BA381)),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 3.0),
                                            child: Text('#${menu![index].price}',
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
                          Align(
                            alignment: Alignment.topRight ,
                            child: Container(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                onTap:(){
                                  print('sss');
                                  var network = Provider.of<WebServices>(context, listen: false);
                                  network.deleteTrends(menu![index].id).then((value){
                                    setState(() {
                                      calltransaction(context);
                                    });
                                  });
                                },
                                child:  Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Icon(Icons.clear, color: Colors.black,),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white70
                                    ),
                                  ),
                                splashColor: Colors.transparent,
                                highlightColor:Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: menu?.length,
                  ),

                );



              })



        ],
      ),
    );
  }
}
