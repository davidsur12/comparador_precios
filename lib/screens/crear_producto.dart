import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precios/screens/info_producto.dart';




class CrearProducto extends StatefulWidget {
  const CrearProducto({super.key});

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  //controladires de textfield
  TextEditingController controllerProducto = TextEditingController();
  TextEditingController controllerDescripcion = TextEditingController();
  TextEditingController controllerTienda = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();

  //decoration para textfield
  InputDecoration decorationn = const InputDecoration(
    hintStyle: TextStyle(fontSize: 17),
    hintText: 'Ingresa los datos',
    suffixIcon: Icon(Icons.keyboard),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agregar producto"),
        ),
        body: formulario());
  }

  Widget formulario() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [producto(), descripcion(), tienda(), precio(), btnAdd()],
    ));
  }

  Widget producto() {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text("Producto: "),
            ),
            Expanded(
                // width: 300,
                child: TextField(
              controller: controllerProducto,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget descripcion() {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text("Descripcion: "),
            ),
            Expanded(
                child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: controllerDescripcion,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget tienda() {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text("Tienda: "),
            ),
            Expanded(
                child: TextField(
              controller: controllerTienda,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget precio() {
    final RegExp _numericRegex = RegExp(r'^\d+\.?\d*$');
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text("Precio: "),
            ),
            Expanded(
                child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final isValid = _numericRegex.hasMatch(newValue.text);
                  return isValid ? newValue : oldValue;
                }),
              ],
              controller: controllerPrecio,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget btnAdd() {
    return ElevatedButton(
        child: Text("Agregar Producto"),
        onPressed: () {
          agregarDatos();
        });
  }

  agregarDatos() {
//elimino los espacios
    controllerPrecio.text = controllerPrecio.text.replaceAll(' ', '');
   // controllerDescripcion.text = controllerDescripcion.text.replaceAll(' ', '');
    //controllerProducto.text = controllerProducto.text.replaceAll(' ', '');
    controllerTienda.text = controllerTienda.text.replaceAll(' ', '');
    //verifico que los textfield no esten vacios
    if (controllerPrecio.text.isNotEmpty &&
        controllerDescripcion.text.isNotEmpty &&
        controllerProducto.text.isNotEmpty &&
        controllerTienda.text.isNotEmpty) {
      Map<String, dynamic> datos = <String, dynamic>{
        "Producto": controllerProducto.text,
        "Descripcion": controllerDescripcion.text,
        "Tienda": controllerTienda.text,
        "Precio": controllerPrecio.text,
      };

      // print(datos);
      addDate().addProductos(datos).then((result) {
        toast('Datos agregados correctamente');
         GoinfoProducto();
      }).catchError((error) {
        toast('Error al agregar los datos $error');
      });
    } else {
      toast('Porfavor llena todos lo campos');
    }
  }

  toast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
    );
  }

  GoinfoProducto(){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InfoProducto()),
    );
  }


}
//flutter pub add firebase_storage
//https://firebase.google.com/docs/storage/flutter/start?hl=es-419&authuser=0