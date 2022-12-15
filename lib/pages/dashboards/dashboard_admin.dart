import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:navkar_tracker/pages/phase2/mark_location.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/alerts.dart';
import '../../utils/app_properties.dart';
import '../../utils/my_flutter_app_icons.dart';

import '../phase1/combine_page.dart';
import '../phase1/dmr_page.dart';

import '../phase2/billing_page.dart';
import '../phase2/collection_page.dart';
import '../phase2/outstanding/outstanding_page.dart';
import '../phase2/performance_page.dart';

class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin>{

  String versionName, versionCode;

  @override
  void initState() {
    getVersion();
    getDashboardDetails();
    super.initState();
  }

  getVersion() async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
      versionCode = packageInfo.buildNumber;
    });
    print("versions $versionCode $versionName");

  }

  getDashboardDetails() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt("UserID");
    print("id value of the user $id");
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: (){
        Alerts.showExit(context, "Exit", "Are you sure?");
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
          appBar: _appBar(),
          body:
          ListView(
            // crossAxisCount: 2,
            // crossAxisSpacing: 10.0,
            // mainAxisSpacing: 10.0,
            //padding: EdgeInsets.all(8),
            children: <Widget>[
              // SizedBox(height: 10,),
              // Container(height: 100,
              //     width: MediaQuery.of(context).size.width,
              //     child:
              // _buildTile(
              //   Container(
              //     height:100,
              //
              //   child: Padding(
              //     padding: const EdgeInsets.all(10),
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: <Widget>[
              //               //Text('Container Freight Stations', style: TextStyle(color: Colors.blueAccent)),
              //               Text('Combined\nMovement Report',
              //                 //textAlign: TextAlign.center,
              //                 style: GoogleFonts.montserrat(
              //                     textStyle: TextStyle(
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.w500,
              //                       color: Colors.black,)),
              //               )
              //             ],
              //           ),
              //           Material(
              //               color: Colors.blue,
              //               shape: CircleBorder(),
              //               child: Center(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(12),
              //                     child: Image.asset("assets/report.png",height: 47,width: 47,),
              //                     //Icon(MyFlutterApp.container, color: Colors.white, size: 45.0),
              //                   )
              //               )
              //           )
              //         ]
              //     ),
              //   )),
              //   onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CombinePage())),
              // )),

              SizedBox(height: 10,),
          Row(children: [ Container(height: 150,
              width: MediaQuery.of(context).size.width/2-5,
              child:_buildTile(
                Column(
                  children: [
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Colors.lime,
                                shape: CircleBorder(),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset("assets/glance.png",height: 50,width: 50,),
                                      //Icon(MyFlutterApp.shipping_container, color: Colors.white, size: 45.0),
                                    )
                                )
                            ),
                            SizedBox(height: 10,),
                            Text('Today\'s\nAt a Glance',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,)),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DmrPage())),
              )),
            SizedBox(width: 10,),
            Container(height: 150,
                width: MediaQuery.of(context).size.width/2-5,
                child:_buildTile(
                  Column(
                    children: [
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                  color: Colors.redAccent,
                                  shape: CircleBorder(),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: SvgPicture.asset("assets/money.svg", height: 41, width: 41,),
                                        //Image.asset("assets/outstanding.png",height: 40,width: 40,),

                                        //SvgPicture.asset("assets/outstanding.png",height: 47,width: 47,color: Colors.black,),
                                      )
                                  )
                              ),
                              SizedBox(height: 10,),
                              Text('Outstanding',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,)),
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OutStandingPage())),
                )),],),
              SizedBox(height: 10,),


              Row(children: [
            Container(height: 150,
                width: MediaQuery.of(context).size.width/2-5,
                child:_buildTile(
                  Column(
                    children: [
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Material(
                                  color: Colors.deepPurpleAccent,
                                  shape: CircleBorder(),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset("assets/billing.png",height: 50,width: 50,),

                                        //Icon(MyFlutterApp.description, color: Colors.white, size: 30.0),
                                      )
                                  )
                              ),
                              SizedBox(height: 10,),
                              Text('Last 12 Months\' Billing',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,)),
                              )
                            ]
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillingPage())),
                )),
            SizedBox(width: 10,),

            Container(height: 150,
                width: MediaQuery.of(context).size.width/2-5,
                child: _buildTile(
                    Column(
                      children: [
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                  color: Colors.redAccent.shade700,
                                  shape: CircleBorder(),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset("assets/collections.png",height: 47,width: 47,),

                                        //Icon(MyFlutterApp.collections, color: Colors.white, size: 30.0),
                                      )
                                  )
                              ),
                              SizedBox(height: 10,),
                              Text('Collections',
                                //textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      var now = new DateTime.now();
                      var formatter = new DateFormat('yyyy-MM-dd');
                      String formattedDate = formatter.format(now);
                      print(formattedDate);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CollectionPage(date: formattedDate, page: 0,)));
                    }
                )),
          ],),
              SizedBox(height: 10,),



              Container(height: 100,
                  width: MediaQuery.of(context).size.width,
            child:_buildTile(
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Sales Person\nPerformance',
                              //textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,)),
                            ),
                          ]
                      ),
                      Material(
                          color: Colors.amberAccent,
                          shape: CircleBorder(),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset("assets/sales.png",height: 47,width: 47,)
                                //Icon(MyFlutterApp.person, color: Colors.white, size: 45.0),
                              )
                          )
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PerformancePage())),
            )),
              SizedBox(height: 10,),
              Container(height: 100,
                  width: MediaQuery.of(context).size.width,
                  child:_buildTile(
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Mark\nLocation',
                                  //textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,)),
                                ),
                              ]
                          ),
                          Material(
                              color: Colors.cyan,
                              shape: CircleBorder(),
                              child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("assets/mark_location.png",height: 40,width: 40,)
                                    //Icon(MyFlutterApp.person, color: Colors.white, size: 45.0),
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MarkLocationPage())),
                  )),
            ],
            /*staggeredTiles: [
              StaggeredTile.extent(2, 100.0),
              StaggeredTile.extent(1, 137.0),
              StaggeredTile.extent(1, 137.0),
              StaggeredTile.extent(1, 140.0),
              StaggeredTile.extent(1, 140.0),
              StaggeredTile.extent(2, 100.0),
            ],*/
          ),
          // Column(
          //   // crossAxisCount: 2,
          //   // crossAxisSpacing: 10.0,
          //   // mainAxisSpacing: 10.0,
          //   //padding: EdgeInsets.all(8),
          //   children: <Widget>[
          //     StaggeredGridTile.fit(crossAxisCellCount: 2, child:
          //     _buildTile(
          //       Container(
          //           height:100,
          //
          //           child: Padding(
          //             padding: const EdgeInsets.all(20),
          //             child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: <Widget>[
          //                   Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: <Widget>[
          //                       //Text('Container Freight Stations', style: TextStyle(color: Colors.blueAccent)),
          //                       Text('Combined\nMovement Report',
          //                         //textAlign: TextAlign.center,
          //                         style: GoogleFonts.montserrat(
          //                             textStyle: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.w500,
          //                               color: Colors.black,)),
          //                       )
          //                     ],
          //                   ),
          //                   Material(
          //                       color: Colors.blue,
          //                       shape: CircleBorder(),
          //                       child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8),
          //                             child: Icon(MyFlutterApp.container, color: Colors.white, size: 45.0),
          //                           )
          //                       )
          //                   )
          //                 ]
          //             ),
          //           )),
          //       onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CombinePage())),
          //     )),
          //     StaggeredGridTile.fit(crossAxisCellCount: 1,
          //         child:_buildTile(
          //           Padding(
          //             padding: const EdgeInsets.all(10),
          //             child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: <Widget>[
          //                   Material(
          //                       color: Colors.lime,
          //                       shape: CircleBorder(),
          //                       child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8),
          //                             child: Image.asset("assets/glance.png",height: 50,width: 50,),
          //                             //Icon(MyFlutterApp.shipping_container, color: Colors.white, size: 45.0),
          //                           )
          //                       )
          //                   ),
          //                   Text('Today\'s\nAt a Glance',
          //                     textAlign: TextAlign.center,
          //                     style: GoogleFonts.montserrat(
          //                         textStyle: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.w500,
          //                           color: Colors.black,)),
          //                   ),
          //                 ]
          //             ),
          //           ),
          //           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DmrPage())),
          //         )),
          //     StaggeredGridTile.fit(crossAxisCellCount: 1,
          //         child:_buildTile(
          //           Padding(
          //             padding: const EdgeInsets.all(20),
          //             child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: <Widget>[
          //                   Material(
          //                       color: Colors.redAccent,
          //                       shape: CircleBorder(),
          //                       child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(10),
          //                             child: SvgPicture.asset("assets/indian.svg",height: 45,width: 45,color: Colors.white,),
          //                           )
          //                       )
          //                   ),
          //                   Text('Outstanding',
          //                     textAlign: TextAlign.center,
          //                     style: GoogleFonts.montserrat(
          //                         textStyle: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.w500,
          //                           color: Colors.black,)),
          //                   ),
          //                 ]
          //             ),
          //           ),
          //           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OutStandingPage())),
          //         )),
          //     StaggeredGridTile.fit(crossAxisCellCount: 1,
          //         child:_buildTile(
          //           Padding(
          //             padding: const EdgeInsets.all(10),
          //             child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: <Widget>[
          //                   Material(
          //                       color: Colors.deepPurpleAccent,
          //                       shape: CircleBorder(),
          //                       child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8),
          //                             child: Icon(MyFlutterApp.description, color: Colors.white, size: 30.0),
          //                           )
          //                       )
          //                   ),
          //                   Text('Last 12 Months\' Billing',
          //                     textAlign: TextAlign.center,
          //                     style: GoogleFonts.montserrat(
          //                         textStyle: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.w500,
          //                           color: Colors.black,)),
          //                   )
          //                 ]
          //             ),
          //           ),
          //           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillingPage())),
          //         )),
          //     StaggeredGridTile.fit(crossAxisCellCount: 1,
          //         child: _buildTile(
          //             Padding(
          //               padding: const EdgeInsets.all(15),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: <Widget>[
          //                   Material(
          //                       color: Colors.redAccent.shade700,
          //                       shape: CircleBorder(),
          //                       child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(15),
          //                             child: Icon(MyFlutterApp.collections, color: Colors.white, size: 30.0),
          //                           )
          //                       )
          //                   ),
          //                   Text('Collections',
          //                     //textAlign: TextAlign.center,
          //                     style: GoogleFonts.montserrat(
          //                         textStyle: TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.w500,
          //                           color: Colors.black,)),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             onTap: () {
          //               var now = new DateTime.now();
          //               var formatter = new DateFormat('yyyy-MM-dd');
          //               String formattedDate = formatter.format(now);
          //               print(formattedDate);
          //               Navigator.of(context).push(MaterialPageRoute(builder: (_) => CollectionPage(date: formattedDate, page: 0,)));
          //             }
          //         )),
          //     StaggeredGridTile.fit(crossAxisCellCount: 2,
          //         child:_buildTile(
          //           Padding(
          //             padding: const EdgeInsets.all(10),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: <Widget>[
          //                       Text('Sales Person\nPerformance',
          //                         //textAlign: TextAlign.center,
          //                         style: GoogleFonts.montserrat(
          //                             textStyle: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.w500,
          //                               color: Colors.black,)),
          //                       ),
          //                     ]
          //                 ),
          //                 Material(
          //                     color: Colors.amberAccent,
          //                     shape: CircleBorder(),
          //                     child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(10),
          //                           child: Icon(MyFlutterApp.person, color: Colors.white, size: 45.0),                                )
          //                     )
          //                 ),
          //               ],
          //             ),
          //           ),
          //           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PerformancePage())),
          //         )),
          //   ],
          //   /*staggeredTiles: [
          //     StaggeredTile.extent(2, 100.0),
          //     StaggeredTile.extent(1, 137.0),
          //     StaggeredTile.extent(1, 137.0),
          //     StaggeredTile.extent(1, 140.0),
          //     StaggeredTile.extent(1, 140.0),
          //     StaggeredTile.extent(2, 100.0),
          //   ],*/
          // ),
          bottomSheet: Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 3, top: 3),
                color: Colors.black54,
                height: 20,
                child: Center(
                  child: Text("tracker for Adani ICD Tumb  version: $versionName",
                  style:
                  GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,))
                  ),
                )
              ),
            ],
          )
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }

  Widget _appBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Dashboard", style: headingBar),
      actions: [
        IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              Alerts.showLogOut(context, "LogOut", "Are you sure?");
            }),
      ],
    );
  }
}