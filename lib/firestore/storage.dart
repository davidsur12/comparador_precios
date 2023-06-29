import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';




import "package:cross_file/src/types/interface.dart";



class storageFirebase {
  final storage = FirebaseStorage.instance;

  subirImagen(String id, File path) async {
// Create a storage reference from our app
//final storageRef = FirebaseStorage.instance.ref();

    try {
      var snapshot =
          await storage.ref().child('image_productos/$id').putFile(path);
    } catch (e) {
      print(e);
    }
  }

  subirImageWeb(Uint8List xfile, String id , String path) async {
    String result = "";
    String downloadUrl = "";
 final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': path},
    );

    try {
      Reference ref = storage.ref().child('image_productos2');
      ref.child(id);

      ref
          .putData(
            await xfile,
            SettableMetadata(contentType: '$id/jpg'),
          )
          .snapshotEvents
          .listen((event) {
        switch (event.state) {
          case TaskState.running:
            result = "Comenzando";

            break;
          case TaskState.paused:
            result = "Pausa";
            print("Pausa");
            break;
          case TaskState.success:
            result = "Imagen subida";
            print("Imagen subida");
            break;
          case TaskState.canceled:
            result = "Tarea cancelada";
            print("Tarea cancelada");
            break;
          case TaskState.error:
            result = "Error ";
            print("Error ");
            break;
        }
      });

      downloadUrl = await ref.getDownloadURL();
      print(downloadUrl);
    } catch (e) {}

    return "$result Url= $downloadUrl";
  }

 consultaraImg(String name ) async {
    final storageRef = FirebaseStorage.instance.ref().child("image_productos");
final listResult = await storageRef.listAll();

for (var item in listResult.items) {
 print(item.name);
 print(await item.getDownloadURL());
}
  }


  // uploadFile(XFile file ) async {
 Future<String>  uploadFile(Uint8List? imageData , String name ) async {
  String result = "";
    String downloadUrl = "";
    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('image_productos')
        .child('/$name');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
     // customMetadata: {'picked-file-path': file.path},
    );

  
      ref.putData(await imageData!, metadata).snapshotEvents.listen((event) {
         switch (event.state) {
          case TaskState.running:
            result = "Comenzando";

            break;
          case TaskState.paused:
            result = "Pausa";
            print("Pausa");
            break;
          case TaskState.success:
            result = "Imagen subida";
            print("Imagen subida");
            break;
          case TaskState.canceled:
            result = "Tarea cancelada";
            print("Tarea cancelada");
            break;
          case TaskState.error:
            result = "Error ";
            print("Error ");
            break;


      }
      
      
      });
      
       downloadUrl =  await ref.getDownloadURL();
      print(downloadUrl);
      return result +"  "+downloadUrl;
    

   
   //  return uploadTask;
  }
}
