import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/Model/product.dart';
import 'package:sellers_app/global/global.dart';

import '../mainScreens/itemsScreen.dart';

class InfoDesignWidget extends StatefulWidget {
  Products? model;
  BuildContext? context;

  InfoDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteProduct(String productID) {
    FirebaseFirestore.instance
        .collection("merchants")
        .doc(sharedPreferences!.getString("uid"))
        .collection("products")
        .doc(productID)
        .delete()
        .then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Product deleted successfully!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ItemsScreen(model: widget.model)));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300, spreadRadius: 15, blurRadius: 15),
          ]),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model!.productTitle!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.model!.productDescription!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.cyan,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Product?"),
                              actions: [
                                TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text("Yes", style: TextStyle(
                                    color: Colors.red,
                                  ),),
                                  onPressed: () {
                                    //DELETE PRODUCT
                                    deleteProduct(widget.model!.productID!);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
