import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import 'package:precios/screens/categorias.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addDate {
  var db = FirebaseFirestore.instance;
  List<String> listaCategorias = [];

  addCategoria(String categoria) {
  
    Map<String, String> marcas = <String, String>{};

    db
        .collection("Productos")
        .doc(categoria)
        .set(marcas)
        .onError((e, _) => print("Error writing document: $e"));
    /*.doc("Refrescos")
    .set(refrescos)
    .onError((e, _) => print("Error writing document: $e"));
    */
  }

  CollectionReference consultaCategorias() {
    return db.collection("Productos");
  }
}
