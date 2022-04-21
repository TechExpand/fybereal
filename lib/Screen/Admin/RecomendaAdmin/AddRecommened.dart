import 'dart:io';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Model/Vendor.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Provider/VendorProvider.dart';
import 'package:fybe/Screen/Utils/utils.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';


class AddRecommend extends StatelessWidget {
  // widget.vendorname, widget.categoryID, widget.vendorID

  final form_key = GlobalKey<FormState>();

  var name = '';
  var description = '';
  var price = '';
  // var deliverytime = '';

  @override
  Widget build(BuildContext context) {
    BankProvider postRequestProvider =
    Provider.of<BankProvider>(context, listen: true);
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Recommended', style: TextStyle(color: Colors.white),),
        elevation: 10,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Center(child: Padding(
              padding: const EdgeInsets.only(left:0.0),
              child: Text('Cancel', style: TextStyle(fontSize: 12,color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.fade,),
            )),
          ),
        ),
        backgroundColor: Color(0xFF0D833C),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:30),
          child: Center(
              child: Consumer<Utils>(
                  builder: (context, webservices_consumer, child) {
                    return Form(
                      key: form_key,
                      child: Column(
                        children: <Widget>[
                          StatefulBuilder(
                              builder: (context, set) {
                                return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20, ),
                                    child: InkWell(
                                      onTap: (){
                                        result = postRequestProvider.allBankList;
                                        bankDialog(context, set);
                                      },
                                      child: Container(
                                        height: 50,
                                        child: TextFormField(
                                          cursorColor: Color(0xC2141414),
                                          enabled: false,
                                          decoration: InputDecoration(
                                            isCollapsed: true,
                                            hintText: postRequestProvider.selectedBank==null?"Select Vendor":
                                            postRequestProvider.selectedBank!.name,
                                            hintStyle: TextStyle(color: Color(0xC2141414)),
                                            focusColor: Color(0xC2141414),
                                            border: UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),

                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),
                                            ),
                                            focusedBorder:UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }
                          ),

                          postRequestProvider.allBankList2.isNotEmpty ?StatefulBuilder(
                              builder: (context, set) {
                                return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20, ),
                                    child: InkWell(
                                      onTap: (){
                                        result2 = postRequestProvider.allBankList2;
                                        bankDialog2(context, set);
                                      },
                                      child: Container(
                                        height: 50,
                                        child: TextFormField(
                                          cursorColor: Color(0xC2141414),
                                          enabled: false,
                                          decoration: InputDecoration(
                                            isCollapsed: true,
                                            hintText: postRequestProvider.selectedBank2==null?"Select Vendor Category":
                                            postRequestProvider.selectedBank2!.name,
                                            hintStyle: TextStyle(color: Color(0xC2141414)),
                                            focusColor: Color(0xC2141414),
                                            border: UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),

                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),
                                            ),
                                            focusedBorder:UnderlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0x59141414), width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }
                          ):Container(),


                          postRequestProvider.menu.isNotEmpty ?  Builder(builder: (context) {
                            return postRequestProvider.menu == null
                                ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Theme(
                                        data: Theme.of(context).copyWith(
                                          accentColor: Color(0xFF00A85A),
                                        ),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
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
                                ))
                                : postRequestProvider.menu.isEmpty
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
                                    onTap: (){
                                      var network = Provider.of<WebServices>(context, listen: false);
                                      //   Provider.of<Utils>(context, listen:false).selectedImage.path
                                      circularCustom(context);
                                      network.AddRecomend(
                                        menu: postRequestProvider.menu[index].id,
                                        context: context,
                                        description: postRequestProvider.menu[index].description,
                                        price: postRequestProvider.menu[index].price,
                                        categoryID: postRequestProvider.selectedBank2?.id,
                                        vendorID: postRequestProvider.selectedBank?.id,
                                        vendorname:  postRequestProvider.selectedBank?.name,
                                        name: postRequestProvider.menu[index].name,
                                        path: postRequestProvider.menu[index].image,
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
                                                  child: Image.asset(
                                                      '${postRequestProvider.menu[index].image}',
                                                      fit: BoxFit.cover),
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
                                                    Text(
                                                      '${postRequestProvider.menu[index].name}',
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xFF5E816E),
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                    Text(
                                                      '₦${postRequestProvider.menu[index].price}',
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
                                    ),
                                  ),
                                ),
                                itemCount: postRequestProvider.menu.length,
                              ),
                            );
                          }):Container(),

                        ],
                      ),
                    );
                  })
          ),
        ),
      ),
    );
  }







  List<Vendors> result = [];
  void searchBank(userInputValue, ctx) {
    BankProvider postRequestProvider =
    Provider.of<BankProvider>(ctx, listen: false);
    result = postRequestProvider.allBankList
        .where((bank) => bank.name.toString()
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }


  bankDialog(ctx, set) {
    BankProvider postRequestProvider =
    Provider.of<BankProvider>(ctx, listen: false);
    showDialog(
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {


              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchBank(value, ctx);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search Vendors',
                    labelStyle: TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount:  result.length,
                            itemBuilder: (context, index) {
                              result.sort((a, b) {
                                var ad = a.name;
                                var bd = b.name;
                                var s = ad!.compareTo(bd!);
                                return s;
                              });

                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider
                                      .changeSelectedBank(result[index]);
                                  postRequestProvider.getAllBank2(result[index].id);
                                  postRequestProvider.setMenuEmpty();
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                        result[index]
                                            .name.toString()
                                            .substring(0, 2).toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  title: Text('${result[index].name}',  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      set(() {});
    });
  }





  List<CategoryModel> result2 = [];
  void searchBank2(userInputValue, ctx) {
    BankProvider postRequestProvider =
    Provider.of<BankProvider>(ctx, listen: false);
    result2 = postRequestProvider.allBankList2
        .where((bank) => bank.name.toString()
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }


  bankDialog2(ctx, set) {
    BankProvider postRequestProvider =
    Provider.of<BankProvider>(ctx, listen: false);
    showDialog(
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchBank2(value, ctx);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search Category',
                    labelStyle: TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount:  result2.length,
                            itemBuilder: (context, index) {
                              result2.sort((a, b) {
                                var ad = a.name;
                                var bd = b.name;
                                var s = ad!.compareTo(bd!);
                                return s;
                              });

                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider
                                      .changeSelectedBank2(result2[index]);
                                  postRequestProvider.getVendorMenu(
                                      postRequestProvider.selectedBank?.id,
                                      postRequestProvider.selectedBank2?.id);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                        result2[index]
                                            .name.toString()
                                            .substring(0, 2).toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  title: Text('${result2[index].name}',  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      set(() {});
    });
  }


}
