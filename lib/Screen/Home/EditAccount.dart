import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';

import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
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
    var network = Provider.of<WebServices>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF0D833C),
          title: Text('Edit Account'),
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
        body: Container(
          color: Colors.white,
          child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:15.0, bottom: 8, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:5.0),
                      child: Text('Full Name'),
                    ),
                    Container(
                      height: 50,
                      child: InkWell(
                        onTap: (){
                          _editFullName(network.fullname);
                        },
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
                    ),

                  ],
                ),
              ),



              // Padding(
              //   padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(bottom:5.0),
              //         child: Text('Password'),
              //       ),
              //       Container(
              //         height: 50,
              //         child: InkWell(
              //           onTap: (){
              //             _editFullName('sss');
              //           },
              //           child: TextFormField(
              //             enabled: false,
              //             obscureText: true,
              //             decoration: InputDecoration(
              //               suffix: Icon(Icons.remove_red_eye, color: Colors.grey,),
              //               disabledBorder:  OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(6.0),
              //                 borderSide: BorderSide(color: Colors.black45)
              //               ),
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(6.0),
              //               ),
              //               hintStyle: TextStyle(color: Colors.grey[400]),
              //               hintText: "***********",
              //             ),
              //           ),
              //         ),
              //       ),
                    Padding(
                      padding: const EdgeInsets.only(top:30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style:  ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFF173D1E)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  )
                              )
                          ),

                          child: Container(
                            width: 300,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                            child:  Text("Done"),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),





            ],
          ),
        ));
  }



  void _editFullName(fullname) {
    final _controller = TextEditingController();
    _controller.text = fullname;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
                height: 170.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.transparent,
                child: ListView(
                  children: [
                    Text(
                      "Edit fullname",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFF1F1FD)),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: 'First Name',
                          hintStyle:
                          TextStyle(fontSize: 16, color: Colors.black38),
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
                          disabledColor: Color(0xFF0D833C),
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
                        width: 20,
                      ),
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFE9E9E9), width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0xFF0D833C),
                          onPressed: () async {
                            await network.updateFullName(
                                context:  context, fullname: _controller.text);
                            // update(context);
                            // setState(() {});
                            Navigator.pop(context);
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
                                "Save",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
                  ],
                )),
          );
        });
  }
}
