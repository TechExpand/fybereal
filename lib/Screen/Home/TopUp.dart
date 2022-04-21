import 'dart:io';

import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fybe/Model/CategoryModel.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';

import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:fybe/Screen/Utils/utils.dart';
import 'package:fybe/Screen/Vendor/SeeAllVendors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'EditAccount.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  late PageController controller;
  int index = 0;
  var publicKey = 'pk_live_317ba7406170d22b4c7f0e222926ff8000fba2c4';
  final plugin = PaystackPlugin();

  List<TransactionModel> ?transaction;

  calltransaction2(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getWalletTransaction().then((value) {
      setState(() {
        transaction = value ;
      });
    });
  }


  Map ?wallet;

  calltransaction(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getWallet().then((value) {
      setState(() {
        wallet = value ;
        network.setWallet(wallet!["amount"]);
      });
    });
  }
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime
        .now()
        .millisecondsSinceEpoch}';
  }


  String totalAmount = "";

  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: 0, viewportFraction: 1);
    plugin.initialize(publicKey: publicKey);
    calltransaction(context);
    calltransaction2(context);
    super.initState();
  }



  paystackCalculator(double amount){
    if(amount <= 2499.0){
      double   percentAmount = ((1.5/100.0) * amount);
      return percentAmount;
    }else if(amount >= 2500.0 && amount <=  126666.0){
      double percentAmount = ((1.5/100.0) * amount);
      double   totalPaystack = percentAmount + 100.0;
      return totalPaystack;
    }else if(amount >= 126667.0){
      return 2000.0;
    }
  }



  paymentMethod(amount, email)async{
    Charge charge = Charge()
      ..amount = amount
      ..reference = _getReference()
      ..email = email;
    CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        logo: Container(
            width: 50,
            height: 50,
            child: Image.asset(
              "assets/images/fybe2.png",
              fit: BoxFit.contain,
            ))
    );
    if (response.status) {
      print(response.reference);
      showTextToast(
        text: 'TopUp Successful',
        context: context,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var  token = box.read('token');
    var network = Provider.of<WebServices>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3A843D),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
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
        ):

        wallet == null ? Center(child: Column(
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
        )):
        Container(
          color: Colors.white,
          child:  ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding:  EdgeInsets.only(top:8.0, bottom: 8, left: MediaQuery.of(context).size.width*0.045),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Top Up",
                    style: TextStyle(
                        color: Color(0xFF3A843D),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: MediaQuery.of(context).size.width*0.045),
                child: Align(
                  alignment: Alignment.center,
                  child:  Material(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    elevation: 4.0,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient:LinearGradient(
                            colors: [
                              Color(0xFFFDFDFD),
                              Color(0xFFFDFDFD),
                              Color(0xFFFAFAFA),
                              Color(0xFFFAFAFA),
                              //add more colors for gradient
                            ],
                            begin: Alignment.topLeft, //begin of the gradient color
                            end: Alignment.bottomRight, //end of the gradient color
                            stops: [0, 0.5, 0.5, 0.8] //stops for individual color
                          //set the stops number equal to numbers of color
                        ),
                      ),
                      child: Padding(
                          padding: new EdgeInsets.all(15.0),
                          child: Column(children: <Widget>[
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.82,
                                        child: Text(
                                          'Note: With Fybe TopUp, you can complete pending transactions such as incomplete payment, balancing item/meal fee etc',
                                          style: TextStyle(
                                              color: Colors
                                                  .black54,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton(
                                  style:  ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xFF173D1E)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          )
                                      )
                                  ),

                                  child: Container(
                                    width: 110,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.cached_sharp),
                                        Text(
                                          ' Top Up',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize: 16.2,
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    fundDialog();
                                  },
                                ),
                              ),
                            ),
                          ])),
                    ),
                  ),
                ),
              ),



            ],
          ),
        ));
  }




  fundDialog() {
    // PostRequestProvider postRequestProvider =
    // Provider.of<PostRequestProvider>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return   ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft:  Radius.circular(16),
            ),
            child: new StatefulBuilder(
                builder: (ctx, setState) {
                  return new Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                          height: 210.0,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          color: Colors.white,
                          child: ListView(
                            children: [
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      topLeft:  Radius.circular(16),
                                    )
                                ),
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        )
                                    ),
                                    width: 100,
                                    height: 15,
                                  ),
                                ),
                              ),
                              Text(
                                "TopUp Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value){
                                    totalAmount = value;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    hintText: "Enter Amount",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () => Navigator.pop(context),
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 34.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Cancel",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    // onPressed: () => Navigator.pop(context),
                                    onPressed: (){

                                      if(totalAmount.isEmpty){
                                        FocusScopeNode currentFocus = FocusScope.of(ctx);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        showTextToast(
                                          text: 'Amount Required',
                                          context: context,
                                        );
                                      }else{
                                        FocusScopeNode currentFocus = FocusScope.of(ctx);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        Navigator.pop(context);
                                        paymentMethod(
                                            paystackCalculator(double.parse(totalAmount.toString())).ceil()*100 +  (double.parse(totalAmount.toString())*100.0).ceil(),
                                            network.myemail);
                                      }

                                    },
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 34.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Done",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),



                              ]),

                            ],
                          )));}),
          );
        });
  }
}


