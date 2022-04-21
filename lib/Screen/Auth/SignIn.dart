import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Auth/forget.dart';

import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:fybe/Widget/CustomCircular.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final data;
   SignIn({Key? key, this.data}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late PageController controller;
 late int index;
  bool showPassword = true ;
  bool showPassword2 = true ;
TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  final formKey2 = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    index = widget.data==null?0:1;
    controller = PageController(initialPage: widget.data==null?0:widget.data, viewportFraction: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:  Container(
            color: Colors.white,
      child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: ScrollPhysics(),
          children: [
            SizedBox(
              height: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_backspace_rounded, color: Colors.black,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 120,
                      // height: 120,
                      child: Image.asset(
                        "assets/images/fybe2.png",
                        fit: BoxFit.contain,
                      )),
                ),
                Text(
                  ""
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register'.toUpperCase(),style: TextStyle(fontSize: 14),),
                          index==0?Container(
                            width: 50,
                            height: 3,
                            color: Color(0xFF173D1E),
                          ):Container()
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        index = 0;
                        controller.jumpToPage(0);
                      });

                    },
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        index = 1;
                        controller.jumpToPage(1);
                      });

                    },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sign In'.toUpperCase(),style: TextStyle(fontSize: 14),),
                            index==1?Container(
                              width: 50,
                              height: 3,
                              color: Color(0xFF173D1E),
                            ):Container()
                          ],
                        ),
                      ),
                      ),

                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:33.0, bottom: 8, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text('Full Name'),
                              ),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fullname is Required';
                                    }
                                    return null;
                                  },
                                  controller: fullname,
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
                                    hintText: "john",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text('Email'),
                              ),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is Required';
                                    }
                                    return null;
                                  },
                                  controller: email,
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
                                    hintText: "example@gmail.com",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text('Password'),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    height: 60,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password is Required';
                                        }
                                        return null;
                                      },
                                      controller: password,
                                      obscureText: showPassword2,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        suffixIcon: InkWell(
                                            onTap: (){
                                              setState((){
                                                if(showPassword2){
                                                  showPassword2 = false;
                                                }else{
                                                  showPassword2 = true;
                                                }
                                              });
                                            },
                                            child: Icon(showPassword2?FeatherIcons.eyeOff:FeatherIcons.eye, color: Colors.grey,)),
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
                                        hintText: "*********",
                                      ),
                                    ),
                                  );
                                }
                              ),

                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text('Confirm Password'),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    height: 60,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Confirm Password is Required';
                                        }
                                        return null;
                                      },
                                      controller: confirmPassword,
                                      obscureText: showPassword,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            onTap: (){
                                              setState((){
                                                if(showPassword){
                                                  showPassword = false;
                                                }else{
                                                  showPassword = true;
                                                }
                                              });
                                            },
                                            child: Icon(showPassword?FeatherIcons.eyeOff:FeatherIcons.eye, color: Colors.grey,)),
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
                                        hintText: "***********",
                                      ),
                                    ),
                                  );
                                }
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
                                      child: Icon(Icons.arrow_forward),
                                    ),
                                    onPressed: () {
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (formKey.currentState!.validate()) {

                                        if(password.text == confirmPassword.text){
                                          circularCustom(context);
                                          var network = Provider.of<WebServices>(context, listen: false);
                                          network.SignUp(
                                            context: context,
                                            fullname: fullname.text,
                                            email: email.text,
                                            password: password.text ,
                                          );
                                        }else{
                                          showTextToast(
                                            text: 'password does not match',
                                            context: context,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(top:20.0),
                        //       child: Text('Or join with Google'),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //           width: 30,
                        //           height: 30,
                        //           child: Image.asset(
                        //             "assets/images/google.png",
                        //             fit: BoxFit.contain,
                        //           )),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),




                  Form(
                    key: formKey2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text('Email'),
                              ),
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
                                    hintText: "example@gmail.com",
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),



                       StatefulBuilder(
                         builder: (context, setState) {

                           return Padding(
                                padding: const EdgeInsets.only(top:8.0, bottom: 8, left: 16, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:5.0),
                                      child: Text('Password'),
                                    ),
                                    Container(
                                      height: 60,
                                      child: TextFormField(
                                        validator: (value){
                                          if (value == null || value.isEmpty) {
                                            return 'Password is Required';
                                          }
                                          return null;
                                        },
                                        controller: password,
                                        obscureText: showPassword,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                              onTap: (){
                                                setState((){
                                                  if(showPassword){
                                                    showPassword = false;
                                                  }else{
                                                    showPassword = true;
                                                  }
                                                });
                                              },
                                              child: Icon(showPassword?FeatherIcons.eyeOff:FeatherIcons.eye, color: Colors.grey,)),
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
                                          hintText: "***********",
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
                                            child: Icon(Icons.arrow_forward),
                                          ),
                                          onPressed: () {
                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            if (formKey2.currentState!.validate()) {
                                                circularCustom(context);
                                                var network = Provider.of<WebServices>(context, listen: false);
                                                network.Login(
                                                  context: context,
                                                  email: email.text,
                                                  password: password.text ,
                                                );

                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            );
                         }
                       ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return ForgetPass();
                                      },
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                  child: Text('Forgot password?', style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF173D1E)),),
                                ),
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
      ),
    ),
        );
  }
}
