import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../models/billing_model.dart';
import '../../bloc/billing_bloc.dart';
import '../../utils/alerts.dart';
import '../../utils/app_properties.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {


  final icdBloc = BillingBloc();
  final cfsBloc = BillingBloc();

  AsyncSnapshot<BillingModel> asi, asc;

  @override
  initState(){
    super.initState();
    icdBloc.fetchICDBill();
    cfsBloc.fetchCFSBill();
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
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Last 12 Months\' Billing",
        style: subheading1,),
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
      child: StreamBuilder<BillingModel>(
          stream: icdBloc.icdBillStream,
          builder: (c, si) {
            asi = si;
            if (asi.hasError) {
              print("as error");
              return Container();
            }
            if (asi.data.toString().isEmpty) {
              print("as empty");
              return Container();
            }
            return StreamBuilder<BillingModel>(
                stream: cfsBloc.cfsBillStream,
                builder: (c, sc) {
                  asc = sc;
                  if (asc.connectionState != ConnectionState.active || asi.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(height : 300, alignment: Alignment.center, child: Center(heightFactor: 50, child: CircularProgressIndicator(),));
                  }
                  if (asc.hasError) {
                    print("as3 error");
                    return Container();
                  }
                  if (asc.data.toString().isEmpty) {
                    print("as3 empty");
                    return Container();
                  }

                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.topCenter,
                    child:
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       SizedBox(height: 20),
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
                    //                   child: Text('Month',
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
                    //             //             child: Text('Import', style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('Export',
                    //             //               style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('Bond',
                    //             //               style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('Domestic',
                    //             //               style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('MNR',
                    //             //               style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('MISC',
                    //             //               style: content1,
                    //             //               textAlign: TextAlign.center,),
                    //             //             alignment: Alignment.center,
                    //             //           ),
                    //             //         ),
                    //             //         Expanded(
                    //             //           child: Container(
                    //             //             child: Text('Credit',
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
                    //                 // mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   Container(
                    //                     child: Text('Import', style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('Export',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('Bond',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('Domestic',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('MNR',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('MISC',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     child: Text('Credit',
                    //                       style: content1,
                    //                       textAlign: TextAlign.center,),
                    //                     alignment: Alignment.center,
                    //                     width: 100,
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
                    //                     width: 100,
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
                    //
                    //
                    //           ],
                    //           leftSideItemBuilder: _generateFirstColumnRow1,
                    //           rightSideItemBuilder: _generateRightHandSideColumnRow1,
                    //           itemCount: asc.data.billingDmrActivityWise.length,
                    //           rightHandSideColBackgroundColor: Colors.black,
                    //           leftHandSideColBackgroundColor: Colors.black,
                    //         ),
                    //       ),
                    //       // Container(
                    //       //   alignment: Alignment.center,
                    //       //   padding: EdgeInsets.only(left: 20, right: 20),
                    //       //   color: Colors.transparent,
                    //       //   height: 50,
                    //       //   child: Text(
                    //       //     'Billing DMR Month Wise',
                    //       //     textAlign: TextAlign.center,
                    //       //     style: headingBar,
                    //       //   ),
                    //       // ),
                    //       // Container(
                    //       //   height: 50,
                    //       //   //padding: EdgeInsets.only(left: 2, right: 2),
                    //       //   //margin: EdgeInsets.only(left: 2, right: 2),
                    //       //   decoration: BoxDecoration(
                    //       //     color: Colors.green,
                    //       //     border: Border.all(color: Colors.white),
                    //       //   ),
                    //       //   child: Row(
                    //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       //     children: [
                    //       //       Expanded(
                    //       //           flex: 2,
                    //       //           child: Container(
                    //       //             child: Text('Month',
                    //       //               style: content1,
                    //       //               textAlign: TextAlign.center,),
                    //       //             alignment: Alignment.center,
                    //       //           )
                    //       //       ),
                    //       //       Expanded(
                    //       //           child: Container(
                    //       //             child: Text('Total', style: content1,
                    //       //               textAlign: TextAlign.center,),
                    //       //             alignment: Alignment.center,
                    //       //           )
                    //       //       ),
                    //       //       Expanded(
                    //       //           flex: 2,
                    //       //           child: Container(
                    //       //             child: Text('AsonDate',
                    //       //               style: content1,
                    //       //               textAlign: TextAlign.center,),
                    //       //             alignment: Alignment.center,
                    //       //           )
                    //       //       ),
                    //       //       Expanded(
                    //       //           flex: 2,
                    //       //           child: Container(
                    //       //             child: Text('AsonMonth',
                    //       //               style: content1,
                    //       //               textAlign: TextAlign.center,),
                    //       //             alignment: Alignment.center,
                    //       //           )
                    //       //       ),
                    //       //     ],
                    //       //   ),
                    //       // ),
                    //       // for(int i = 0; i<asc.data.billingDmrMonthWise.length;i++)
                    //       //   Container(
                    //       //     height: 50,
                    //       //     //padding: EdgeInsets.only(left: 2, right: 2),
                    //       //     //margin: EdgeInsets.only(left: 2, right: 2),
                    //       //     child: Row(
                    //       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       //       children: [
                    //       //         Expanded(
                    //       //             flex: 2,
                    //       //             child: Container(
                    //       //               decoration: BoxDecoration(
                    //       //                 color: bg,
                    //       //                 border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    //       //               ),
                    //       //               child: Text("${asc.data.billingDmrMonthWise[i].displayMonth}", style: content1,
                    //       //                 textAlign: TextAlign.center,),
                    //       //               //width: 100,
                    //       //               //height: 52,
                    //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //       //               alignment: Alignment.center,
                    //       //             )
                    //       //         ),
                    //       //         Expanded(
                    //       //             child: Container(
                    //       //               decoration: BoxDecoration(
                    //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    //       //               ),
                    //       //               child: Text("${asc.data.billingDmrMonthWise[i].total}", style: content1,
                    //       //                 textAlign: TextAlign.center,),
                    //       //               //width: 100,
                    //       //               //height: 52,
                    //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //       //               alignment: Alignment.center,
                    //       //             )
                    //       //         ),
                    //       //         Expanded(
                    //       //             flex: 2,
                    //       //             child: Container(
                    //       //               decoration: BoxDecoration(
                    //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    //       //               ),
                    //       //               child: Text("${asc.data.billingDmrMonthWise[i].asOnDate}", style: content1,
                    //       //                 textAlign: TextAlign.center,),
                    //       //               //width: 150,
                    //       //               //height: 52,
                    //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //       //               alignment: Alignment.center,
                    //       //             )
                    //       //         ),
                    //       //         Expanded(
                    //       //             flex: 2,
                    //       //             child: Container(
                    //       //               decoration: BoxDecoration(
                    //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    //       //               ),
                    //       //               child: Text("${asc.data.billingDmrMonthWise[i].asOnMonth}", style: content1,
                    //       //                 textAlign: TextAlign.center,),
                    //       //               //width: 150,
                    //       //               //height: 52,
                    //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //       //               alignment: Alignment.center,
                    //       //             )
                    //       //         ),
                    //       //       ],
                    //       //     ),
                    //       //   ),
                    //       SizedBox(height: 20,),
                    //     ],
                    //   ),
                    // ),

                    DescriptionView(
                        children : [
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
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
                                            child: Text('Month',
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
                                      //             child: Text('Import', style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('Export',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('Bond',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('Domestic',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('MNR',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('MISC',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('Credit',
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
                                      // )

                                  Container(
                                    height: 50,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.green,
                                    //   border: Border.all(color: Colors.white),
                                    // ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Text('Import', style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('Export',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('Bond',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('Domestic',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('MNR',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('MISC',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          child: Text('Credit',
                                            style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                          width: 100,
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
                                          width: 100,
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
                                  ),],
                                    leftSideItemBuilder: _generateFirstColumnRow,
                                    rightSideItemBuilder: _generateRightHandSideColumnRow,
                                    itemCount: asi.data.billingDmrActivityWise.length,
                                    rightHandSideColBackgroundColor: Colors.black,
                                    leftHandSideColBackgroundColor: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Column(
                          //     children: [
                          //       SizedBox(height: 20),
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
                          //                   child: Text('Month',
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
                          //             //             child: Text('Import', style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('Export',
                          //             //               style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('Bond',
                          //             //               style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('Domestic',
                          //             //               style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('MNR',
                          //             //               style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('MISC',
                          //             //               style: content1,
                          //             //               textAlign: TextAlign.center,),
                          //             //             alignment: Alignment.center,
                          //             //           ),
                          //             //         ),
                          //             //         Expanded(
                          //             //           child: Container(
                          //             //             child: Text('Credit',
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
                          //                 // mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   Container(
                          //                     child: Text('Import', style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
                          //                     decoration: const BoxDecoration(
                          //                       color: Colors.green,
                          //                         border: Border(
                          //                           right: BorderSide( //                   <--- right side
                          //                             color: Colors.white,
                          //                           ),
                          //                           top:  BorderSide( //                   <--- right side
                          //                           color: Colors.white,
                          //                         ),
                          //                           bottom: BorderSide( //                   <--- right side
                          //                           color: Colors.white,
                          //                         ),
                          //                         )
                          //                       // border: Border.all(color: Colors.white),
                          //                     ),
                          //                   ),
                          //                   Container(
                          //                     child: Text('Export',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     child: Text('Bond',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     child: Text('Domestic',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     child: Text('MNR',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     child: Text('MISC',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     child: Text('Credit',
                          //                       style: content1,
                          //                       textAlign: TextAlign.center,),
                          //                     alignment: Alignment.center,
                          //                     width: 100,
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
                          //                     width: 100,
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
                          //
                          //
                          //           ],
                          //           leftSideItemBuilder: _generateFirstColumnRow1,
                          //           rightSideItemBuilder: _generateRightHandSideColumnRow1,
                          //           itemCount: asc.data.billingDmrActivityWise.length,
                          //           rightHandSideColBackgroundColor: Colors.black,
                          //           leftHandSideColBackgroundColor: Colors.black,
                          //         ),
                          //       ),
                          //       // Container(
                          //       //   alignment: Alignment.center,
                          //       //   padding: EdgeInsets.only(left: 20, right: 20),
                          //       //   color: Colors.transparent,
                          //       //   height: 50,
                          //       //   child: Text(
                          //       //     'Billing DMR Month Wise',
                          //       //     textAlign: TextAlign.center,
                          //       //     style: headingBar,
                          //       //   ),
                          //       // ),
                          //       // Container(
                          //       //   height: 50,
                          //       //   //padding: EdgeInsets.only(left: 2, right: 2),
                          //       //   //margin: EdgeInsets.only(left: 2, right: 2),
                          //       //   decoration: BoxDecoration(
                          //       //     color: Colors.green,
                          //       //     border: Border.all(color: Colors.white),
                          //       //   ),
                          //       //   child: Row(
                          //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       //     children: [
                          //       //       Expanded(
                          //       //           flex: 2,
                          //       //           child: Container(
                          //       //             child: Text('Month',
                          //       //               style: content1,
                          //       //               textAlign: TextAlign.center,),
                          //       //             alignment: Alignment.center,
                          //       //           )
                          //       //       ),
                          //       //       Expanded(
                          //       //           child: Container(
                          //       //             child: Text('Total', style: content1,
                          //       //               textAlign: TextAlign.center,),
                          //       //             alignment: Alignment.center,
                          //       //           )
                          //       //       ),
                          //       //       Expanded(
                          //       //           flex: 2,
                          //       //           child: Container(
                          //       //             child: Text('AsonDate',
                          //       //               style: content1,
                          //       //               textAlign: TextAlign.center,),
                          //       //             alignment: Alignment.center,
                          //       //           )
                          //       //       ),
                          //       //       Expanded(
                          //       //           flex: 2,
                          //       //           child: Container(
                          //       //             child: Text('AsonMonth',
                          //       //               style: content1,
                          //       //               textAlign: TextAlign.center,),
                          //       //             alignment: Alignment.center,
                          //       //           )
                          //       //       ),
                          //       //     ],
                          //       //   ),
                          //       // ),
                          //       // for(int i = 0; i<asc.data.billingDmrMonthWise.length;i++)
                          //       //   Container(
                          //       //     height: 50,
                          //       //     //padding: EdgeInsets.only(left: 2, right: 2),
                          //       //     //margin: EdgeInsets.only(left: 2, right: 2),
                          //       //     child: Row(
                          //       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       //       children: [
                          //       //         Expanded(
                          //       //             flex: 2,
                          //       //             child: Container(
                          //       //               decoration: BoxDecoration(
                          //       //                 color: bg,
                          //       //                 border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                          //       //               ),
                          //       //               child: Text("${asc.data.billingDmrMonthWise[i].displayMonth}", style: content1,
                          //       //                 textAlign: TextAlign.center,),
                          //       //               //width: 100,
                          //       //               //height: 52,
                          //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          //       //               alignment: Alignment.center,
                          //       //             )
                          //       //         ),
                          //       //         Expanded(
                          //       //             child: Container(
                          //       //               decoration: BoxDecoration(
                          //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                          //       //               ),
                          //       //               child: Text("${asc.data.billingDmrMonthWise[i].total}", style: content1,
                          //       //                 textAlign: TextAlign.center,),
                          //       //               //width: 100,
                          //       //               //height: 52,
                          //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          //       //               alignment: Alignment.center,
                          //       //             )
                          //       //         ),
                          //       //         Expanded(
                          //       //             flex: 2,
                          //       //             child: Container(
                          //       //               decoration: BoxDecoration(
                          //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                          //       //               ),
                          //       //               child: Text("${asc.data.billingDmrMonthWise[i].asOnDate}", style: content1,
                          //       //                 textAlign: TextAlign.center,),
                          //       //               //width: 150,
                          //       //               //height: 52,
                          //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          //       //               alignment: Alignment.center,
                          //       //             )
                          //       //         ),
                          //       //         Expanded(
                          //       //             flex: 2,
                          //       //             child: Container(
                          //       //               decoration: BoxDecoration(
                          //       //                 border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                          //       //               ),
                          //       //               child: Text("${asc.data.billingDmrMonthWise[i].asOnMonth}", style: content1,
                          //       //                 textAlign: TextAlign.center,),
                          //       //               //width: 150,
                          //       //               //height: 52,
                          //       //               //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          //       //               alignment: Alignment.center,
                          //       //             )
                          //       //         ),
                          //       //       ],
                          //       //     ),
                          //       //   ),
                          //       SizedBox(height: 20,),
                          //     ],
                          //   ),
                          // ),
                        ]
                    ),
                  );
                }
            );
          }
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
      child: Text("${asi.data.billingDmrActivityWise[index].displayMonth}", style: content1,
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
              child: Text("${asi.data.billingDmrActivityWise[index].import}", style: content1,
                textAlign: TextAlign.center,),
              //width: 100,
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
              child: Text("${asi.data.billingDmrActivityWise[index].export}", style: content1,
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
              child: Text("${asi.data.billingDmrActivityWise[index].bond}", style: content1,
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
              child: Text("${asi.data.billingDmrActivityWise[index].domestic}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.billingDmrActivityWise[index].mnr}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.billingDmrActivityWise[index].misc}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.billingDmrActivityWise[index].credit}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.billingDmrActivityWise[index].total}", style: content1,
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
      child: Text("${asc.data.billingDmrActivityWise[index].displayMonth}", style: content1,
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
              child: Text("${asc.data.billingDmrActivityWise[index].import}", style: content1,
                textAlign: TextAlign.center,),
              //width: 100,
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
              child: Text("${asc.data.billingDmrActivityWise[index].export}", style: content1,
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
              child: Text("${asc.data.billingDmrActivityWise[index].bond}", style: content1,
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
              child: Text("${asc.data.billingDmrActivityWise[index].domestic}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.billingDmrActivityWise[index].mnr}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.billingDmrActivityWise[index].misc}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.billingDmrActivityWise[index].credit}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.billingDmrActivityWise[index].total}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
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
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle, textAlign: TextAlign.center,),
                            ),
                          ) :
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
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