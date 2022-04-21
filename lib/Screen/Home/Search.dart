import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fybe/Network/network.dart';
import 'package:fybe/Screen/Vendor/product.dart';
import 'package:fybe/Screen/Vendor/vendor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  var searchvalue;


  TextEditingController controller = new TextEditingController();



  @override
  Widget build(BuildContext context) {

    var widget = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search for a vendors or food',
            style: GoogleFonts.poppins(
                color: Color(0xFF5BA381),
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF5BA381)),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Hero(
              tag: 'searchButton',
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 15, left: 12, right: 12, top: 15),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFFF1F1FD)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFF1F1FD).withOpacity(0.5),
                          blurRadius: 15.0,
                          offset: Offset(0.3, 1.0))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: TextFormField(
                  autofocus: true,
                    onFieldSubmitted: (e){
                      setState(() {
                        searchvalue = e;
                        SearchResult(searchvalue.toString());
                      });
                    },
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF270F33),
                        fontWeight: FontWeight.w600),

                    decoration: InputDecoration.collapsed(
                      hintText: 'What are you looking for?',
                      hintStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      focusColor: Color(0xFF2B1137),
                      fillColor: Color(0xFF2B1137),
                      hoverColor: Color(0xFF2B1137),
                    ),
                    ),
              )),
          SearchResult(searchvalue),
        ],
      ),
    );

    return widget;
  }
}

class SearchResult extends StatefulWidget {
  final searchValue;

  SearchResult(this.searchValue);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  ScrollController scrollController = ScrollController();
  bool determineClosed(start, end){
    var value = false;
    var hour = DateTime.now().hour;
    var df =  DateFormat("h:mma");

    var formatedEndTime = df.parse(end.toString().toUpperCase()).hour;
    // var formatedEndTime =  DateFormat('h').format(enddt);

    var formatedStartTime = df.parse(start.toString().toUpperCase()).hour;
    // var formatedStartTime =  DateFormat('h').format(startdt);

    if(hour > formatedEndTime || hour <   formatedStartTime){
      value = true;
      print(hour);
      print(formatedStartTime);
    }else{
      value = false;
    }
    return value;
  }


  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
  //  var location = Provider.of<LocationService>(context);
    return FutureBuilder(
      future: network.searchV1(
        searchquery: widget.searchValue,
        context: context,
      ),
      builder: (context,AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Expanded(
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/loader.gif",
                    fit: BoxFit.cover,
                  ),
                  height: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Loading',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            )))
            : widget.searchValue == '' || widget.searchValue == null
            ? Expanded(
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Search for any vendor or food.',  style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
            )))
            : !snapshot.hasData
            ? Expanded(
            child: Center(child: Theme(
                data: Theme.of(context)
                    .copyWith(accentColor: Color(0xFF5BA381)),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5BA381)),
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                )),))
            : snapshot.hasData && snapshot.data.length != 0
            ? Expanded(
          child:  StaggeredGridView.countBuilder(
            //   itemExtent: 2000,
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return snapshot.data[index].status=='vendor'?InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return VendorPage(snapshot.data[index], determineClosed(snapshot.data[index].start.toString(), snapshot.data[index].end.toString()));
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );

                    network.setVendor(snapshot.data[index].id);
                  },
                  child: Container(
                    // height: 100,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(
                            Radius.circular(18))
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(18)),
                      child: Card(
                        child: GridTile(
                          child: Stack(
                            children: [
                              FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: '${snapshot.data[index].image}',fit: BoxFit.cover,),
                              determineClosed(snapshot.data[index].start.toString(), snapshot.data[index].end.toString())?ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Container(
                                    color: Colors.black54,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('CLOSED',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text('opens at: ${snapshot.data[index].start.toString()}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ))),
                              ):Container(),
                            ],
                          ),
                          footer: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  Text("${snapshot.data[index].name}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("Delivery fee: ₦${snapshot.data[index].deliveryfee}", style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight
                                          .w400),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    height: 22,
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${snapshot.data[index].deliverytime} min',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                              12,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ProductPage(snapshot.data[index], specialty: 'search',);
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
                  child: Container(
                    // height: 100,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(
                            Radius.circular(18))
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(18)),
                      child: Card(
                        child: GridTile(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: "${snapshot.data[index].image}",fit: BoxFit.cover,),
                          footer: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  Text("${snapshot.data[index].name}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("Price: ₦${snapshot.data[index].price}", style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    height: 22,
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Text(
                                          '${snapshot.data[index].vendortitle}',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                              12,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) {
                return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
              }) ,
        )
            : snapshot.data.length == 0
            ? Expanded(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Item/Vendors Not Found', style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
                )))
            : Expanded(child: Center(child: Text('')));
      },
    );
  }

}
