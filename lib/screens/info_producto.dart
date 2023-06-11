import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
      body: info(),
    );
  }

  Widget info() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: producto4(),
        ),
        getInfo()
      ],
    );
  }

  Widget producto2() {
    return FutureBuilder<DocumentSnapshot>(
        future: addDate().getDocumentData(),
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

              contextAlert = context;
              final document = snapshot.data;
              Map<String, dynamic> data =
                  document!.data() as Map<String, dynamic>;

              _itemsTienda = List.from(data["Tienda"]);
              _itemsTienda.add("Agregar Tienda");
              _selectItemTienda = _itemsTienda[indexSelectTienda];

              _itemsFecha = List.from(data["Fecha_$_selectItemTienda"]);
              _selectItemFecha = _itemsFecha[0];

              _itemsPrecio = List.from(data["Precios_$_selectItemTienda"]);
              _selectItemPrecio = _itemsPrecio[0].toString();

              //adtualizo los datos  aa los controladores de los textfield
              controllerProducto.text = data['Producto'];
              controllerDescripcion.text = data['Descripcion'];
              controllerPrecio.text = _selectItemPrecio;
//deberia pasar como parametro cada lista o valor y dentro de la funcion se debera hacer toda la logica
//para mostar los datos  en los que usan list se debera mostar el ultimo valor de array  y se debera
//tener la capcidad de cambiar y mostar el valor correspondiente segun el item selecionado
//ademas se debe programar el boton de actualizar.

// corregir lo del lector qr para que redirija hacia  la ventana correspondiente

              return Column(
                children: [
                  producto(),
                  descripcion(),
                  tiendas(),
                  fecha(),
                  precio(),
                  actualizarPrecio(),
                  agregarPrecio()
                ],
              );
            }
          }
        });
  }

  Widget producto3() {
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

              contextAlert = context;
              final document = snapshot.data;
              Map<String, dynamic> data =
                  document!.data() as Map<String, dynamic>;

              _itemsTienda = List.from(data["Tienda"]);
              _itemsTienda.add("Agregar Tienda");

              /*print("items " + _itemsTienda[indexSelectTienda]);
              print("select " + _itemsTienda[indexSelectTienda]);
              print("index selecionado " + indexSelectTienda.toString());*/
              _selectItemTienda = _itemsTienda[indexSelectTienda];

              //_selectItemTienda = "ccc";

              _itemsFecha = List.from(data["Fecha_$_selectItemTienda"]);
              _selectItemFecha = _itemsFecha[indexSelectFecha];

              _itemsPrecio = List.from(data["Precios_$_selectItemTienda"]);
              _selectItemPrecio = _itemsPrecio[0].toString();

              //adtualizo los datos  aa los controladores de los textfield
              controllerProducto.text = data['Producto'];
              controllerDescripcion.text = data['Descripcion'];
              controllerPrecio.text = _selectItemPrecio;
//deberia pasar como parametro cada lista o valor y dentro de la funcion se debera hacer toda la logica
//para mostar los datos  en los que usan list se debera mostar el ultimo valor de array  y se debera
//tener la capcidad de cambiar y mostar el valor correspondiente segun el item selecionado
//ademas se debe programar el boton de actualizar.

// corregir lo del lector qr para que redirija hacia  la ventana correspondiente

              return Column(
                children: [
                  producto(),
                  descripcion(),
                  tiendas(),
                  fecha(),
                  precio(),
                  actualizarPrecio(),
                  agregarPrecio()
                ],
              );
            }
          }
        });
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

              contextAlert = context;
              final document = snapshot.data;
              Map<String, dynamic> data =
                  document!.data() as Map<String, dynamic>;

              _itemsTienda = List.from(data["Tienda"]);
              _itemsTienda.add("Agregar Tienda");
              _selectItemTienda = _itemsTienda[indexSelectTienda];

              print("Fecha_$_selectItemTienda");

              if (_itemsTienda.length - 1 != indexSelectTienda) {
                indexSelectTienda = indexSelectTienda;
                
                _itemsFecha = List.from(data["Fecha_$_selectItemTienda"]);
                _selectItemFecha = _itemsFecha[indexSelectFecha];

                _itemsPrecio = List.from(data["Precios_$_selectItemTienda"]);
                _selectItemPrecio = _itemsPrecio[indexSelectFecha].toString();
                controllerPrecio.text=_selectItemPrecio;
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
                  fecha(),
                   precio(),
                  actualizarPrecio(),
                  agregarPrecio()
                ],
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
    //validar que cuando se selecione un item se muestre el item selecionado con toda la informacion en los campos
    //correspondientes

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
                    indexSelectFecha = _itemsFecha.indexWhere(
                        (elemento) => elemento == _selectItemFecha);
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
 Widget agregarPrecio(){

  return ElevatedButton(onPressed: (){alertPrecio();}, child: Text("Agregar Precio"));
 }
 alertPrecio(){
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
    return ElevatedButton(onPressed: () {}, child: Text("Actualizar precio"));
  }

  addTienda() {
    controllerNuevaTienda.text =
        controllerNuevaTienda.text.replaceAll(' ', ''); //quito los espacios
    addDate().addTienda(controllerNuevaTienda.text, controllerNuevoPrecio.text).then((value) {

      Fluttertoast.showToast(
              msg: value,
              backgroundColor: Colors.green,
            );
    });
  }

addPrecio(){
controllerNuevoPrecio.text =
        controllerNuevoPrecio.text.replaceAll(' ', ''); 
  addDate().agregarPrecio( "$_selectItemTienda" , controllerNuevoPrecio.text ).then((value) {
Fluttertoast.showToast(
              msg: value,
              backgroundColor: Colors.green,
            );

  });
  /**/
}
}
