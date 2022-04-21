import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:io';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Utils/utils.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:provider/provider.dart';
import 'package:fybe/Screen/Home/MAINHOME.dart';

class CheckOut extends StatefulWidget {
  CheckOut(this.cart, this.total, this.vendorName);

  var cart;
  var total;
  var vendorName;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List cartMenu = [];
  String phone = '';
  String address = "";
  String description = "";
  String nearestbusstop = "";
  var publicKey = 'pk_live_59dd820e33debaa3be28a2d6812b2a61689be9ed';
  final plugin = PaystackPlugin();
  final form_key = GlobalKey<FormState>();

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  var containerFee = 0;

  getContainerFee() {
    for (var value in widget.cart!) {
      if (value.menu?['container'] == 'true') {
        containerFee = containerFee +
            (int.parse(value.menu?['containerAmount']) *
                int.parse(value.quantity.toString()));
      }
    }
  }

  paystackCalculator(double amount) {
    if (amount <= 2499.0) {
      double percentAmount = ((1.5 / 100.0) * amount);
      return percentAmount;
    } else if (amount >= 2500.0 && amount <= 126666.0) {
      double percentAmount = ((1.5 / 100.0) * amount);
      double totalPaystack = percentAmount + 100.0;
      return totalPaystack;
    } else if (amount >= 126667.0) {
      return 2000.0;
    }
  }

  paymentMethod(amount, email) async {
    Charge charge = Charge()
      ..amount = amount
      ..reference = _getReference()
      ..email = email;
    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card,
        charge: charge,
        logo: Container(
            width: 50,
            height: 50,
            child: Image.asset(
              "assets/images/fybe2.png",
              fit: BoxFit.contain,
            )));
    if (response.status) {
      print(response.reference);
      var network = Provider.of<WebServices>(context, listen: false);
      var utils = Provider.of<Utils>(context, listen: false);
      network.checkPaymentReference(
        context: context,
        reference: response.reference,
        deliverylocation: address,
        description: description,
        nearestbusstop: utils.nearestBusStop,
        phone: phone,
        vendor: widget.vendorName,
      );
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MainHome();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
    getContainerFee();
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: true);
    var totalAmount =
        widget.total + network.userDeliveryAmount + network.deliveryAmount;
    var utils = Provider.of<Utils>(context, listen: false);
    return Scaffold(
        bottomNavigationBar: Container(
          height: 84,
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Material(
                  elevation: 2,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Total: ₦${paystackCalculator(double.parse(totalAmount.toString())).ceil() + double.parse(totalAmount.toString()).ceil() + containerFee}',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF5E816E),
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (form_key.currentState!.validate()) {
                    var network =
                        Provider.of<WebServices>(context, listen: false);
                    var utils = Provider.of<Utils>(context, listen: false);
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (utils.nearestBusStop.isEmpty) {
                      showTextToast(
                        text: 'Nearest Bus Stop Required',
                        context: context,
                      );
                    } else {
                      payOptionDialog(totalAmount);
                    }
                  }
                },
                child: Container(
                  color: Color(0xFF0D833C),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        'PLACE ORDER',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF0D833C),
          title: Text('Checkout'),
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
        body: Form(
          key: form_key,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 10.0, top: 15, right: 10, bottom: 15),
                height: 100,
                child: Card(
                  elevation: 3,
                  color: Colors.green.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                            width: 165,
                            height: 165,
                            child: Image.asset(
                              "assets/images/bike.png",
                              fit: BoxFit.contain,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Delivery time',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                            Text('20-30 mins',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Material(
                elevation: 3,
                child: Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'description is Required';
                      } else {
                        description = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.description,
                        color: Color(0xFF3A843D),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      hintText: "note.",
                    ),
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Nearest Bus Stop',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              InkWell(
                onTap: () {
                  _showPicker(context);
                  setState(() {
                    utils.setNearestBusStop("Ekosodin");
                  });
                },
                child: Material(
                  elevation: 3,
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${utils.nearestBusStop.isEmpty ? "e.g uselu bus stop." : utils.nearestBusStop}",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ),
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Material(
                elevation: 3,
                child: Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'delivery address is Required';
                      } else {
                        address = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF3A843D),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      hintText: "e.g 21, ekosodi road, benin city.",
                    ),
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 8, right: 8, bottom: 8),
                child: Text(
                  'Phone number',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Material(
                elevation: 3,
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'phone number is Required';
                      } else {
                        phone = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFF3A843D),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      hintText: "09012345678",
                    ),
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 8, right: 8, bottom: 8),
                child: Text(
                  'items',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Material(
                elevation: 3,
                child: Container(
                  child: Column(
                    children: [
                      for (var i in widget.cart)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${i.menu['title']}",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text(
                                    "x${i.quantity}",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                "${i.menu['price']}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 8, right: 8, bottom: 10),
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                      color: Color(0xFF426454),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 3,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '₦${widget.total}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        containerFee == 0
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Container fee',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '₦${containerFee}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery fee',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '₦${network.deliveryAmount + network.userDeliveryAmount}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'VAT fee',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '₦${paystackCalculator(double.parse(totalAmount.toString())).ceil()}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // containerFee
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _showPicker(BuildContext ctx) {
    var utils = Provider.of<Utils>(context, listen: false);
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        )),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            )),
                        width: 100,
                        height: 15,
                      ),
                    ),
                  ),
                  Material(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Select Nearest Bus Stop",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    )),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 30,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      children: [
                        Text('Ekosodin'),
                        Text('Isihor'),
                        Text('Oluku'),
                        Text('Uselu'),
                        Text('Bdpa'),
                        Text('UNIBEN'),
                        Text('UBTH'),
                        Text('Osasogie'),
                        Text('Adolor'),
                        Text('S & T'),
                        Text('Uselu Market'),
                      ],
                      onSelectedItemChanged: (value) {
                        List<String> busStop = [
                          'Ekosodin',
                          "Isihor",
                          "Oluku",
                          "Uselu",
                          "Bdpa",
                          "UNIBEN",
                          "UBTH",
                          "Osasogie",
                          "Adolor",
                          "S & T",
                          "Uselu Market",
                        ];
                        setState(() {
                          utils.setNearestBusStop(busStop[value]);
                        });
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 34,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () => Navigator.pop(context),
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100, minHeight: 34.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Done",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  payOptionDialog(totalAmount) {
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            child: new StatefulBuilder(builder: (ctx, setState) {
              return new Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      height: 250.0,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16),
                            )),
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    )),
                                width: 100,
                                height: 15,
                              ),
                            ),
                          ),
                          Text(
                            "Choose Payment Option",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              InkWell(
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      // totalAmount = value;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      suffixIcon:
                                          Icon(Icons.credit_card_outlined),
                                      hintText: "Pay with Card",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  paymentMethod(
                                      paystackCalculator(double.parse(
                                                      totalAmount.toString()))
                                                  .ceil() *
                                              100 +
                                          containerFee * 100 +
                                          (double.parse(
                                                      totalAmount.toString()) *
                                                  100.0)
                                              .ceil(),
                                      network.myemail);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      // totalAmount = value;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      suffixIcon: Icon(
                                          Icons.account_balance_wallet_sharp),
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      hintText: "Pay with Wallet",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  var utils = Provider.of<Utils>(context,
                                      listen: false);
                                  Navigator.pop(context);
                                  circularCustom(context);
                                  network.payWithWallet(
                                    context: context,
                                    deliverylocation: address,
                                    amount: paystackCalculator(double.parse(
                                        totalAmount.toString()))
                                        .ceil() +
                                        containerFee +
                                        (double.parse(
                                            totalAmount.toString()))
                                            .ceil(),
                                    description: description,
                                    nearestbusstop: utils.nearestBusStop,
                                    phone: phone,
                                    vendor: widget.vendorName,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )));
            }),
          );
        });
  }
}
