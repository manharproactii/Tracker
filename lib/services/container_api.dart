import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:navkar_tracker/models/mark_location.dart';

class User {
  final String name;

  const User({
     this.name,
  });

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
  );
}

class UserApi {
  static Future<List<MarkLocation>> getUserSuggestions(String query)  async {
    final url = Uri.parse('http://103.236.154.131:97/api/Navkar/GetSearchContainerNoYard?ContainerNo=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var  result = json.decode(response.body);

      MarkLocationModel markLocationModel;
      markLocationModel = (MarkLocationModel.fromJson(result));

    // return  markLocationModel.markLocation.where((markLocation) {
    //     final nameLower = markLocation.containerNo.toLowerCase();
    //     final queryLower = query.toLowerCase();
    //     return nameLower.contains(queryLower);
    //   });

      return markLocationModel.markLocation;

      return result.map((json) => MarkLocation.fromJson(json)).where((user) {
        final nameLower = user.containerNo.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}