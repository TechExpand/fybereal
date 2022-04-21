import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';

import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:fybe/Screen/Home/Wallet.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'EditAccount.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late PageController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: 0, viewportFraction: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var  token = box.read('token');
    var network = Provider.of<WebServices>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF0D833C),
          title: Text('Account'),
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
        body: token == null || token == 'null' || token == '' || token.isEmpty?
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
        ):Container(
          color: Colors.white,
          child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(''),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                secondaryAnimation) {
                              return EditAccount();
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Edit',  style: TextStyle(color: Color(0xFF0D833C))),
                      ),
                    )
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top:0.0, bottom: 8, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:5.0),
                      child: Text('Full Name'),
                    ),
                    Container(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          disabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.black45)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: network.fullname,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0.0, bottom: 8, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:5.0, top: 10),
                      child: Text('Email'),
                    ),
                    Container(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          disabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.black45)
                          ),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: network.myemail,
                        ),
                      ),
                    ),

                  ],
                ),
              ),





              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:20.0, left: 15, right: 15),
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return Wallet();
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
                        leading: Icon(Icons.account_balance_wallet_outlined, color: Colors.black54,),
                        title: Text('Wallet', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),

                ],
              )
            ],
          ),
        ));
  }
}
