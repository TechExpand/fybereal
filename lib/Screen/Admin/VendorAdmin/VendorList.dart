import 'package:flutter/material.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/CartegoryVendor.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorAdmin.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';

class VendorList extends StatefulWidget {
  const VendorList({Key? key}) : super(key: key);

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {

  List<Vendors> ?vendors;



  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendors().then((value) {
      setState(() {
        vendors = value ;
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
                          Text('VENDOR', style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return  Upload();
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
                return vendors == null ? Center(child: Column(
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
                )) : vendors!.isEmpty ?
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
                                  return CartegoryList(vendors![index].id, vendors![index].name);
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
                            height: 220,
                            child: Card(
                              child: Column(
                                children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 150,
                                            child: Image.network(
                                              "${vendors![index].image.toString()}",
                                              fit: BoxFit.cover,
                                            )),
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
                                              Text(vendors![index].name.toString(),
                                                style: TextStyle(fontSize: 15, color: Color(0xFF5BA381)),

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
                                              Text('Delivery fee #${vendors![index].deliveryfee.toString()}',
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
    );
  }
}
