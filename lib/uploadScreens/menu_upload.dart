import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/constants/constants.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import '../widgets/error_dialog.dart';

class MenuUploadScreen extends StatefulWidget {
  const MenuUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearProductUploadForm();
          },
        ),
        title: Text(
          "Add new product",
          style: TextStyle(
            fontFamily: "Lobster",
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.grey,
                size: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                elevation: 1,
                color: Colors.amber,
                onPressed: () {
                  takeImage(context);
                },
                child: const Text(
                  "Add new product",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Product Image",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Camera"),
                ],
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(
                    Icons.image_sharp,
                    color: Colors.grey,
                    size: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Text("Select from gallery"),
                ],
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  productUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text(
          "Uploading new product",
          style: TextStyle(
            fontFamily: "Lobster",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: uploading ? null : () => validateUploadForm(),
              child: Row(
                children: const [
                  Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  )
                ],
              ))
        ],
      ),
      body: ListView(
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(
                            File(imageXFile!.path),
                          ),
                          fit: BoxFit.fitHeight)),
                ),
              ),
            ),
          ),
          uploading == true ? linearProgress() : const SizedBox.shrink(),
          ListTile(
            leading: Icon(Icons.title),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                controller: titleController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Product name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250,
              height: MediaQuery.of(context).size.height * 0.2,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: null,
                minLines: null,
                expands: true,
                textCapitalization: TextCapitalization.sentences,
                controller: descriptionController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Product description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            height: 50,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber)
                ),
                onPressed: (){
                  uploading ? null : () => validateUploadForm();
                }, child: const Text("Create Product Category")),
          )
        ],
      ),
    );
  }

  clearProductUploadForm() {
    setState(() {
      descriptionController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (descriptionController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //Upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //Save to firebase
        saveProductInfo(
            downloadUrl);
      } else {
        //Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                  message: "Product name and description cannot be empty!");
            });
      }
    } else {
      //Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Product image not selected!");
          });
    }
  }

  saveProductInfo(String downloadUrl) async{
    final ref = FirebaseFirestore.instance
        .collection("merchants").doc(firebaseAuth.currentUser!.uid)
        .collection("products");

    ref.doc(uniqueIdName).set({
      "productID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "productDescription": descriptionController.text.toString(),
      "productTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearProductUploadForm();
    uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      uploading =false;
    });
    Fluttertoast.showToast(msg: "Product category has been created!");
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("products");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : productUploadFormScreen();
  }
}
