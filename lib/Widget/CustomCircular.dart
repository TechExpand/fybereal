


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



bool shouldPop = false;

circularCustom(context)async{
  return showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope (
          onWillPop: () async {
            return shouldPop;
          },
          child: Dialog(
            elevation: 0,
            child:  CupertinoActivityIndicator(
              radius: 30,
            ),
            backgroundColor: Colors.transparent,
          ),
        );
      });
}








sendDialog(context, {agent}){
  showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builder){
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: new StatefulBuilder(
                  builder: (context, setState) {
                    return new Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                          child: Container(
                            color: Colors.transparent,
                            height: 260,
                            child: Stack(
                              children: [
                                Align(
                                  alignment:Alignment.bottomCenter ,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                                        color: Colors.white
                                    ),
                                    height: 230.0,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // SizedBox(
                                              //   width: MediaQuery.of(context).size.width*0.3,
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:25.0,),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width*0.8,
                                                  child: Text('Successful!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 18,
                                                        color: Colors.black, fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top:20.0, left: 10),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.8,
                                            child: Text('Congrats, your wallet and that of the user has been credited successfully.',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:10.0, left: 20, right:20),
                                          child: ElevatedButton(
                                            style:  ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Color(0xFF00A85A)),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(54.0),
                                                    )
                                                )
                                            ),

                                            child: Container(
                                              width: 250,
                                              height: 55,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                                              child: Text('Home'),
                                            ),
                                            onPressed: () {
                                              // Navigator.pushAndRemoveUntil(context,
                                              //     PageRouteBuilder(
                                              //       pageBuilder: (context, animation, secondaryAnimation) {
                                              //         return agent=='agent'?AgentTab():HomePageTab();
                                              //       },
                                              //       transitionsBuilder:
                                              //           (context, animation, secondaryAnimation, child) {
                                              //         return FadeTransition(
                                              //           opacity: animation,
                                              //           child: child,
                                              //         );
                                              //       },
                                              //     ), (route) => false);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    elevation: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00A85A),
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color:Colors.white,width: 10),
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Center(
                                        child: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.phone , color: Colors.white,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));}),
            ),
          ),
        );
      }
  );
}