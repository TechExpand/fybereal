import 'package:flutter/material.dart';
import 'package:fybe/Screen/Admin/TrendingAdmin/TrendignList.dart';
import 'package:fybe/Screen/Admin/VendorAdmin/VendorList.dart';

import 'RecomendaAdmin/RecomendedList.dart';
import 'SlideAdmin/SlideList.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Image.asset(
                  "assets/images/icons.png",
                  fit: BoxFit.cover,
                ),
                color: Color(0xFF0D833C),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView(
                  // shrinkWrap: true,
                  // physics: ScrollPhysics(),
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 40.0, left: 13, right: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_left_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text('ADMIN MANAGER', style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),),
                          Text('')
                        ],
                      ),
                    ),



                  ],
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return  VendorList();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.label_important),
                title: Text('VENDOR', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return  TrendingList();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.label_important),
                title: Text('TRENDING FOOD', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),




          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return  RecomnededList();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.label_important),
                title: Text('RECOMMENDED FOOD', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return  SlideList();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.label_important),
                title: Text('SLIDE ADS', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
