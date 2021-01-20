import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  List<Product> products = [];
  List<Activity> activitys = [];

  MainViewModel() {
    getProducts();
    getActivitys();
  }

  getProducts() {
    Firestore.instance.collection("products").getDocuments().then((value) {
      log("[getProducts] value:${value.documents.length}");
      if (value.documents.isNotEmpty) {
        products.clear();
        value.documents.map((e) {
          log("[documents] ID:${e.documentID}, data:${e.data.toString()}");
          products.add(Product(e.documentID, e.data["imgPath"]));
        }).toList();
        notifyListeners();
      }
    });
  }

  getActivitys() {
    Firestore.instance.collection("activitys").getDocuments().then((value) {
      log("[getActivitys] value:${value.documents.length}");
      if (value.documents.isNotEmpty) {
        activitys.clear();
        value.documents.map((e) {
          log("[documents] ID:${e.documentID}, data:${e.data.toString()}");
          activitys.add(Activity(
              e.data["title"], e.data["content"], e.data["createDate"].toString()));
        }).toList();
        notifyListeners();
      }
    });
  }
}

class Product {
  String title;
  String imgPath;

  Product(this.title, this.imgPath);
}

class Activity {
  String title;
  String content;
  String date;

  Activity(this.title, this.content, this.date);
}
