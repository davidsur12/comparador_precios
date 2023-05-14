import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:precios/screens/categorias.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {





  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(home:Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
    
        child: Categorias(),
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }

/*

  void addDate(){
    final user = <String, dynamic>{
  "first": "Ada",
  "last": "Lovelace",
  "born": 1815
};

// Add a new document with a generated ID
/*
db.collection("Productos").add(user).then((DocumentReference doc) =>
    print('DocumentSnapshot added with ID: ${doc.id}'));
    */
    final jabonCoco = <String, String>{
  "id": "1239",
  "Precio": "5000",
  "Descripcion": "Jabon marca coco peso 12.0g olor a limon fecha de vec 3/9/2025"
};
    db.collection("Productos").doc("Jabones").collection("Coco").doc("1239").set(jabonCoco).onError((error, stackTrace) => print("nose agrego"));
  }

  void leerdatos()async{
    await db.collection("Productos").get().then((event) {
  for (var doc in event.docs) {
    print("${doc.id} => ${doc.data()}");
  }
});
  }
  */
}
