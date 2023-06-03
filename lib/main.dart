import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:precios/screens/productos.dart';
import 'firebase_options.dart';
import 'package:precios/screens/categorias.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  
   WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
   runApp( MyApp());

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
      home:const MyHomePage(title: 'Control de Precios'),
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

        title: Center(child:Text(widget.title , textAlign: TextAlign.center,)),
      ),
      body:const Categorias(),
         
    ));
  }

}
