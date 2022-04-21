import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Provider/VendorProvider.dart';

import 'package:fybe/Screen/IntroPages/intro.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';


import 'Home/MAINHOME.dart';

const String? version = "1.0";

class SplashScreenApp extends StatefulWidget {
  const SplashScreenApp({Key? key}) : super(key: key);

  @override
  _SplashScreenAppState createState() => _SplashScreenAppState();
}

class _SplashScreenAppState extends State<SplashScreenApp> {
 bool deliveryfee = false;
 bool allvalue = false;

  void initState() {
    super.initState();
    var network = Provider.of<WebServices>(context, listen: false);
    var vendor = Provider.of<BankProvider>(context, listen: false);
    network.setPath('null');
    _showVersionChecker(context);

    Future.delayed(Duration(seconds: 4), () async {
      network.getDeliveryfee().then((value){
        setState(() {
          deliveryfee = true;
        });
      });
      vendor.getAllBank().then((value) {
        setState(() {
          allvalue = true;
        });
      });
    });

  }



  _showVersionChecker (BuildContext context){
    try{
      NewVersion(
        iOSId: 'com.fybe',//dummy IOS bundle ID
        androidId: 'com.fybe.fybe',//dummy android ID
      ).showAlertIfNecessary(context: context);
    }catch(e){
      debugPrint("error=====>${e.toString()}");
    }

  }

  // Future<dynamic> decideFirstWidget() async {
  //
  //   var network = Provider.of<WebServices>(context, listen: false);
  //
  //   final box = GetStorage();
  //   var  token = box.read('token');
  //
  //   if(deliveryfee == false || allvalue == false){
  //
  //   }else{
  //     if (token == null || token == 'null' || token == '' || token.isEmpty) {
  //       return Navigator.pushAndRemoveUntil(
  //         context,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation, secondaryAnimation) {
  //             return IntroPage();
  //           },
  //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //             return FadeTransition(
  //               opacity: animation,
  //               child: child,
  //             );
  //           },
  //         ),
  //             (route) => false,
  //       );
  //     } else {
  //       network.setInitials();
  //       network.setToken(box.read('token'));
  //       return Navigator.pushAndRemoveUntil(
  //         context,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation, secondaryAnimation) {
  //             return MainHome(); //SignUpAddress();
  //           },
  //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //             return FadeTransition(
  //               opacity: animation,
  //               child: child,
  //             );
  //           },
  //         ),
  //             (route) => false,
  //       );
  //     }
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    final box = GetStorage();
    var  token = box.read('token');

    allvalue||deliveryfee?token == null || token == 'null' || token == '' || token.isEmpty
        ?null:network.setInitials():null;
    allvalue||deliveryfee?token == null || token == 'null' || token == '' || token.isEmpty
        ?null:network.setToken(box.read('token')):null;
    return Scaffold(
      body: allvalue||deliveryfee?token == null || token == 'null' || token == '' || token.isEmpty
      ?IntroPage():MainHome():Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF0D833C),
        child: Center(child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.4,
            ),
            Container(
                child: Image.asset(
                  "assets/images/fybe.png",
                  fit: BoxFit.cover,
                )),
            Text('...Eat well-Vibe well...', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white),),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.4,
            ),
            Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Powered by WinguDigital', style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),),
            )
          ],
        ),),
      ),
    );
  }
}
