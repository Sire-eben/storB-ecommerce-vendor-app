import 'package:flutter/material.dart';
import 'package:sellers_app/Model/items.dart';
import 'package:sellers_app/mainScreens/item_detail_screen.dart';

import '../mainScreens/itemsScreen.dart';

class ItemDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  @override
  State<ItemDesignWidget> createState() => _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemDetailsScreen(
                      model: widget.model,
                    )));
      },
      splashColor: Colors.amber,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, spreadRadius: 15, blurRadius: 15),
        ]),
        child: Column(
          children: [
            Text(
              widget.model!.itemTitle!,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 210,
              fit: BoxFit.cover,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Text(
                widget.model!.shortDescription!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
