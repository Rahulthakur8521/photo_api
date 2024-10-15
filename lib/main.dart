
import 'package:flutter/material.dart';
import 'package:photo_api_text/photo_page/Curated_Photos_page.dart';
import 'package:photo_api_text/photo_page/pexcel_search_get_data.dart';
import 'package:photo_api_text/photo_page/photo_page.dart';
import 'package:photo_api_text/photo_page/search_page.dart';
import 'package:photo_api_text/photo_provider/photo_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (context) => PhotoApiProvider(),),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PhotoPage(),
      ),
    );
  }
}
