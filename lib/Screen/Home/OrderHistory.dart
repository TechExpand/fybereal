import 'package:flutter/material.dart';
import 'package:fybe/Model/CartModel.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Widget/NumberSelection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderHistoryModel> ?orderHistory;


  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getOrderHistory().then((value) {
      setState(() {
        orderHistory = value ;
      });
    });
  }




  @override
  void initState(){
    calltransaction(context);
    super.initState();
  }



  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      orderHistory = null;
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
  Widget build(BuildContext context) {
    final box = GetStorage();
    var  token = box.read('token');
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF3A843D),
          title: Text('Order History'),
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
        backgroundColor: Colors.white,
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
          ): ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children:[
              Builder(
                  builder: (context) {
                    return
                      orderHistory == null ? Center(child: Column(
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
                    )) : orderHistory!.isEmpty ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("No Order History", style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            height: 1.4,
                            fontWeight: FontWeight.w500)),),
                      ],
                    ) :orderHistory?[0].name=="network"?Container(
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
                    ) :
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child:  ListView.builder(
                        itemCount: orderHistory!.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          orderHistory!.reversed;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: Container(
                                  child: Row(children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 1.0, right: 1, top: 4, bottom: 4),
                                          child: Text(
                                            '${orderHistory?[index].menu?["vendortitle"]}',
                                            style: TextStyle(
                                                color: Colors.black26, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            child: Image.network('${orderHistory?[index].menu?["image"]}',
                                                fit: BoxFit.cover),
                                            width: 180.0,
                                            height: 110.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(1.0, 1.0),
                                                  blurRadius: .3,
                                                  spreadRadius: .3,
                                                ),
                                              ],
                                              borderRadius: BorderRadius.circular(9),
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${orderHistory?[index].menu?["title"]}',
                                            style: GoogleFonts.openSans(
                                                fontSize: 18,
                                                color: Color(0xFF5E816E),
                                                fontWeight: FontWeight.w600),
                                            maxLines: 2,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '₦${orderHistory?[index].menu?["price"]}',
                                            style: TextStyle(
                                                color: Colors.black54, fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Success ',
                                                style: TextStyle(
                                                    color: Colors.black54, fontWeight: FontWeight.bold),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.task_alt_outlined, color: Colors.green,)
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ])),
                            ),
                          );
                        },
                      ),

                    );

                  }),









            ],
          ),
        ));
  }
}
