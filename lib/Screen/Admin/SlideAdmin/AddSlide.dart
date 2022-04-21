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


class AddSlide extends StatelessWidget {

  // widget.vendorname, widget.categoryID, widget.vendorID


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Slide', style: TextStyle(color: Colors.white),),
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
                    return Column(
                        children: <Widget>[





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
                                        if(Provider.of<Utils>(context, listen:false).selectedImage.path.isEmpty){
                                          showTextToast(
                                            text: "Image is required",
                                            context: context,
                                          );
                                        }else{
                                          var network = Provider.of<WebServices>(context, listen: false);
                                          //   Provider.of<Utils>(context, listen:false).selectedImage.path
                                          circularCustom(context);
                                          network.SlideUpload(
                                            context: context,
                                            path: Provider.of<Utils>(context, listen:false).selectedImage.path,
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
                    );
                  })
          ),
        ),
      ),
    );
  }
}
