import 'package:flutter/material.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/AddCategory.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/MenuList.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorAdmin.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';

class CartegoryList extends StatefulWidget {
  var vendorID;
  var vendorname;
   CartegoryList(this.vendorID, this.vendorname);
  @override
  _CartegoryListState createState() => _CartegoryListState();
}

class _CartegoryListState extends State<CartegoryList> {
  List<CategoryModel> ?category;

  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendorCategory(widget.vendorID).then((value) {
      setState(() {
        category = value ;
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
                          Text('CATEGORY', style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return  UploadCategory(widget.vendorID, widget.vendorname);
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
                return category == null ? Center(child: Column(
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
                )) : category!.isEmpty ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("No Category Available", style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        height: 1.4,
                        fontWeight: FontWeight.w500)),),
                  ],
                ) :
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child:  ListView.builder(
                    itemCount: category!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      category!.reversed;
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0,bottom: 15),
                        child: Card(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return MenuList(widget.vendorID, category![index].id, widget.vendorname);
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
                            child: ListTile(
                              title: Text("${category![index].name}"),
                              leading: Icon(Icons.check_circle_outlined),
                            )
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
