import 'package:flutter/material.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Home/Search.dart';
import 'package:fybe/Screen/Home/Shopping.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

class TrendinFood extends StatefulWidget {
  const TrendinFood({Key? key}) : super(key: key);

  @override
  _TrendinFoodState createState() => _TrendinFoodState();
}

class _TrendinFoodState extends State<TrendinFood> {
  List<MenuModel> ?menu;

  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getTrends().then((value) {
      setState(() {
        menu = value ;
      });
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      menu = null;
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
                          const EdgeInsets.only(top: 15.0, left: 13, right: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Text('TRENDING FOODS', style: TextStyle(
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
               child: Padding(
                    padding: const EdgeInsets.only(top:0.0),
                    child:  Builder(
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
                          )) :menu?[0].name=="network"?Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Text("Loading Failed", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500)),),
                            ],
                          ) : menu!.isEmpty ?
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
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                              itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child:    InkWell(
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
                                    width: 180,
                                    child: Card(
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: Container(
                                                width: 170,
                                                height: 125,
                                                child:  FadeInImage.memoryNetwork(
                                                  placeholder: kTransparentImage,
                                                  image: "${menu?[index].image}",fit: BoxFit.cover,)),
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
                                                            color: Color(0xFF0D833C)),
                                                        softWrap: true,
                                                        overflow: TextOverflow.visible,
                                                        maxLines: 1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 3.0),
                                                  child: Text('₦${menu![index].price}',
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
                              itemCount: menu?.length,
                            ),

                          );



                        })
                  ),
             ),


            ],
          ),
        ),
    );
  }
}
