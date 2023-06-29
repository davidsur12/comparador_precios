import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:precios/firestore/storage.dart';

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class InfoProducto extends StatefulWidget {
  const InfoProducto({super.key});

  @override
  State<InfoProducto> createState() => _InfoProductoState();
}

class _InfoProductoState extends State<InfoProducto> {
//controladires de textfield
  TextEditingController controllerProducto = TextEditingController();
  TextEditingController controllerDescripcion = TextEditingController();
  TextEditingController controllerTienda = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();
  TextEditingController controllerFecha = TextEditingController();
  TextEditingController controllerNuevaTienda = TextEditingController();
  TextEditingController controllerNuevoPrecio = TextEditingController();
  TextEditingController controllerCambioNombreTienda = TextEditingController();
//lista de dropdown
  String _selectItemTienda = "";
  List<String> _itemsTienda = [];

  String _selectItemFecha = "";
  List<String> _itemsFecha = [];

  String _selectItemPrecio = "";
  List<String> _itemsPrecio = [];

//context
  BuildContext? contextAlert;

  //index
  int indexSelectTienda = 0;
  int indexSelectFecha = 0;
  //file
  File? file;
  Uint8List? imageData;
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
  void initState() {
    controllerProducto.text = "";
    controllerDescripcion.text = "";
    controllerTienda.text = "";
    controllerPrecio.text = "";
    controllerFecha.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contextAlert = context;
    return Scaffold(
        appBar: AppBar(
          title: Text("Info productos"),
        ),
        body: SingleChildScrollView(
          child: info(),
        ) //info(),

        );
  }

  Widget info() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: producto4(),
        ),
        btnImagen(),
        cargarImage(context),
        btn3()
      ],
    );
  }

  Widget btn3() {
    return ElevatedButton(
        onPressed: () {
          storageFirebase().consultaraImg(addDate().barcode).then((value) {
            print(value);
          });
        },
        child: Text("consultar imagen"));
  }

  Widget producto4() {
    return StreamBuilder<DocumentSnapshot>(
        stream: Stream.fromFuture(addDate().getDocumentData()),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Si la conexión está en espera, se muestra un indicador de carga
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              // Si se produce un error durante la carga, se muestra un mensaje de error
              return Text('Error: ${snapshot.error}');
            } else {
              // Si la carga es exitosa, puedes acceder a los datos del DocumentSnapshot
              final document = snapshot.data;
              Map<String, dynamic> data =
                  document!.data() as Map<String, dynamic>;

              try {
                _itemsTienda = List.from(data["Tienda"]);
                _itemsTienda.add("Agregar Tienda");
                _selectItemTienda = _itemsTienda[indexSelectTienda];

                if (_itemsTienda.length - 1 != indexSelectTienda) {
                  indexSelectTienda = indexSelectTienda;

                  _itemsFecha = List.from(data["Fecha_$_selectItemTienda"]);
                  _selectItemFecha = _itemsFecha[indexSelectFecha];

                  _itemsPrecio = List.from(data["Precios_$_selectItemTienda"]);
                  _selectItemPrecio = _itemsPrecio[indexSelectFecha].toString();
                  controllerPrecio.text = _selectItemPrecio;
                }

                controllerProducto.text = data['Producto'];
                controllerDescripcion.text = data['Descripcion'];
                controllerPrecio.text = _selectItemPrecio;

                return Column(
                  children: [
                    producto(),
                    descripcion(),
                    precio(),
                    tiendas(),
                    cambiarNombreTienda(),
                    fecha(),
                    precio(),
                    actualizarPrecio(),
                    agregarPrecio(),
                  ],
                );
              } catch (e) {
                print("error $e");
              }

              return ElevatedButton(
                child: Text("Algo salio mal"),
                onPressed: () {
                  setState(() {});
                },
              );
            }
          }
        });
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
                // width: 300,
                child: TextField(
              maxLines: null,
              controller: controllerDescripcion,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget tiendas() {
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
              child: DropdownButton<String>(
                value: _selectItemTienda,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectItemTienda = newValue!;
                    indexSelectTienda = _itemsTienda.indexWhere(
                        (elemento) => elemento == _selectItemTienda);
                    print("Cambio " + _selectItemTienda);

                    if (_selectItemTienda == "Agregar Tienda") {
                      alertNuevaTienda();
                    }
                  });
                },
                items: _itemsTienda.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }

  alertNuevaTienda() {
//validar  auitar los espacio en los textos ingresados
//agregar los valores a a los areglos en firebase con notificacion y todo y recargar la paguina
    final RegExp _numericRegex = RegExp(r'^\d+\.?\d*$');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva Tienda'),
          content: Container(
            width: 200,
            height: 130,
            child: Column(
              children: [
                TextField(
                  controller: controllerNuevaTienda,
                  decoration: InputDecoration(
                    hintText: 'Tienda',
                  ),
                ),
                TextField(
                    controller: controllerNuevoPrecio,
                    decoration: InputDecoration(
                      hintText: 'Precio',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final isValid = _numericRegex.hasMatch(newValue.text);
                        return isValid ? newValue : oldValue;
                      }),
                    ]),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                // Cerrar el diálogo
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                addTienda();
                /* Fluttertoast.showToast(
              msg: "barcode = $result",
              backgroundColor: Colors.green,
            );*/
                Navigator.of(context).pop();
                setState(() {});

                /*
               muestro el alert dialogo para crear un nuevo producto con los diferentes 
               campos a llenar luego registro el producto y la nformacion basica 
                */
              },
            ),
          ],
        );
      },
    );
  }

  Widget precio() {
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
                // width: 300,
                child: TextField(
              controller: controllerPrecio,
              decoration: decorationn,
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  Widget fecha() {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text("fecha del precio: "),
            ),
            Expanded(
                // width: 300,
                child: DropdownButton<String>(
              value: _selectItemFecha,
              onChanged: (String? newValue) {
                _selectItemFecha = newValue!;
                indexSelectFecha = _itemsFecha
                    .indexWhere((elemento) => elemento == _selectItemFecha);
                print("Cambio " + _selectItemFecha);
                setState(() {
                  _selectItemFecha = newValue!;
                });
              },
              items: _itemsFecha.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            )),
          ],
        ));
  }

  Widget getInfo() {
    return ElevatedButton(
        child: Text("consult"),
        onPressed: () {
//addDate().getDocumentData();
          addDate().getDocumentData().then((value) {
            //Map<String, dynamic> data = value.data() as Map<String, dynamic>;
            //print(data['Producto']);
            if (value.exists) {
              // El documento existe, puedes acceder a sus datos
              Map<String, dynamic> data = value.data() as Map<String, dynamic>;

              // Realiza las operaciones necesarias con los datos del documento
              // Por ejemplo, imprime el valor de un campo específico
              print(data['Producto']);
            } else {
              // El documento no existe
              print('El documento no existe');
            }
          });
        });
  }

  Widget agregarPrecio() {
    return ElevatedButton(
        onPressed: () {
          alertPrecio();
        },
        child: Text("Agregar Precio"));
  }

  alertPrecio() {
    final RegExp _numericRegex = RegExp(r'^\d+\.?\d*$');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Precio'),
          content: Container(
            width: 200,
            height: 130,
            child: Column(
              children: [
                TextField(
                    controller: controllerNuevoPrecio,
                    decoration: InputDecoration(
                      hintText: 'Precio',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final isValid = _numericRegex.hasMatch(newValue.text);
                        return isValid ? newValue : oldValue;
                      }),
                    ]),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                // Cerrar el diálogo
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                addPrecio();
                Navigator.of(context).pop();
                setState(() {});

                /*
               muestro el alert dialogo para crear un nuevo producto con los diferentes 
               campos a llenar luego registro el producto y la nformacion basica 
                */
              },
            ),
          ],
        );
      },
    );
  }

  Widget actualizarPrecio() {
    return ElevatedButton(
        onPressed: () {
          actulaizarDatos();
        },
        child: Text("Actualizar precio"));
  }

  Widget cambiarNombreTienda() {
    return ElevatedButton(
      child: Text("Cambiar nombre tienda"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cambio de Nombre de $_selectItemTienda'),
              content: Container(
                width: 200,
                height: 130,
                child: Column(
                  children: [
                    TextField(
                      controller: controllerCambioNombreTienda,
                      decoration: InputDecoration(
                        hintText: 'Tienda',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    // Cerrar el diálogo
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Cambiar'),
                  onPressed: () {
                    updateNameTienda();
                    /* Fluttertoast.showToast(
              msg: "barcode = $result",
              backgroundColor: Colors.green,
            );*/
                    Navigator.of(context).pop();
                    setState(() {});

                    /*
               muestro el alert dialogo para crear un nuevo producto con los diferentes 
               campos a llenar luego registro el producto y la nformacion basica 
                */
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  addTienda() {
    controllerNuevaTienda.text =
        controllerNuevaTienda.text.replaceAll(' ', ''); //quito los espacios
    addDate()
        .addTienda(controllerNuevaTienda.text, controllerNuevoPrecio.text)
        .then((value) {
      Fluttertoast.showToast(
        msg: value,
        backgroundColor: Colors.green,
      );
    });
  }

  addPrecio() {
    controllerNuevoPrecio.text = controllerNuevoPrecio.text.replaceAll(' ', '');
    addDate()
        .agregarPrecio("$_selectItemTienda", controllerNuevoPrecio.text)
        .then((value) {
      Fluttertoast.showToast(
        msg: value,
        backgroundColor: Colors.green,
      );
    });
    /**/
  }

  updateNameTienda() {
    addDate().updateNameTienda(
        _selectItemTienda,
        controllerCambioNombreTienda.text,
        _itemsFecha,
        _itemsPrecio,
        indexSelectTienda);
  }

  actulaizarDatos() {
    var precios = List.from(_itemsPrecio);
    precios[indexSelectFecha] = controllerNuevoPrecio.text;
    precios[indexSelectFecha] = controllerPrecio.text;
    Map<String, dynamic> datos = {
      "Producto": controllerProducto.text,
      "Descripcion": controllerDescripcion.text,
      "Precios_$_selectItemTienda": precios,
    };
    addDate().actualizarDatos(datos);
    print("nuevos datos = " + datos.toString());
  }

  Widget btnImagen() {
    return ElevatedButton(
        onPressed: () async {
          ImagePicker picker = ImagePicker();
          XFile? image = await picker.pickImage(source: ImageSource.gallery);
          imageData = await image!.readAsBytes();
          // print("presione el boton");
          if (image != null) {
            //  print("deberia obtener la image");
            setState(() {
              print(image.path.toString());
              file = File(image.path);

              //img.image = image;
            });
          }
        },
        child: Padding(
            padding: EdgeInsets.only(
                top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
            child: Text(
              "Seleccionar  Imagen",
              style: TextStyle(fontSize: 20.0),
            )));
  }

  Widget cargarImage(BuildContext context) {
    if (file != null) {
      print(file!);
      File imageFile = File(file!.path);

      try {
        if (kIsWeb) {
          // Lógica específica para el entorno web
          print('La aplicación se está ejecutando en un navegador web');
         
            storageFirebase().uploadFile(imageData, addDate().barcode).then((value) {

     
    
                Fluttertoast.showToast(
            msg: value.toString(),
            backgroundColor: Colors.green,);
            });
/*
      print(result);
                Fluttertoast.showToast(
            msg: result.toString(),
            backgroundColor: Colors.green,);

*/
          return Image.network(file!.path);
        } else {
          // Lógica específica para Android u otro entorno
          print('La aplicación se está ejecutando en Android u otro entorno');
          storageFirebase().subirImagen(addDate().barcode, file!);

          return Image(
            image: FileImage(file!),
          );
        }
      } catch (e) {
        return Text(e.toString());
      }
      return Text("l");
    } else {
      //imgLoag = false;
      return Text("");
    }
  }

  Future<void> imgGallery(String path) async {
    String result = "";
    Uint8List imageData = await XFile(path).readAsBytes();
//result=await storageFirebase().subirImageWeb(imageData , addDate().barcode);

    Fluttertoast.showToast(
      msg: result,
      backgroundColor: Colors.green,
    );
  }
}
