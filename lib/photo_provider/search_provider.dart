
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import '../model/search_model.dart';

class SearchProviderApi with ChangeNotifier{
  Future<SearchModel> SearchProvider()async{

    var url = "https://api.pexels.com/v1/search?query=nature&per_page";
    var responce = await http.get(Uri.parse(url),
        headers: {"Authorization":"ExAjSKlAeYUpTAKZCRROL5QwPiVO3OrkVERsq5Pvrwmqu0T2Q7dEngjp"}
    );
    if(responce.statusCode == 200){
      return SearchModel.fromJson(jsonDecode(responce.body));
    }else{
      throw Exception("Failed to load search photo: ${responce.statusCode}");
    }
  }
}