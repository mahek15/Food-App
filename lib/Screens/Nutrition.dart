import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'BarChart.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  File? image;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(20),
              child: image == null
                  ? Image(
                      image: AssetImage(
                        "assets/download.jpg",
                      ),
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      image!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )),
          Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                pickImage(ImageSource.gallery);
              },
              leading: Icon(
                Icons.photo_size_select_actual_outlined,
                size: 25,
              ),
              title: Text(
                "Choose from Gallery",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                    letterSpacing: 2),
              ),
              tileColor: Colors.brown[100],
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                },
                leading: Icon(
                  Icons.camera_alt_outlined,
                  size: 25,
                ),
                title: Text(
                  "Use Camera",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                      letterSpacing: 2),
                ),
                tileColor: Colors.brown[100],
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10)),
              )),
          ElevatedButton(
              onPressed:() {
                Navigator.pushReplacement(context, PageTransition(
                    type: PageTransitionType.rotate,
                    alignment: Alignment.bottomCenter,
                    child: BarCard()),);
              },
              child: Text("BarChart"))
        ],
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File imagePath = await saveImagePermanently(image.path);
      name = image.name;
      setState(() {
        this.image = imagePath;
      });
      uploadFile();
    } on PlatformException catch (e) {
      print('Failed to pick image:$e');
    }
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }

  Future uploadFile() async {
    final path = 'images/$name';
    final ref = FirebaseStorage.instance.ref().child(path);
    var uploadTask = ref.putFile(image!);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Dowload link:$urlDownload');
  }
}
