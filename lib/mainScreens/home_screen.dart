import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/Model/product.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/uploadScreens/menu_upload.dart';
import 'package:sellers_app/widgets/custom_drawer.dart';
import 'package:sellers_app/widgets/info_design.dart';
import 'package:sellers_app/widgets/progress_bar.dart';

import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          style: TextStyle(
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
                        builder: (c) => const MenuUploadScreen()));
              },
              icon: const Icon(Icons.post_add))
        ],
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextHeaderWidget(title: "My Products")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("merchants")
                .doc(sharedPreferences!.getString("uid"))
                .collection('products')
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
                        Icon(Icons.add_shopping_cart_rounded,color: Colors.grey.shade300,size: 100,),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(Colors.cyan),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(width: 1, color: Colors.cyan)
                              ))
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const MenuUploadScreen()));
                            },
                              icon: Icon(Icons.add),
                              label: Text("Upload your first Product!")),
                        ),
                      ],
                    ),
                  ),
                );
              }else {
                return SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Products model = Products.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>);
                        return InfoDesignWidget(
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
