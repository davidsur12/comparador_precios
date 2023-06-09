import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class addDate {
  // addDate._privateConstructor();
  static final addDate _instance = addDate._internal();

  factory addDate() {
    return _instance;
  }
  addDate._internal() {}

  var db = FirebaseFirestore.instance;
  List<String> listaCategorias = [];
  String categoria = "";
  String producto = "";
  String marca = "";
  String barcode = "";
  String nuevoProducto = "";

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

  Future<void> addProductos(Map<String, dynamic> datos) async {
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

    Map<String, String> productos = <String, String>{};
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm");
    String date = format.format(DateTime.now());

    Map<String, dynamic> valores = <String, dynamic>{
      "Producto": datos["Producto"],
      "Descripcion": datos["Descripcion"],
      "Tienda": [datos["Tienda"]],
      "Precios_" + datos["Tienda"]: [datos["Precio"]],
      "Fecha_" + datos["Tienda"]: [date]
    };
    await db
        .collection("Productos")
        .doc(categoria)
        .collection(barcode)
        .doc(barcode)
        .set(valores);
    //db.collection("Productos").doc(producto).set(productos).onError((e, _) => print("Error writing document: $e"));
  }

  addCollectioId(String producto, String id) {
    Map<String, String> valores = <String, String>{};
    Map<String, String> productos = <String, String>{};

    db
        .collection("Productos")
        .doc(producto)
        .collection(id)
        .doc(id)
        .set(valores)
        .onError((e, _) => print("Error writing document: $e"));
    //db.collection("Productos").doc(producto).set(productos).onError((e, _) => print("Error writing document: $e"));
  }

  Future<bool> checkCollectionExistence(String collectionName) async {
    final collectionRef = db.collection("Productos");
    final snapshot =
        await collectionRef.doc(categoria).collection(collectionName).get();
    //debo agregar el nomnre de barcode
    return snapshot.size > 0;
  }

  CollectionReference consultaCategorias() {
    return db.collection("Productos");
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> consultaProductos() {
    return db
        .collection('Productos')
        .doc(categoria)
        .collection(barcode)
        .doc(barcode)
        .snapshots();
  }

  Future<DocumentSnapshot> getDocumentData() async {
    DocumentSnapshot snapshot = await db
        .collection('Productos')
        .doc(categoria)
        .collection(barcode)
        .doc(barcode)
        .get();

    return snapshot;
    /*
  if (snapshot.exists) {
    // El documento existe, puedes acceder a sus datos
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    
    // Realiza las operaciones necesarias con los datos del documento
    // Por ejemplo, imprime el valor de un campo específico
    //print(data['Producto']);
  } else {
    // El documento no existe
    print('El documento no existe');
  }
  */
  }

  deleteDocument(String doc) {
    db.collection("Productos").doc(doc).delete().then(
          (doc) => print("Documento eliminado"),
          onError: (e) => print("Error Documento no eliminado $e"),
        );
  }

  Future<String> addTienda(String nuevaTienda, String precio) async {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm");
    String date = format.format(DateTime.now());

    String result = "Agregado correctamente";

    Map<String, dynamic> valores = <String, dynamic>{
      "Precios_" + nuevaTienda: [precio],
      "Fecha_" + nuevaTienda: [date],
    };

    final DocumentReference document = db
        .collection("Productos")
        .doc(categoria)
        .collection(barcode)
        .doc(barcode);

    document.update({
      'Tienda': FieldValue.arrayUnion([nuevaTienda]),
    }).onError((error, stackTrace) => () {
          result = "Error al agregar";
        });

    document.update(valores).onError((error, stackTrace) => () {
          result = "Error al agregar";
        });
    return result;
  }

  Future<String> agregarPrecio(String tienda, String nuevoPrecio) async {
    String result = "Precio agregado";
    final DocumentReference document = db
        .collection("Productos")
        .doc(categoria)
        .collection(barcode)
        .doc(barcode);

    print("Tienda = $tienda");
    print("Precio = $nuevoPrecio");
    document.update({
      "Fecha_$tienda": FieldValue.arrayUnion([getFecha()]),
      "Precios_$tienda": FieldValue.arrayUnion([nuevoPrecio]),
    }).onError((error, stackTrace) => () {
          //result = "Error al agregar";
          result = "Error al agregar el precio";
        });

    return result;
  }

  actualizarDatos(Map<String , dynamic> datos) {
//esta funcion debe actualizar los datos que se ingresen en los campos como producto descricion del roducto, precio de cada fecha
//y el nombre de las tiendas
    final DocumentReference document = db
        .collection("Productos")
        .doc(categoria)
        .collection(barcode)
        .doc(barcode);
   document.update(datos);
  }

  updateNameTienda(String tienda1, String tienda2, List<String> listaFecha,
      List<String> listaPrecios, int indexTienda) {
    //tienda1 es la tienda que vamos  a borrar
    //tienda2  es el nuevo nombre de la tienda

    print("Tienda1 = $tienda1");
    print("Tienda2 = $tienda2");
    print("Lista fecha = $listaFecha");
    print("Lista precios = $listaPrecios");
    print("index = $indexTienda");

  final DocumentReference document = db
        .collection("Productos")
        .doc(categoria)
        .collection(barcode)
        .doc(barcode);
     document.update({
//agrego la nueva tienda y los valores
     'Tienda': FieldValue.arrayUnion([tienda2]),
      "Precios_$tienda2": List.from(listaPrecios),
      "Fecha_$tienda2": List.from(listaFecha),  
      });

     document.update({
      //borro la tienda  y los valores
      'Tienda': FieldValue.arrayRemove([tienda1]),
       "Precios_$tienda1":  FieldValue.delete(),
       "Fecha_$tienda1":FieldValue.delete(),
     });

     

/*
 '"Precios_$tienda1"': FieldValue.arrayRemove(["Precios_$tienda1"]),
  documentReference.update({
    'nombre_array': FieldValue.arrayRemove([element])
  }).then((value) {
    print('Elemento eliminado del array correctamente');
  }).catchError((error) {
    print('Error al eliminar el elemento del array: $error');
  });
 */
  }

  String getFecha() {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm");
    return format.format(DateTime.now());
  }



}
