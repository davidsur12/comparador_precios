//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';



class addDate {

 // addDate._privateConstructor();
  static final addDate _instance = addDate._internal();

  factory addDate() {
    return _instance;
  }
  addDate._internal() {
    
  }

  var db = FirebaseFirestore.instance;
  List<String> listaCategorias = [];
  String categoria = "";
  String producto = "";
  String marca = "";
  String barcode = "";

  
  
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

  addProductos( String barcode , Map<String , dynamic> datos) {
    /*para agregar un producto nesecito saber la categoria a la que pertenece el codigo de barras del producto
    este va hacer el nombre de la collection y el nombre de el documeto  cada documento debera tener los siguientes campos
    String Producto = mayonesa colombina o  Spaguetti Clásico DORIA 1000 gr (deberia tener nombre del producto
    la marca y el contenido)
    String Marca = colombina  por el mometo  se salta por que la marca va en el producto y en la descripcion
    Descripcion = mayonesa de 500g marca colombina deberia tener la descripcion del producto como vitaminas y propiedades
    array precioSupermercado = [2000 , 300 , 400 , 500]
    array fechaSupermercado =[fecha , fecha , fecha]

    por cada supermercado deberia tener un array de precios y fechas
    a la hora de actualizar o los precios en la aplicaicon deberia tener una opcion de ingresar nuevo supermercado
    puede ser alertdialog con los siguientes campos Nombre del supermercado, fecha  y precio

    en la pantalla del descripcion del producto deberia tener una opcion de actualizar los campos como la descripcion
    producto y la marca 

    si es primera vez que se crea el producto se debera los siguientes campos nulos  prodcuto marca descripcion
     para  luego llenar los campos correctamene
     deberia tener un campo supermercado para saber cuantos supermercado tengo y en caso de que este vacio los precios nose mostraran en caso de lo omptrario se 
mostraran con el nombre del supermercado y el precio
    
supermercado se cmabia por tienda
debo cambiar el nombre de variable producto por categoria

     */
     Map<String, dynamic> valores = <String, String>{};
    Map<String, String> productos = <String, String>{"Productos":barcode};

    db.collection("Productos").doc(producto).collection(barcode).doc(barcode).set(valores).onError((e, _) => print("Error writing document: $e"));
   // db.collection("Productos").doc(producto).set(productos).onError((e, _) => print("Error writing document: $e"));
    
  }


  addCollectioId(String producto,  String id) {
     Map<String, String> valores = <String, String>{};
    Map<String, String> productos = <String, String>{};

    db.collection("Productos").doc(producto).collection(id).doc(id).set(valores).onError((e, _) => print("Error writing document: $e"));
    //db.collection("Productos").doc(producto).set(productos).onError((e, _) => print("Error writing document: $e"));
    
  }

 Future<bool> checkCollectionExistence(String collectionName ) async {
  final collectionRef = db.collection("Productos");
  final snapshot = await collectionRef.doc(categoria).collection(collectionName).get();
 //debo agregar el nomnre de barcode 
  return snapshot.size>0; 
}

  CollectionReference consultaCategorias() {
    return db.collection("Productos");
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> consultaProductos() {

   return  db.collection('Productos').doc(categoria).collection(barcode).doc(barcode).snapshots();
    
  }

  void deleteDocument(String doc) {
    db.collection("Productos").doc(doc).delete().then(
          (doc) => print("Document eliminado"),
          onError: (e) => print("Error Documento no eliminado $e"),
        );
  }
}