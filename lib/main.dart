import 'package:flutter/material.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Provider/VendorProvider.dart';
import 'package:fybe/Screen/Splash.dart';
import 'package:fybe/Screen/Utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';




void main() async{
  await GetStorage.init();
  runApp(MyApp());
}



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crusher',
//       home: Container(
//
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<WebServices>(create: (_) => WebServices()),
          ChangeNotifierProvider<Utils>(create: (_) => Utils()),
          ChangeNotifierProvider<BankProvider>(create: (_) => BankProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: Colors.green.withOpacity(0.8),
            textTheme: GoogleFonts.ralewayTextTheme (
              Theme.of(context).textTheme,
            ),
          ),
          title: 'FYBE',
          home: SplashScreenApp(),
        ));
  }
}
