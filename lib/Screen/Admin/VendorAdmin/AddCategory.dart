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


class UploadCategory extends StatelessWidget {
  var vendorID;
  var vendorname;
  UploadCategory(this.vendorID, this.vendorname);

  final form_key = GlobalKey<FormState>();
  var name = '';


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Category', style: TextStyle(color: Colors.white),),
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
        backgroundColor:  Color(0xFF0D833C),

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
                                    return 'category name is Required';
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
                                  labelText: 'Category name',
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


                          Padding(
                              padding:  EdgeInsets.only(top: 30, bottom: 50),
                              child: Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 25,
                                  child: webservices_consumer.isLoading == false?FlatButton(
                                    onPressed: (){
                                      if(form_key.currentState!.validate()){
                                        var network = Provider.of<WebServices>(context, listen: false);
                                        circularCustom(context);
                                        network.CategoryUpload(
                                          context: context,
                                          categoryName: name,
                                          vendorID: vendorID,
                                            vendorname:vendorname,
                                        );
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
