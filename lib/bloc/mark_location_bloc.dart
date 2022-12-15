import 'dart:async';

import 'package:navkar_tracker/models/mark_location.dart';

import '../models/dmr_model.dart';
import '../services/api_clients.dart';

class MarkLocationBloc{
  final _apiclient = ApiClient();

  final _markLocationController = StreamController<MarkLocationModel>.broadcast();

  Stream<MarkLocationModel> get markLocationStream => _markLocationController.stream;

  getYardDataSummaryData() async{

    try{
      final results = await _apiclient.getYardDataSummary();
      _markLocationController.sink.add(results);
      print("_markLocationController $results");
    } on Exception catch(e){
      print(e.toString());
      _markLocationController.sink.addError("something went wrong ${e.toString()}");
    }

  }



  dispose(){
    _markLocationController.close();
  }

}