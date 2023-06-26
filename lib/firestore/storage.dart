import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

class storageFirebase {
  final storage = FirebaseStorage.instance;

  subirImagen(String id, File path) async {
// Create a storage reference from our app
//final storageRef = FirebaseStorage.instance.ref();

    try {
      var snapshot =
          await storage.ref().child('image_productos/$id').putFile(path);

      // var downloadUrl = await snapshot.ref.getDownloadURL();
      //https://stackoverflow.com/questions/58459483/unsupported-operation-platform-operatingsystem

//Reference ref = storage.ref().child('images/imagen.jpg');
//UploadTask uploadTask = ref.putFile(path);
    } catch (e) {
      print(e);
    }

/*
// Create a reference to "mountains.jpg"
final mountainsRef = storageRef.child(id);

// Create a reference to 'images/mountains.jpg'
final mountainImagesRef = storageRef.child("images/mountains.jpg");
*/
// While the file names are the same, the references point to different files

/*
uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  if (snapshot.state == TaskState.running) {
    double progress = snapshot.bytesTransferred / snapshot.totalBytes;
    // Actualiza el progreso de subida...
    print(" Actualiza el progreso de subida...");
  } else if (snapshot.state == TaskState.success) {
    print("La imagen se ha subido con éxito,");
    //String downloadURL = await snapshot.ref.getDownloadURL();
    // La imagen se ha subido con éxito, puedes usar la URL de descarga como lo desees.
  }
});
*/
  }

  subirImageWeb(Uint8List xfile, String id) async {

   String result="";
    Reference ref = storage.ref().child('Folder');
    ref.child(id);

    ref.putData(
          xfile,
          SettableMetadata(contentType: 'image/png'),
        )
        .snapshotEvents
        .listen((event) {
      switch (event.state) {
        case TaskState.running:
          result="Comenzando";
         
          break;
        case TaskState.paused:
         result="Pausa";
          print("Pausa");
          break;
        case TaskState.success:
         result="Imagen subida";
          print("Imagen subida");
          break;
        case TaskState.canceled:
        result="Tarea cancelada";
          print("Tarea cancelada");
          break;
        case TaskState.error:
          result="Error ";
          print("Error ");
          break;
      }
    });

    String downloadUrl = await ref.getDownloadURL();

    return "$result Url= $downloadUrl";
  }
}
