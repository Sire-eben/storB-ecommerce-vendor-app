import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? productID;
  String? sellerUID;
  String? itemID;
  String? sellerName;
  String? shortDescription;
  String? longDescription;
  String? itemTitle;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;
  int? price;

  Items({
    this.sellerUID,
    this.productID,
    this.thumbnailUrl,
    this.status,
    this.publishedDate,
    this.sellerName,
    this.itemID,
    this.itemTitle,
    this.longDescription,
    this.price,
    this.shortDescription
  });

  Items.fromJson(Map<String, dynamic> json){
    productID = json["productID"];
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    itemID = json["itemID"];
    itemTitle = json["itemTitle"];
    shortDescription = json["shortDescription"];
    longDescription = json["longDescription"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    price = json["price"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["productID"] = productID;
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["itemID"] = itemID;
    data["itemTitle"] = itemTitle;
    data["shortDescription"] = shortDescription;
    data["longDescription"] = longDescription;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    data["price"] = price;

    return data;
  }
}
