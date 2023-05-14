import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import 'package:precios/screens/categorias.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addDate {
  var db = FirebaseFirestore.instance;
  List<String>listaCategorias = [];

  addDate(){
    //leerdatos();

  }
  addCategoria(){
        final refrescos = <String, String>{
  "name": "agua de coco",
  "precio": "5000",
  "Descripcion": "es agua de coco 253g sin sabor fecha de vencimiento 5-02-2023"
};

db.collection("Productos")
    .doc("Refrescos")
    .set(refrescos)
    .onError((e, _) => print("Error writing document: $e"));
  }
 //Future<List<String>> 
 void _onItemTapped(int index , String categoria) {
    // Manejar el evento de toque en el elemento de la lista
    print('Elemento tocado: $index = $categoria');
    Fluttertoast.showToast(
    msg: "$categoria",
    backgroundColor: Colors.green,
);
  }
  Widget leerdatos(ScrollController controller) {
    List<String> lista=[];
   final CollectionReference collectionReference = db.collection("Productos");
return StreamBuilder<QuerySnapshot>(
  stream: collectionReference.snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text('Error al obtener los datos');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('Cargando');
    }
    
   
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      controller: controller,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(snapshot.data!.docs[index].id , textAlign: TextAlign.center,),
          hoverColor: Colors.black,
           onTap: () => _onItemTapped(index , snapshot.data!.docs[index].id),
         // subtitle: Text(snapshot.data!.docs[index]['nombreDelOtroCampo']),
        );
      },
    );
  },
);

  }

 
}
