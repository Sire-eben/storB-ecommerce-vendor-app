import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/widgets/custom_drawer.dart';
import 'package:sellers_app/widgets/text_widget.dart';

import '../Model/items.dart';
import '../Model/product.dart';
import '../global/global.dart';
import '../uploadScreens/items_upload_screen.dart';
import '../widgets/info_design.dart';
import '../widgets/items_design_widget.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Products? model;

  const ItemsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontFamily: "Lobster",
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            ItemsUploadScreen(model: widget.model)));
              },
              icon: const Icon(Icons.library_add))
        ],
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextHeaderWidget(
                title:
                    "My " + widget.model!.productTitle.toString() + "'s items"),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("merchants")
                .doc(sharedPreferences!.getString("uid"))
                .collection('products')
                .doc(widget.model!.productID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    );
              } if(snapshot.data!.docs.isEmpty){
                return SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.width /1.5,),
                        Icon(Icons.shop,color: Colors.grey.shade300,size: 100,),
                        Text("You have no items in this category!"),
                      ],
                    ),
                  ),
                );
              }else {
                return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()!
                          as Map<String, dynamic>);
                      return ItemDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                    itemCount: snapshot.data!.docs.length);
              }
            },
          )
        ],
      ),
    );
  }
}
