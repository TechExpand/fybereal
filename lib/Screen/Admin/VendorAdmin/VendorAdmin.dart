import 'dart:io';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Utils/utils.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';


class Upload extends StatelessWidget {
  final form_key = GlobalKey<FormState>();
  String startTime = '00:00';
  String endTime = '00:00';
  var name = '';
  var specialty = '';
  var deliveryfee = '';
  var deliverytime = '';
  var location = '';

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Vendor', style: TextStyle(color: Colors.white),),
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

                          Container(
                            padding: EdgeInsets.only( bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'name is Required';
                                  } else {
                                    name = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Vendor name',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only( bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'specialty is Required';
                                  } else {
                                    specialty = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Vendor Specialty',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only( bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Delivery fee is Required';
                                  } else {
                                    deliveryfee = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Delivery fee',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:10, bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Delivery time required';
                                  } else {
                                    deliverytime = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Delivery time',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:10, bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Vendor Location required';
                                  } else {
                                    location = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Vendor Location',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38, width: 1),
                                  ),
                                )
                            ),
                          ),


                          StatefulBuilder(
                            builder: (context, setState) {
                              return Padding(
                                padding: const EdgeInsets.only(top:8.0, bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                                      child: Text(
                                        'Start Time',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        BottomPicker.time(
                                            pickerTextStyle: TextStyle(color: Colors.black),
                                            buttonTextStyle: TextStyle(color:Colors.black),
                                            title:  "Set End Time",
                                            titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                            onSubmit: (index) {
                                              setState(() {
                                                var datas = Provider.of<Utils>(context, listen: false);
                                                var time = DateTime.parse(index.toString());
                                                startTime = datas.formatTime(time).toString() ;
                                              });

                                            },
                                            onClose: () {
                                              print("Picker closed");
                                            },
                                            use24hFormat:  false)
                                            .show(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 250,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(color: Colors.green, width: 0.0)
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(startTime, style: TextStyle(color: Colors.grey),),
                                            )),
                                      ),
                                    ),




                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, left: 8, top:15.0,),
                                      child: Text(
                                        'End Time',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        BottomPicker.time(
                                            pickerTextStyle: TextStyle(color: Colors.black),
                                            buttonTextStyle: TextStyle(color:Colors.black),
                                            title:  "Set End Time",
                                            titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                                            onSubmit: (index) {
                                              setState(() {
                                                var datas = Provider.of<Utils>(context, listen: false);
                                                var time = DateTime.parse(index.toString());
                                                endTime = datas.formatTime(time).toString() ;
                                              });

                                            },
                                            onClose: () {
                                              print("Picker closed");
                                            },
                                            use24hFormat:  false)
                                            .show(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 250,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(color: Colors.green, width: 0.0)
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(endTime, style: TextStyle(color: Colors.grey),),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Selected Image',style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child:  Provider.of<Utils>(context, listen:true).selectedImage.path.isEmpty
                                ? Center(
                              child: Text('No Image Selected'),
                            )
                                : Image.file(
                              File(Provider.of<Utils>(context, listen:true).selectedImage.path),
                              fit: BoxFit.contain,
                            ),
                          ),

                          Padding(
                              padding:  EdgeInsets.only(top: 50),
                              child: webservices_consumer.isLoading == false
                                  ?Material(
                                borderRadius: BorderRadius.circular(26),
                                elevation: 25,
                                child: FlatButton(
                                  onPressed: () {
                                    // webservices.Login_SetState();
                                    webservices_consumer.selectimage(source:ImageSource.gallery, context: context);
                                  },
                                  color: Colors.white10,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 190.0, minHeight: 53.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                          "Select Image",
                                          textAlign: TextAlign.center,
                                          style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                                      ),
                                    ),
                                  ),

                                ),
                              ):CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),)
                          ),


                          Padding(
                              padding:  EdgeInsets.only(top: 30, bottom: 50),
                              child: Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 25,
                                  child:   webservices_consumer.isLoading == false?FlatButton(
                                    onPressed: (){
                                      if(form_key.currentState!.validate()){
                                       if(endTime == "00:00" || startTime == "00:00" || Provider.of<Utils>(context, listen:false).selectedImage.path.isEmpty){
                                          showTextToast(
                                             text: "Field is required",
                                             context: context,
                                         );
                                       }else{
                                         var network = Provider.of<WebServices>(context, listen: false);
                                      //   Provider.of<Utils>(context, listen:false).selectedImage.path
                                         circularCustom(context);
                                         network.VendorUpload(
                                           context: context,
                                           specialty: specialty,
                                           start: startTime,
                                           location: location,
                                           end: endTime,
                                           name: name,
                                           path: Provider.of<Utils>(context, listen:false).selectedImage.path,
                                           deliveryfee: deliveryfee,
                                           deliverytime: deliverytime,
                                         );
                                       }
                                      }
                                    },
                                    color: Color(0xFF0D833C),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24)
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 190.0, minHeight: 53.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            "UPLOAD",
                                            textAlign: TextAlign.center,
                                            style:TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                                        ),
                                      ),
                                    ),

                                  ):Text('Uploading...')
                              )
                          )


                        ],
                      ),
                    );
                  })
          ),
        ),
      ),
    );
  }
}
