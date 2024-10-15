import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:photo_api_text/model/pexcel_search_model.dart';
import 'package:http/http.dart' as http;

import 'Curated_Photos_page.dart';

class SeachDataGet extends StatefulWidget {
  const SeachDataGet({super.key});

  @override
  State<SeachDataGet> createState() => _SeachDataGetState();
}

class _SeachDataGetState extends State<SeachDataGet> {
  var user = PexcelSearchModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:FutureBuilder(future: getData(), builder: (_,snapshot){
          final data = snapshot.data?.photos??List<Photo>.empty();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_,index){
              return Image.network(data[index].src?.original??"");
            }
          );
        }
        ),
        appBar: AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    centerTitle: true,
    title: const Text('Get Data Api', style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.lightBlue,
    actions: [
    PopupMenuButton(
    color: Colors.white,
    itemBuilder: (context) => [
    PopupMenuItem(
    child: const Text('Curated Api'),
    onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CuratedPage()));
    },
    ),
    ],
    ),
    ],
    ),
    );
  }


  Future<PexcelSearchModel> getData() async {
    var header = {
      "Authorization": "ExAjSKlAeYUpTAKZCRROL5QwPiVO3OrkVERsq5Pvrwmqu0T2Q7dEngjp"
    };
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=nature&per_page"),
        headers: header);
      if (response.statusCode==200){
        var res = jsonDecode(response.body);
    return   PexcelSearchModel.fromJson(res);

      }else{
        return PexcelSearchModel();
      }
  }
}
