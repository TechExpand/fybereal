// import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:fybe/Constant/Data.dart';
import 'package:fybe/Screen/Auth/SignIn.dart';
import 'package:fybe/Screen/Home/MAINHOME.dart';
import 'package:google_fonts/google_fonts.dart';

List<Map<String, String>> introData = [
  {'text': 'Choose your meal', 'image': 'assets/images/2.png'},
  {'text': 'make payment', 'image': 'assets/images/3.png'},
  {'text': 'fast delivery', 'image': 'assets/images/4.png'},
];

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int index = 0;
  PageController? controller;
  PageController? controller1;

  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    controller1 = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFCFFFD),
        child: Stack(
          children: [
            Positioned(
                right: 30,
                top: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SignIn();
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Color(0xFF303030)),
                    ),
                  ),
                )),
            Column(
              children: [
                Container(
                  height: 370,
                  child: PageView.builder(
                      controller: controller,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 100),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        child: Image.asset(
                                      "${introData[index]['image']}",
                                      fit: BoxFit.cover,
                                    )))),
                          ],
                        );
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0, bottom: 0),
                  height: 70,
                  child: PageView.builder(
                      controller: controller1,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 17.0, bottom: 8),
                              child: Text(
                                  "${introData[index]['text']}".toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFF364B41),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AnimatedContainer(
                            width: index == 0 ? 30 : 8,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 0
                                  ? Color(0xFF364B41)
                                  : Color(0xFFBBBBBB),
                            ),
                            duration: Duration(milliseconds: 400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AnimatedContainer(
                            width: index == 1 ? 30 : 8,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 1
                                  ? Color(0xFF364B41)
                                  : Color(0xFFBBBBBB),
                            ),
                            duration: Duration(milliseconds: 400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AnimatedContainer(
                            width: index == 2 ? 30 : 8,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 2
                                  ? Color(0xFF364B41)
                                  : Color(0xFFBBBBBB),
                            ),
                            duration: Duration(milliseconds: 400)),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: index == 0
                              ? () {
                                  print('meeee');
                                }
                              : index == 1
                                  ? () {
                                      controller!.jumpToPage(0);
                                      controller1!.jumpToPage(0);
                                    }
                                  : () {
                                      controller!.jumpToPage(1);
                                      controller1!.jumpToPage(1);
                                    },
                          child: Text(index == 0 ? 'Next' : 'Back',
                              style: TextStyle(color: Color(0xFF303030)))),
                      index != 2
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  shape: CircleBorder(),
                                  primary: Color(
                                    0xFF364B41,
                                  )),
                              child: Container(
                                width: 55,
                                height: 55,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Icon(
                                  Icons.double_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: index == 0
                                  ? () {
                                      controller!.jumpToPage(1);
                                      controller1!.jumpToPage(1);
                                    }
                                  : index == 1
                                      ? () {
                                          controller!.jumpToPage(2);
                                          controller1!.jumpToPage(2);
                                        }
                                      : () {
                                          print('meeee');
                                        },
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF364B41)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(54.0),
                                  ))),
                              child: Container(
                                width: 117,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Text('Get started'),
                              ),
                              onPressed: index == 0
                                  ? () {
                                      controller!.jumpToPage(1);
                                      controller1!.jumpToPage(1);
                                    }
                                  : index == 1
                                      ? () {
                                          controller!.jumpToPage(2);
                                          controller1!.jumpToPage(2);
                                        }
                                      : () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return MainHome();
                                              },
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                            )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
