import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sellers_app/Model/product.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import '../widgets/error_dialog.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Products? model;

  const ItemsUploadScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController longDescriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
        title: const Text(
          "Add new items",
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
                  "Add new item",
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

  itemUploadFormScreen() {
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
          "Uploading new item",
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
            leading: const Icon(Icons.title),
            title: SizedBox(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                controller: titleController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Item name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_rounded),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                controller: shortDescriptionController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Short description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250,
              height: MediaQuery.of(context).size.height * 0.28,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: null,
                minLines: null,
                expands: true,
                textCapitalization: TextCapitalization.sentences,
                controller: longDescriptionController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "Long description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),

          SizedBox(
            height: 60,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber)
                ),
                onPressed: (){
              uploading ? null : () => validateUploadForm();
            }, child: const Text("Upload item")),
          )
        ],
      ),
    );
  }

  clearProductUploadForm() {
    setState(() {
      shortDescriptionController.clear();
      longDescriptionController.clear();
      titleController.clear();
      priceController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortDescriptionController.text.isNotEmpty &&
          longDescriptionController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //Upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //Save to firebase
        saveProductInfo(downloadUrl);
      } else {
        //Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                  message: "Please add required item details.");
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

  saveProductInfo(String downloadUrl) async {
    final ref = FirebaseFirestore.instance
        .collection("merchants")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("products")
        .doc(widget.model!.productID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "productID": widget.model!.productID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortDescription": shortDescriptionController.text.toString(),
      "longDescription": longDescriptionController.text.toString(),
      "itemTitle": titleController.text.toString(),
      "price": int.parse(priceController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      final ref = FirebaseFirestore.instance.collection("items");

      ref.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "productID": widget.model!.productID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortDescription": shortDescriptionController.text.toString(),
        "longDescription": longDescriptionController.text.toString(),
        "itemTitle": titleController.text.toString(),
        "price": int.parse(priceController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).whenComplete((){

      clearProductUploadForm();
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        uploading = false;
      });
    }).then((value){
      showDialog(context: context, builder: (c){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 150,
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("assets/animations/done.json", height: 100),
                const SizedBox(height: 10,),
                const Text('Item uploaded successfully', style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold
                ),)
              ],
            ),
          ),
        );
      });
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("items");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemUploadFormScreen();
  }
}
