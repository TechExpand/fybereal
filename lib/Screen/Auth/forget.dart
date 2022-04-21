
import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:provider/provider.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({Key? key}) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  TextEditingController email = TextEditingController();
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace_rounded, color: Colors.black,),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,top: 20, right: 20),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Color(0xFF3A843D),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0, bottom: 25),
                  child: Text('Enter your email address associated with your account.',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black45)),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0, bottom: 8),
                  child: Form(
                    key: formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          child: TextFormField(
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Email is Required';
                              }
                              return null;
                            },
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              suffix: Icon(Icons.email_outlined, color: Colors.grey,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              hintText: "Email",
                            ),
                          ),
                        ),
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
                                child: Text('SUBMIT'),
                              ),
                              onPressed: () {
                                if (formKey2.currentState!.validate()) {
                                  circularCustom(context);
                                  var network = Provider.of<WebServices>(context, listen: false);
                                  network.Reset(
                                    context: context,
                                    email: email.text,
                                  );

                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
