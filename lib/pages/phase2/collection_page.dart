import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:navkar_tracker/bloc/collection_bloc.dart';
import 'package:navkar_tracker/models/collection_model.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_account.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_admin.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_operation.dart';
import 'package:navkar_tracker/utils/alerts.dart';
import 'package:navkar_tracker/utils/app_properties.dart';
import 'package:navkar_tracker/globalVariables.dart'as globals;
import 'package:shared_preferences/shared_preferences.dart';

class CollectionPage extends StatefulWidget {

  final String date;

  final int page;

  CollectionPage({this.date, this.page});

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {

  final icdBloc = CollectionBloc();
  final cfsBloc = CollectionBloc();

  AsyncSnapshot<CollectionModel> asi, asc;
  final format = DateFormat("yyyy-MM-dd");
  SharedPreferences prefs;
  String userType;

  @override
  initState(){
    super.initState();
    initRole();
    print("date retrieved ${widget.date}");
    icdBloc.fetchICDCollection(widget.date);
    cfsBloc.fetchCFSCollection(widget.date);


  }

  @override
  void dispose() {
    super.dispose();
    icdBloc.dispose();
    cfsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar:_appBar(),
      body: _body(),
    );
  }

  Widget _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          // if(globals.Role == "Admin"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
          // }
          // if(globals.Role == "Accounts"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
          // }
          // if(globals.Role == "Operations"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
          // }

          if(userType == "Admin"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
          }
          if(userType == "Accounts"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
          }
          if(userType == "Operations"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
          }
        }
        ,),
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Collection",
        style: headingBar,),
      actions: [
        IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              Alerts.showLogOut(context, "LogOut", "Are you sure?");
            }),
      ],
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DateTimeField(
              format: format,
              textAlign: TextAlign.center,
              onChanged: (value){
                print("on changed ${value.toString().replaceRange(10, 23, "")}");
                String date = value.toString().replaceRange(10, 23, "");
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CollectionPage(date: date, page: 1,)));
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.date,
              ),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now());
              },
            ),
          ),
          // SizedBox(height: 5,),
          StreamBuilder<CollectionModel>(
              stream: icdBloc.icdStream,
              builder: (c, si) {
                asi = si;
                return StreamBuilder<CollectionModel>(
                    stream: cfsBloc.cfsStream,
                    builder: (c, sc) {
                      asc = sc;

                      if (asi.connectionState != ConnectionState.active || asc.connectionState != ConnectionState.active) {
                        print("all connection");
                        return Container(height : 300, alignment: Alignment.center, child: Center(heightFactor: 50, child: CircularProgressIndicator(),));
                      }
                      if (asc.hasError && asi.hasError) {
                        print("as3 error");
                        return Container(height: 300, alignment: Alignment.center, child: Text("Error Loading Data", style: content,),);
                      }
                      if (asc.data.toString().isEmpty && asi.data.toString().isEmpty) {
                        print("as3 empty");
                        return Container(height: 300, alignment: Alignment.center, child: Text("No Data Found", style: content,),);
                      }
                      return Container(
                        alignment: Alignment.topCenter,
                        child:
                        asc.data.collection.isNotEmpty ?

                        // Container(
                        //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //         height: MediaQuery.of(context).size.height,
                        //         child: HorizontalDataTable(
                        //           leftHandSideColumnWidth: 100,
                        //           rightHandSideColumnWidth: 800,
                        //           isFixedHeader: true,
                        //           headerWidgets:[
                        //             Container(
                        //                 height: 50,
                        //                 decoration: BoxDecoration(
                        //                   color: Colors.green,
                        //                   border: Border.all(color: Colors.white),),
                        //                 child: Container(
                        //                   child: Text('Events',
                        //                     style: content1,
                        //                     textAlign: TextAlign.center,),
                        //                   alignment: Alignment.center,)),
                        //             // Expanded(
                        //             //   child: Container(
                        //             //     height: 50,
                        //             //     decoration: BoxDecoration(
                        //             //       color: Colors.green,
                        //             //       border: Border.all(color: Colors.white),
                        //             //     ),
                        //             //     child: Row(
                        //             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             //       mainAxisSize: MainAxisSize.min,
                        //             //       children: [
                        //             //         Expanded(
                        //             //           child: Container(
                        //             //             child: Text('Cash',
                        //             //               style: content1,
                        //             //               textAlign: TextAlign.center,),
                        //             //             alignment: Alignment.center,
                        //             //           ),
                        //             //         ),
                        //             //         Expanded(
                        //             //           child: Container(
                        //             //             child: Text('Cheque',
                        //             //               style: content1,
                        //             //               textAlign: TextAlign.center,),
                        //             //             alignment: Alignment.center,
                        //             //           ),
                        //             //         ),
                        //             //         Expanded(
                        //             //           child: Container(
                        //             //             child: Text('DD',
                        //             //               style: content1,
                        //             //               textAlign: TextAlign.center,),
                        //             //             alignment: Alignment.center,
                        //             //           ),
                        //             //         ),
                        //             //         Expanded(
                        //             //           child: Container(
                        //             //             child: Text('RTGS',
                        //             //               style: content1,
                        //             //               textAlign: TextAlign.center,),
                        //             //             alignment: Alignment.center,
                        //             //           ),
                        //             //         ),
                        //             //         Expanded(
                        //             //           child: Container(
                        //             //             child: Text('Total',
                        //             //               style: content1,
                        //             //               textAlign: TextAlign.center,),
                        //             //             alignment: Alignment.center,
                        //             //           ),
                        //             //         ),
                        //             //       ],
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //
                        //             Container(
                        //               height: 50,
                        //               // decoration: BoxDecoration(
                        //               //   color: Colors.green,
                        //               //   border: Border.all(color: Colors.white),
                        //               // ),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                 mainAxisSize: MainAxisSize.min,
                        //                 children: [
                        //                   Container(
                        //                     child: Text('Cash',
                        //                       style: content1,
                        //                       textAlign: TextAlign.center,),
                        //                     alignment: Alignment.center,
                        //                     width: 160,
                        //                     decoration: const BoxDecoration(
                        //                         color: Colors.green,
                        //                         border: Border(
                        //                           right: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           top:  BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           bottom: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                        //                       // border: Border.all(color: Colors.white),
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     child: Text('Cheque',
                        //                       style: content1,
                        //                       textAlign: TextAlign.center,),
                        //                     alignment: Alignment.center,
                        //                     width: 160,
                        //                     decoration: const BoxDecoration(
                        //                         color: Colors.green,
                        //                         border: Border(
                        //                           right: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           top:  BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           bottom: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                        //                       // border: Border.all(color: Colors.white),
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     child: Text('DD',
                        //                       style: content1,
                        //                       textAlign: TextAlign.center,),
                        //                     alignment: Alignment.center,
                        //                     width: 160,
                        //                     decoration: const BoxDecoration(
                        //                         color: Colors.green,
                        //                         border: Border(
                        //                           right: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           top:  BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           bottom: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                        //                       // border: Border.all(color: Colors.white),
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     child: Text('RTGS',
                        //                       style: content1,
                        //                       textAlign: TextAlign.center,),
                        //                     alignment: Alignment.center,
                        //                     width: 160,
                        //                     decoration: const BoxDecoration(
                        //                         color: Colors.green,
                        //                         border: Border(
                        //                           right: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           top:  BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           bottom: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                        //                       // border: Border.all(color: Colors.white),
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     child: Text('Total',
                        //                       style: content1,
                        //                       textAlign: TextAlign.center,),
                        //                     alignment: Alignment.center,
                        //                     width: 160,
                        //                     decoration: const BoxDecoration(
                        //                         color: Colors.green,
                        //                         border: Border(
                        //                           right: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           top:  BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                           bottom: BorderSide( //                   <--- right side
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                        //                       // border: Border.all(color: Colors.white),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //           leftSideItemBuilder: _generateFirstColumnRow1,
                        //           rightSideItemBuilder: _generateRightHandSideColumnRow1,
                        //           itemCount: asc.data.collection.length,
                        //           rightHandSideColBackgroundColor: Colors.black,
                        //           leftHandSideColBackgroundColor: Colors.black,
                        //         ),
                        //       ),
                        //       SizedBox(height: 20,),
                        //     ],),
                        // ): Container(),

                        DescriptionView(
                            children : [
                              asi.data.collection.isNotEmpty ? Container(
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height,
                                      child: HorizontalDataTable(
                                        leftHandSideColumnWidth: 100,
                                        rightHandSideColumnWidth: 800,
                                        isFixedHeader: true,
                                        headerWidgets:[
                                          Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                border: Border.all(color: Colors.white),),
                                              child: Container(
                                                child: Text('Events',
                                                  style: content1,
                                                  textAlign: TextAlign.center,),
                                                alignment: Alignment.center,)),
                                          // Expanded(
                                          //   child: Container(
                                          //     height: 50,
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.green,
                                          //       border: Border.all(color: Colors.white),
                                          //     ),
                                          //     child: Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       mainAxisSize: MainAxisSize.min,
                                          //       children: [
                                          //         Expanded(
                                          //           child: Container(
                                          //             child: Text('Cash',
                                          //               style: content1,
                                          //               textAlign: TextAlign.center,),
                                          //             alignment: Alignment.center,
                                          //           ),
                                          //         ),
                                          //         Expanded(
                                          //           child: Container(
                                          //             child: Text('Cheque',
                                          //               style: content1,
                                          //               textAlign: TextAlign.center,),
                                          //             alignment: Alignment.center,
                                          //           ),
                                          //         ),
                                          //         Expanded(
                                          //           child: Container(
                                          //             child: Text('DD',
                                          //               style: content1,
                                          //               textAlign: TextAlign.center,),
                                          //             alignment: Alignment.center,
                                          //           ),
                                          //         ),
                                          //         Expanded(
                                          //           child: Container(
                                          //             child: Text('RTGS',
                                          //               style: content1,
                                          //               textAlign: TextAlign.center,),
                                          //             alignment: Alignment.center,
                                          //           ),
                                          //         ),
                                          //         Expanded(
                                          //           child: Container(
                                          //             child: Text('Total',
                                          //               style: content1,
                                          //               textAlign: TextAlign.center,),
                                          //             alignment: Alignment.center,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            height: 50,
                                            // decoration: BoxDecoration(
                                            //   color: Colors.green,
                                            //   border: Border.all(color: Colors.white),
                                            // ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  child: Text('Cash',
                                                    style: content1,
                                                    textAlign: TextAlign.center,),
                                                  alignment: Alignment.center,
                                                  width: 160,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      border: Border(
                                                        right: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        top:  BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        bottom: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    // border: Border.all(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text('Cheque',
                                                    style: content1,
                                                    textAlign: TextAlign.center,),
                                                  alignment: Alignment.center,
                                                  width: 160,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      border: Border(
                                                        right: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        top:  BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        bottom: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    // border: Border.all(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text('DD',
                                                    style: content1,
                                                    textAlign: TextAlign.center,),
                                                  alignment: Alignment.center,
                                                  width: 160,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      border: Border(
                                                        right: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        top:  BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        bottom: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    // border: Border.all(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text('RTGS',
                                                    style: content1,
                                                    textAlign: TextAlign.center,),
                                                  alignment: Alignment.center,
                                                  width: 160,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      border: Border(
                                                        right: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        top:  BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        bottom: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    // border: Border.all(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text('Total',
                                                    style: content1,
                                                    textAlign: TextAlign.center,),
                                                  alignment: Alignment.center,
                                                  width: 160,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      border: Border(
                                                        right: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        top:  BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                        bottom: BorderSide( //                   <--- right side
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    // border: Border.all(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                        leftSideItemBuilder: _generateFirstColumnRow,
                                        rightSideItemBuilder: _generateRightHandSideColumnRow,
                                        itemCount: asi.data.collection.length,
                                        rightHandSideColBackgroundColor: Colors.black,
                                        leftHandSideColBackgroundColor: Colors.black,
                                      ),
                                      ),
                                    SizedBox(height: 20,),
                                  ],),
                              ): Container(),
                              // asc.data.collection.isNotEmpty ? Container(
                              //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         height: MediaQuery.of(context).size.height,
                              //         child: HorizontalDataTable(
                              //           leftHandSideColumnWidth: 100,
                              //           rightHandSideColumnWidth: 800,
                              //           isFixedHeader: true,
                              //           headerWidgets:[
                              //             Container(
                              //                 height: 50,
                              //                 decoration: BoxDecoration(
                              //                   color: Colors.green,
                              //                   border: Border.all(color: Colors.white),),
                              //                 child: Container(
                              //                   child: Text('Events',
                              //                     style: content1,
                              //                     textAlign: TextAlign.center,),
                              //                   alignment: Alignment.center,)),
                              //             // Expanded(
                              //             //   child: Container(
                              //             //     height: 50,
                              //             //     decoration: BoxDecoration(
                              //             //       color: Colors.green,
                              //             //       border: Border.all(color: Colors.white),
                              //             //     ),
                              //             //     child: Row(
                              //             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             //       mainAxisSize: MainAxisSize.min,
                              //             //       children: [
                              //             //         Expanded(
                              //             //           child: Container(
                              //             //             child: Text('Cash',
                              //             //               style: content1,
                              //             //               textAlign: TextAlign.center,),
                              //             //             alignment: Alignment.center,
                              //             //           ),
                              //             //         ),
                              //             //         Expanded(
                              //             //           child: Container(
                              //             //             child: Text('Cheque',
                              //             //               style: content1,
                              //             //               textAlign: TextAlign.center,),
                              //             //             alignment: Alignment.center,
                              //             //           ),
                              //             //         ),
                              //             //         Expanded(
                              //             //           child: Container(
                              //             //             child: Text('DD',
                              //             //               style: content1,
                              //             //               textAlign: TextAlign.center,),
                              //             //             alignment: Alignment.center,
                              //             //           ),
                              //             //         ),
                              //             //         Expanded(
                              //             //           child: Container(
                              //             //             child: Text('RTGS',
                              //             //               style: content1,
                              //             //               textAlign: TextAlign.center,),
                              //             //             alignment: Alignment.center,
                              //             //           ),
                              //             //         ),
                              //             //         Expanded(
                              //             //           child: Container(
                              //             //             child: Text('Total',
                              //             //               style: content1,
                              //             //               textAlign: TextAlign.center,),
                              //             //             alignment: Alignment.center,
                              //             //           ),
                              //             //         ),
                              //             //       ],
                              //             //     ),
                              //             //   ),
                              //             // ),
                              //
                              //             Container(
                              //               height: 50,
                              //               // decoration: BoxDecoration(
                              //               //   color: Colors.green,
                              //               //   border: Border.all(color: Colors.white),
                              //               // ),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 mainAxisSize: MainAxisSize.min,
                              //                 children: [
                              //                   Container(
                              //                     child: Text('Cash',
                              //                       style: content1,
                              //                       textAlign: TextAlign.center,),
                              //                     alignment: Alignment.center,
                              //                     width: 160,
                              //                     decoration: const BoxDecoration(
                              //                         color: Colors.green,
                              //                         border: Border(
                              //                           right: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           top:  BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           bottom: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                         )
                              //                       // border: Border.all(color: Colors.white),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     child: Text('Cheque',
                              //                       style: content1,
                              //                       textAlign: TextAlign.center,),
                              //                     alignment: Alignment.center,
                              //                     width: 160,
                              //                     decoration: const BoxDecoration(
                              //                         color: Colors.green,
                              //                         border: Border(
                              //                           right: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           top:  BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           bottom: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                         )
                              //                       // border: Border.all(color: Colors.white),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     child: Text('DD',
                              //                       style: content1,
                              //                       textAlign: TextAlign.center,),
                              //                     alignment: Alignment.center,
                              //                     width: 160,
                              //                     decoration: const BoxDecoration(
                              //                         color: Colors.green,
                              //                         border: Border(
                              //                           right: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           top:  BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           bottom: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                         )
                              //                       // border: Border.all(color: Colors.white),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     child: Text('RTGS',
                              //                       style: content1,
                              //                       textAlign: TextAlign.center,),
                              //                     alignment: Alignment.center,
                              //                     width: 160,
                              //                     decoration: const BoxDecoration(
                              //                         color: Colors.green,
                              //                         border: Border(
                              //                           right: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           top:  BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           bottom: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                         )
                              //                       // border: Border.all(color: Colors.white),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     child: Text('Total',
                              //                       style: content1,
                              //                       textAlign: TextAlign.center,),
                              //                     alignment: Alignment.center,
                              //                     width: 160,
                              //                     decoration: const BoxDecoration(
                              //                         color: Colors.green,
                              //                         border: Border(
                              //                           right: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           top:  BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                           bottom: BorderSide( //                   <--- right side
                              //                             color: Colors.white,
                              //                           ),
                              //                         )
                              //                       // border: Border.all(color: Colors.white),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ],
                              //           leftSideItemBuilder: _generateFirstColumnRow1,
                              //           rightSideItemBuilder: _generateRightHandSideColumnRow1,
                              //           itemCount: asc.data.collection.length,
                              //           rightHandSideColBackgroundColor: Colors.black,
                              //           leftHandSideColBackgroundColor: Colors.black,
                              //         ),
                              //       ),
                              //       SizedBox(height: 20,),
                              //     ],),
                              // ): Container(),
                            ]
                        ):Container(),
                      );
                    }
                );
              }
          ),
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
      ),
      child: Text("${asi.data.collection[index].display}", style: content1,
        textAlign: TextAlign.center,),
      //width: 100,
      //height: 52,
      //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Container(
      color: Colors.black,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].cash}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].cheque}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].dd}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].rtgs}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].total}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow1(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
      ),
      child: Text("${asc.data.collection[index].display}", style: content1,
        textAlign: TextAlign.center,),
      //width: 100,
      //height: 52,
      //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow1(BuildContext context, int index) {
    return Container(
      color: Colors.black,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].cash}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].cheque}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].dd}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].rtgs}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].total}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initRole() async {
    prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('UserType');
    print("object UserType $userType");
  }


}

class DescriptionView extends StatefulWidget {
  final List<Widget> children;
  DescriptionView({this.children});
  @override
  _DescriptionViewState createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView> {
  // List<String> _detailTypes = ['ICD', 'CFS'];
  List<String> _detailTypes = ['ICD'];
  PageController _pageController;
  List<double> _heights;
  int _currentPage = 0;
  double get _currentHeight  => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController()..addListener(() {
      final _newPage = _pageController.page.round();
      if (_currentPage != _newPage) {
        setState(() => _currentPage = _newPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 60,
              color: footer1,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _detailTypes.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _currentPage == i ?
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width ,
                            height: 30,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle, textAlign: TextAlign.center,),
                            ),
                          ) :
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width ,
                            height: 30,
                            margin: EdgeInsets.only(left: 8),
                            //color: footer1,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle1,  textAlign: TextAlign.center,),
                            ),
                          )
                      ),
                      onTap: () {
                        setState(() {
                          _currentPage = i;
                          _pageController.animateToPage(i, curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 400));
                        });
                      },
                    );
                  }),
            ),
            TweenAnimationBuilder<double>(
              curve: Curves.easeInOutCubic,
              tween: Tween<double>(begin: _heights[0], end: _currentHeight),
              duration: const Duration(milliseconds: 100),
              builder: (c, v, child) {
                return SizedBox(height: v, child: child);
              },
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: _sizeReportingChildren.asMap().map((index, child) =>
                    MapEntry(index, child)).values.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children.asMap().map((index, child) =>
      MapEntry(index, OverflowBox(
        minHeight: 0, maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: SizeReportingWidget(
          onSizeChanged: (size) => setState(() => _heights[index] = size?.height ?? 0),
          child: Align(child: child,),
        ),
      ))).values.toList();

}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChanged;
  SizeReportingWidget({this.child, this.onSizeChanged});
  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.mounted) {
        _notifySize();
      }
    });
    return widget.child;
  }

  _notifySize() {
    final size = context?.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChanged(size);
    }
  }

}
