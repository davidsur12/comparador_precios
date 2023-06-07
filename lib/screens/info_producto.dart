import 'package:flutter/material.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

//lista de dropdown
  String _selectItemTienda = "";
  List<String> _itemsTienda = [];

  String _selectItemFecha = "";
  List<String> _itemsFecha = [];

  String _selectItemPrecio = "";
  List<String> _itemsPrecio = [];

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
          child: producto2(),
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
              final document = snapshot.data;
              Map<String, dynamic> data =
                  document!.data() as Map<String, dynamic>;

              _itemsTienda = List.from(data["Tienda"]);
              _itemsTienda.add("Agregar Tienda");
              _selectItemTienda = _itemsTienda[0];

              _itemsFecha = List.from(data["Fecha_$_selectItemTienda"]);
              _selectItemFecha = _itemsFecha[0];

              _itemsPrecio = List.from(data["Precios_$_selectItemTienda"]);
              _selectItemPrecio = _itemsPrecio[0].toString();

              //adtualizo los datos  aa los controladores de los textfield
              controllerProducto.text = data['Producto'];
              controllerDescripcion.text = data['Descripcion'];
              controllerPrecio.text = _selectItemPrecio;

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
    //cuando se presione la ultimaopcion se debera  mostar un cuadro de dialogo para poder aagregar una nueva tienda
    // llenando parametros como Nombre de la tienda , Precio y fecha
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
              // width: 300,
              child: DropdownButton<String>(
                value: _selectItemTienda,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectItemTienda = newValue!;
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

  return ElevatedButton(onPressed: (){}, child: Text("Agregar precio"));
}
Widget actualizarPrecio(){

  return ElevatedButton(onPressed: (){}, child: Text("Actualizar precio"));
}

}
