import 'dart:convert';

import 'package:codforge_assignment/screens/category/model/category.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final baseURL = 'https://02fdf286-2576-494c-b1f5-843e6611ca1b.mock.pstmn.io';

  Future<List<Category>?> loadDataFromApi(int pageIndex) async {
    try {
      final response =
          await http.get(Uri.parse("$baseURL/products?page=$pageIndex"));
//data conversion
      final bodyAsMap = json.decode(response.body) as Map<String, dynamic>;
      final listOfData = bodyAsMap["products"] as List<dynamic>;

      final listOfCategory = listOfData
          .map((e) => Category.fromMap(e as Map<String, dynamic>))
          .toList();

      return listOfCategory;
    } catch (e) {
      return null;
    }
  }
}
