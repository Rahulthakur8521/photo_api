import 'package:flutter/material.dart';
import '../model/search_model.dart';
import '../photo_provider/search_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<SearchModel> searchPhotos;

  @override
  void initState() {
    super.initState();
    searchPhotos = SearchProviderApi().SearchProvider();
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Pexels Search Photos Api'),
        ),
        body: Center(
            child: FutureBuilder<SearchModel>(
              future: searchPhotos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.photos!.length,
                    itemBuilder: (context, index) {
                      Photo photo = snapshot.data!.photos![index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              "${photo.src!.medium}",
                              width: screenWidth, // Set image width to screen width
                              fit: BoxFit.cover, // Ensure the image covers the entire space
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
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              },
            ),
            ),
        );
    }
}