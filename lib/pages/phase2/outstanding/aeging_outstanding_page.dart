import 'package:flutter/material.dart';
import '../../../bloc/outstanding_bloc.dart';
import '../../../models/outstanding_model.dart';
import '../../../utils/alerts.dart';
import '../../../utils/app_properties.dart';
import 'cfs_customer_wise_aeging.dart';
import 'icd_customer_wise_aeging.dart';
import 'outstanding_page.dart';

class AegingOutStandingPage extends StatefulWidget {
  @override
  _AegingOutStandingPageState createState() => _AegingOutStandingPageState();
}

class _AegingOutStandingPageState extends State<AegingOutStandingPage> {


  final icdBloc = OutstandingBloc();
  final cfsBloc = OutstandingBloc();

  AsyncSnapshot<OutstandingModel> asi, asc;

  @override
  initState(){
    super.initState();
    icdBloc.fetchICDOut();
    cfsBloc.fetchCFSOut();
  }

  @override
  void dispose() {
    super.dispose();
    icdBloc.dispose();
    cfsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => OutStandingPage()));
        return;
        },
      child: Scaffold(
        backgroundColor: background,
        appBar:_appBar(),
        body: _body(),
      ),
    );
  }

  Widget _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (c) => OutStandingPage()));
      },),
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Ageing Outstanding",
        style: optionStyle,),
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
      child: StreamBuilder<OutstandingModel>(
        stream: icdBloc.icdOutStream,
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
          return StreamBuilder<OutstandingModel>(
            stream: cfsBloc.cfsOutStream,
            builder: (c, sc) {
              asc = sc;
              if (asi.connectionState != ConnectionState.active) {
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
              print("all sets");
              return Container(
                alignment: Alignment.topCenter,
                child: DescriptionView(
                    children : [
                      asi.data.responseMessege.messege == null ? Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                border: Border.all(color: Colors.white),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Range',
                                          style: content1,
                                          textAlign: TextAlign.center,),
                                        alignment: Alignment.center,
                                      )
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Debit',
                                          style: content1,
                                          textAlign: TextAlign.center,),
                                        alignment: Alignment.center,
                                      )
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text('Credit',
                                          style: content1,
                                          textAlign: TextAlign.center,),
                                        alignment: Alignment.center,
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                      child: Container(
                                        child: Text('Outstanding',
                                          style: content1,
                                          textAlign: TextAlign.center,),
                                        alignment: Alignment.center,
                                      )
                                  ),
                                  Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                      )
                                  ),
                                ],
                              ),
                            ),
                            for(int i = 0; i<asi.data.outstandings.length;i++)
                              Container(
                                height: 50,
                                //padding: EdgeInsets.only(left: 2, right: 2),
                                //margin: EdgeInsets.only(left: 2, right: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: bg,
                                            border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                                          ),
                                          child: asi.data.outstandings[i].to.isEmpty ? Text("${asi.data.outstandings[i].from}", style: content1,
                                            textAlign: TextAlign.center,) : Text("${asi.data.outstandings[i].from} - ${asi.data.outstandings[i].to}", style: content1,
                                            textAlign: TextAlign.center,),
                                          //width: 100,
                                          //height: 52,
                                          //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          alignment: Alignment.center,
                                        )
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                                          ),
                                          child: Text("${asi.data.outstandings[i].debit}", style: content1,
                                            textAlign: TextAlign.center,),
                                          //width: 150,
                                          //height: 52,
                                          //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          alignment: Alignment.center,
                                        )
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                                          ),
                                          child: Text("${asi.data.outstandings[i].credit}", style: content1,
                                            textAlign: TextAlign.center,),
                                          //width: 150,
                                          //height: 52,
                                          //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          alignment: Alignment.center,
                                        )
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                                          ),
                                          child: Text("${asi.data.outstandings[i].outstanding}", style: content1,
                                            textAlign: TextAlign.center,),
                                          alignment: Alignment.center,
                                        )
                                    ),
                                    Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                                          ),
                                          child: asi.data.outstandings[i].from == "Total" ? Container() : IconButton(
                                            icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 18,),
                                            onPressed: (){
                                              print("values of from and to ${asi.data.outstandings[i].from} ${asi.data.outstandings[i].to}");
                                              asi.data.outstandings[i].from == "1 Year Above" ? Navigator.push(context, MaterialPageRoute(builder: (c) => ICDCustomerWiseAgeing(from: asi.data.outstandings[i].from, to: "0"))) : Navigator.push(context, MaterialPageRoute(builder: (c) => ICDCustomerWiseAgeing(from: asi.data.outstandings[i].from, to: asi.data.outstandings[i].to,)));
                                            },),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 20,)
                          ],),
                      ) : Container(),
                      // asc.data.responseMessege.messege == null ? Container(
                      //   padding: EdgeInsets.all(5),
                      //   margin: EdgeInsets.only(left: 5, right: 5),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         height: 50,
                      //         decoration: BoxDecoration(
                      //           color: Colors.green,
                      //           border: Border.all(color: Colors.white),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Expanded(
                      //                 flex: 2,
                      //                 child: Container(
                      //                   child: Text('Range',
                      //                     style: content1,
                      //                     textAlign: TextAlign.center,),
                      //                   alignment: Alignment.center,
                      //                 )
                      //             ),
                      //             Expanded(
                      //                 flex: 2,
                      //                 child: Container(
                      //                   child: Text('Debit',
                      //                     style: content1,
                      //                     textAlign: TextAlign.center,),
                      //                   alignment: Alignment.center,
                      //                 )
                      //             ),
                      //             Expanded(
                      //                 flex: 2,
                      //                 child: Container(
                      //                   child: Text('Credit',
                      //                     style: content1,
                      //                     textAlign: TextAlign.center,),
                      //                   alignment: Alignment.center,
                      //                 )
                      //             ),
                      //             Expanded(
                      //                 flex: 2,
                      //                 child: Container(
                      //                   child: Text('Outstanding',
                      //                     style: content1,
                      //                     textAlign: TextAlign.center,),
                      //                   alignment: Alignment.center,
                      //                 )
                      //             ),
                      //             Expanded(
                      //                 child: Container(
                      //                   alignment: Alignment.center,
                      //                 )
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       for(int i = 0; i<asc.data.outstandings.length;i++)
                      //         Container(
                      //           height: 50,
                      //           //padding: EdgeInsets.only(left: 2, right: 2),
                      //           //margin: EdgeInsets.only(left: 2, right: 2),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Expanded(
                      //                   flex: 2,
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       color: bg,
                      //                       border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                      //                     ),
                      //                     child:asc.data.outstandings[i].to.isEmpty ? Text("${asc.data.outstandings[i].from}", style: content1,
                      //                       textAlign: TextAlign.center,) : Text("${asc.data.outstandings[i].from} - ${asc.data.outstandings[i].to}", style: content1,
                      //                       textAlign: TextAlign.center,),
                      //                     alignment: Alignment.center,
                      //                   )
                      //               ),
                      //               Expanded(
                      //                   flex: 2,
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                      //                     ),
                      //                     child: Text("${asc.data.outstandings[i].debit}", style: content1,
                      //                       textAlign: TextAlign.center,),
                      //                     //width: 150,
                      //                     //height: 52,
                      //                     //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      //                     alignment: Alignment.center,
                      //                   )
                      //               ),
                      //               Expanded(
                      //                   flex: 2,
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                      //                     ),
                      //                     child: Text("${asc.data.outstandings[i].credit}", style: content1,
                      //                       textAlign: TextAlign.center,),
                      //                     alignment: Alignment.center,
                      //                   )
                      //               ),
                      //               Expanded(
                      //                 flex: 2,
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                      //                     ),
                      //                     child: Text("${asc.data.outstandings[i].outstanding}", style: content1,
                      //                       textAlign: TextAlign.center,),
                      //                     alignment: Alignment.center,
                      //                   )
                      //               ),
                      //               Expanded(
                      //                   child: Container(
                      //                     alignment: Alignment.center,
                      //                     decoration: BoxDecoration(
                      //                       border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                      //                     ),
                      //                     child: asc.data.outstandings[i].from == "Total" ? Container() : IconButton(
                      //                       icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 18,),
                      //                       onPressed: (){
                      //                         print("values of from and to ${asc.data.outstandings[i].from} ${asc.data.outstandings[i].to}");
                      //                         asc.data.outstandings[i].from == "1 Year Above" ? Navigator.push(context, MaterialPageRoute(builder: (c) => CFSCustomerWiseAgeing(from: asc.data.outstandings[i].from, to: "0"))) : Navigator.push(context, MaterialPageRoute(builder: (c) => CFSCustomerWiseAgeing(from: asc.data.outstandings[i].from, to: asc.data.outstandings[i].to,)));
                      //                       },),
                      //                   )
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       SizedBox(height: 20,)
                      //     ],),
                      // ) : Container(),
                    ]
                ),
              );
            }
          );
        }
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
  List<String> _detailTypes = ['ICD',];
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