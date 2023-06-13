import 'package:firebase_storage/firebase_storage.dart';

class storageFirebase{
final storage = FirebaseStorage.instance;


subirImagen(String id){
// Create a storage reference from our app
final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
final mountainsRef = storageRef.child(id);

// Create a reference to 'images/mountains.jpg'
final mountainImagesRef = storageRef.child("images/mountains.jpg");

// While the file names are the same, the references point to different files
assert(mountainsRef.name == mountainImagesRef.name);
assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

}
}