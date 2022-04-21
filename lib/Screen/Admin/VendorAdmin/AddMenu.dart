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


class AddMenu extends StatelessWidget {
 var vendorname;
 var vendorID;
 var categoryID;
  AddMenu(this.vendorname, this.categoryID, this.vendorID);

 // widget.vendorname, widget.categoryID, widget.vendorID

  final form_key = GlobalKey<FormState>();

  var name = '';
  var description = '';
  var price = '';
  var containerAmount = "";
  var container = "";
  // var deliverytime = '';

  @override
  Widget build(BuildContext context) {

    Widget myPopMenu() {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
          width: 250,
            child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(container.isEmpty?"Select Container":container=="false"?"No":'Yes'),
                PopupMenuButton(
                  onSelected: (value){
                    setState((){
                      container = value.toString();
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down_circle_outlined),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: "true",
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                child: Icon(Icons.check_circle_outlined),
                              ),
                              Text('Yes')
                            ],
                          )),
                      PopupMenuItem(
                          value: "false",
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                child: Icon(Icons.cancel_outlined),
                              ),
                              Text('No')
                            ],
                          )),
                    ]),
              ],
            ),
          );
        }
      );
    }

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Menu', style: TextStyle(color: Colors.white),),
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
                                    return 'Menu name is Required';
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
                                  labelText: 'Menu name',
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
                                    return 'description is Required';
                                  } else {
                                    description = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Menu Description',
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
                                    return 'price is Required';
                                  } else {
                                    price = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Price',
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
                          myPopMenu(),
                          Container(
                              width: 250,
                              child: Divider(color: Colors.black,)),
                          Container(
                            padding: EdgeInsets.only( bottom:10),
                            width: 250,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Container amount is Required';
                                  } else {
                                    containerAmount = value;
                                    return null;
                                  }
                                },
                                style: TextStyle(color: Colors.black87),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(color: Colors.black87, fontSize: 15),
                                  labelText: 'Container Amount',
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
                                        if(Provider.of<Utils>(context, listen:false).selectedImage.path.isEmpty){
                                          showTextToast(
                                            text: "Field is required",
                                            context: context,
                                          );
                                        }else if(container == ""){
                                          showTextToast(
                                            text: "Field is required",
                                            context: context,
                                          );
                                        }
                                        else{
                                          var network = Provider.of<WebServices>(context, listen: false);
                                          //   Provider.of<Utils>(context, listen:false).selectedImage.path
                                          circularCustom(context);
                                          network.MenuUpload(
                                            context: context,
                                            description: description,
                                            price: price,
                                            categoryID: categoryID,
                                            vendorID: vendorID,
                                            vendorname: vendorname,
                                            name: name,
                                            path: Provider.of<Utils>(context, listen:false).selectedImage.path,
                                            container: container,
                                            containerAmount: containerAmount,
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
