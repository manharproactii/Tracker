import 'package:flutter/material.dart';
import '../../bloc/dmr_bloc.dart';
import '../../bloc/mark_location_bloc.dart';
import '../../models/dmr_model.dart';
import '../../models/mark_location.dart';
import '../../utils/alerts.dart';
import '../../utils/app_properties.dart';

class ViewSummaryPage extends StatefulWidget {
  @override
  _ViewSummaryPageState createState() => _ViewSummaryPageState();
}

class _ViewSummaryPageState extends State<ViewSummaryPage> {

  final markLocationBloc = MarkLocationBloc();

  AsyncSnapshot<MarkLocationModel> as;


  @override
  initState(){
    markLocationBloc.getYardDataSummaryData();
    super.initState();
  }

  @override
  void dispose() {
    markLocationBloc.dispose();
    super.dispose();
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
      title: Text("Summary",
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
      child:   StreamBuilder(
        stream: markLocationBloc.markLocationStream,
        builder: (c,s){
          as = s;
          if (
              as.connectionState != ConnectionState.active) {
            print("all connection");

            return Container(height : 300, alignment: Alignment.center, child: Center(heightFactor: 50, child: CircularProgressIndicator(),));
          }
          if (s.hasError) {
            print("as3 error");

            return Container();
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");

            return Container();
          }

         // print("response message from the api ${as1.data.responseMessege.messege} ${asc.data.portPendency.isEmpty}");

          //print("object values of s : ${s.data.message} sc: ${sc.data.message} s1: ${s1.data.message} s2: ${s2.data.message} s3: ${s3.data.message}");
          return Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            child:

            // Container(
            //   margin: EdgeInsets.only(left: 10, right: 10),
            //   child: as.data.responseMessege.messege == null ? Column(
            //     children: [
            //       as.data.arrivalTues.isEmpty ? Container() : arrival(as),
            //       as.data.loadedDelivery.isEmpty ? Container() : loadedDelivery(as),
            //       as.data.deStuffDelivery.isEmpty ? Container() : deStuffDelivery(as),
            //       as.data.inventory.isEmpty ? Container() : inventory(as),
            //       as.data.jobOrderReceived.isEmpty ? Container() : jobOrderReceived(as),
            //       as.data.portPendency.isEmpty ? Container() : portPendency(as),
            //       as.data.importJoInHand.isEmpty ? Container() : importJoInHand(as),
            //       as.data.inTransit.isEmpty ? Container() : inTransit(as),
            //       as.data.joInHand.isEmpty ? Container() : joInHand(as),
            //     ],
            //   ) : Container(),
            // ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: as.data.markLocation.isNotEmpty ? Column(
                children: [
                  as.data.markLocation.isEmpty ? Container() : markLocationWidget(as),


                ],
              ) : Container(),
            ),
          );
        })
    );
  }

  Widget markLocationWidget(AsyncSnapshot s) {
    //print("print arrival ${s.error}");
  return Column(
    children: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.transparent,
        height: 30,
        // child: Text("Arrival TEUS",
        //     textAlign: TextAlign.center,
        //     style: headingBar),
      ),
      SizedBox(height: 5,),
      Container(
        height: 50,
        //padding: EdgeInsets.only(left: 2, right: 2),
        //margin: EdgeInsets.only(left: 2, right: 2),
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                  child: Text('Container No',
                    style: content1,
                    textAlign: TextAlign.center,),
                  alignment: Alignment.center,
                )
            ),
            Expanded(
                child: Container(
                  child: Text('Location', style: content1,
                    textAlign: TextAlign.center,),
                  alignment: Alignment.center,
                )
            ),
            // Expanded(
            //     child: Container(
            //       child: Text('ContainerNo',
            //         style: content1,
            //         textAlign: TextAlign.center,),
            //       alignment: Alignment.center,
            //     )
            // ),
          ],
        ),
      ),
      for(int i = 0; i<s.data.markLocation.length;i++)
        Container(
          height: 50,
          //padding: EdgeInsets.only(left: 2, right: 2),
          //margin: EdgeInsets.only(left: 2, right: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    ),
                    child: Text(s.data.markLocation[i].containerNo, style: content1,
                      textAlign: TextAlign.center,),
                    //width: 100,
                    //height: 52,
                    //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.center,
                  )
              ),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                    ),
                    child: Text("${s.data.markLocation[i].locationName}", style: content1,
                      textAlign: TextAlign.center,),
                    //width: 100,
                    //height: 52,
                    //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.center,
                  )
              ),
              // Expanded(
              //     child: Container(
              //       decoration: BoxDecoration(
              //         border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              //       ),
              //       child: Text("${s.data.markLocation[i].containerNo}", style: content1,
              //         textAlign: TextAlign.center,),
              //       //width: 150,
              //       //height: 52,
              //       //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //       alignment: Alignment.center,
              //     )
              // ),
            ],
          ),
        ),
      SizedBox(height: 20,)
    ],);
  }

}

class DescriptionView extends StatefulWidget {
  final List<Widget> children;
  DescriptionView({this.children});
  @override
  _DescriptionViewState createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView> {
  // List<String> _detailTypes = ['ICD', 'CFS', 'NCL-1', 'NCL-2', 'NCL-3'];
  List<String> _detailTypes = ['ICD'];
  PageController _pageController;
  List<double> _heights;
  int _currentPage = 0;
  double get _currentHeight  => _heights[_currentPage];

  @override
  void initState() {
    super.initState();
    _heights = widget.children.map((e) => 0.0).toList();
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
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _currentPage == i ?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Center(
                            child: Text('${_detailTypes[i]}', style: optionStyle),
                          ),
                        ) :
                        Container(
                          width: 48,
                          height: 30,
                          margin: EdgeInsets.only(left: 8),
                          //color: footer1,
                          child: Center(
                            child: Text('${_detailTypes[i]}', style: optionStyle1),
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

  _notifySize() {
    final size = context?.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChanged(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.mounted) {
        _notifySize();
      }
    });
    return widget.child;
  }
  
}
