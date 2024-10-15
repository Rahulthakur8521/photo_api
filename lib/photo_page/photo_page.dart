import 'package:flutter/material.dart';
import 'package:photo_api_text/photo_page/pexcel_search_get_data.dart';
import 'package:provider/provider.dart';
import '../photo_provider/photo_provider.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _albumIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PhotoApiProvider>(context, listen: false).fetchPhotos();
  }

  void _showModalBottomSheet({Map<String, dynamic>? photo}) {
    if (photo != null) {
      _titleController.text = photo['title'];
      _albumIdController.text = photo['albumId'].toString();
    } else {
      _titleController.clear();
      _albumIdController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Center(
              child: Text(
                photo != null ? 'Update Photo' : 'Add Photo',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Title',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _albumIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Album ID',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: MaterialButton(
                minWidth: 330,
                color: Colors.lightBlue,
                onPressed: () async {
                  final String title = _titleController.text;
                  final String albumId = _albumIdController.text;

                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter title')),
                    );
                  } else if (albumId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter album ID')),
                    );
                  } else {
                    try {
                      int albumIdInt = int.parse(albumId);
                      Map<String, dynamic> result;
                      if (photo != null) {
                        result = await Provider.of<PhotoApiProvider>(context, listen: false)
                            .updatePhotoApi(photo['id'], title, '', '', albumIdInt);
                      } else {
                        result = await Provider.of<PhotoApiProvider>(context, listen: false)
                            .createPhotoApi(title, '', '', albumIdInt);
                      }
                      bool success = result["success"];
                      int? statusCode = result["statusCode"];
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Success: $statusCode')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed: $statusCode')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  photo != null ? 'Update' : 'Post',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int photoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                Map<String, dynamic> result = await Provider.of<PhotoApiProvider>(context, listen: false).deletePhotoApi(photoId);
                bool success = result["success"];
                int? statusCode = result["statusCode"];
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted: $statusCode')),
                  );
                  Provider.of<PhotoApiProvider>(context, listen: false).fetchPhotos();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed: $statusCode')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPhotoDetails(Map<String, dynamic> photo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${photo['title']}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Album ID: ${photo['albumId']}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Image.network(photo['url']),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _albumIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var photoData = Provider.of<PhotoApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text('Photo API', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('GetData A Photo'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeachDataGet()));
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        onPressed: () => _showModalBottomSheet(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: photoData.photos.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: photoData.photos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network('https://picsum.photos/250?image=${index + 1}'),
              // leading: Image.network(photoData.photos[index]['url']),
              title: Text('Title: ${photoData.photos[index]['title']}'),
              subtitle: Text('Album ID: ${photoData.photos[index]['albumId']}'),
              trailing: PopupMenuButton<int>(
                onSelected: (int result) {
                  if (result == 0) {
                    _showPhotoDetails(photoData.photos[index]);
                  } else if (result == 1) {
                    _showModalBottomSheet(photo: photoData.photos[index]);
                  } else if (result == 2) {
                    _showDeleteConfirmationDialog(photoData.photos[index]['id']);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Update'),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
