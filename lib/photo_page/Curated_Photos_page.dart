
import 'package:flutter/material.dart';
import 'package:photo_api_text/photo_page/search_page.dart';

import '../model/curated_Photos_model.dart';
import '../photo_provider/crueted_provider.dart';

class CuratedPage extends StatefulWidget {
  const CuratedPage({super.key});

  @override
  State<CuratedPage> createState() => _CuratedPageState();
}

class _CuratedPageState extends State<CuratedPage> {
  late Future<CuratedModel> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = CuetedProviderApi().getcurted();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Curated Photo Api'),
        actions: [
          PopupMenuButton(
          color: Colors.white,
              itemBuilder: (context) =>[
            PopupMenuItem(child: const Text('Search Photo Api'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
              },
            ),

              ]
          )
        ]
      ),
      body: Center(
        child: FutureBuilder<CuratedModel>(
            future: futurePhotos,
          builder: (context,snapshot) {
              if(snapshot.hasData){
                return ListView.builder(itemCount: snapshot.data!.photos!.length,
                  itemBuilder: (context,index){
                  Photo photo = snapshot.data!.photos![index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Image.network("${photo.src!.medium}",
                   width: MediaQuery.of(context).size.width,
                   fit: BoxFit.cover,
                 ),
                 Padding(
                     padding: const EdgeInsets.all(8.0),
                   child: Text(
                     '${photo.photographer}',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 Padding(
                     padding: const EdgeInsets.all(8.0),
                 child: Text(
                   '${photo.alt}',
                   style: TextStyle(
                     fontSize: 14),
                 ),
                 ),
               ],
                    ),
                  );
                  }
                );
              }else if(snapshot.hasError){
               return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
          },

        )
      ),

    );
  }
}
