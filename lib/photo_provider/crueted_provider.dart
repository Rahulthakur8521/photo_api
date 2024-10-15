
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/curated_Photos_model.dart';

class CuetedProviderApi with ChangeNotifier{
  Future<CuratedModel> getcurted()async{

    var url = "https://api.pexels.com/v1/curated?per_page";
    var responce = await http.get(Uri.parse(url)
        , headers: {"Authorization":"ExAjSKlAeYUpTAKZCRROL5QwPiVO3OrkVERsq5Pvrwmqu0T2Q7dEngjp"
    });
    if(responce.statusCode==200){
       return CuratedModel.fromJson(jsonDecode(responce.body));
     }else{
       throw Exception("Failed to load cureted photo: ${responce.statusCode}");
     }
  }
}

