import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String? productID;
  String? sellerUID;
  String? productTitle;
  String? productDescription;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Products({
    this.sellerUID,
    this.productDescription,
    this.productID,
    this.productTitle,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
  });

  Products.fromJson(Map<String, dynamic> json){
    productID = json["productID"];
    sellerUID = json["sellerUID"];
    productTitle = json["productTitle"];
    productDescription = json["productDescription"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["productID"] = productID;
    data["sellerUID"] = sellerUID;
    data["productTitle"] = productTitle;
    data["productDescription"] = productDescription;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }
}
