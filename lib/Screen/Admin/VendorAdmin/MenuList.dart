import 'package:flutter/material.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/AddCategory.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/AddMenu.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorAdmin.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:fybe/Widget/Drawer.dart';
import 'package:provider/provider.dart';

class MenuList extends StatefulWidget {
  var vendorID;
  var vendorname;
  var categoryID;
  MenuList(this.vendorID, this.categoryID, this.vendorname);
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<MenuModel> ?menu;

  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getVendorMenu(widget.vendorID, widget.categoryID).then((value) {
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
                          Text('MENU', style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return  AddMenu(widget.vendorname, widget.categoryID, widget.vendorID);
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
                    Center(child: Text("No Menu Available", style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        height: 1.4,
                        fontWeight: FontWeight.w500)),),
                  ],
                ) :
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: InkWell(
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
                                        "${menu![index].image}",
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
                                          Text("${menu![index].name}",
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
                    ),
                    itemCount: menu!.length,
                  ),
                );
              })
        ],
      ),
    );
  }
}
