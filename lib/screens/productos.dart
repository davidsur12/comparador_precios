import 'package:flutter/material.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  var date = addDate();
  var lista = [];
  var db = FirebaseFirestore.instance;

  ScrollController _controller = ScrollController();
  TextEditingController _controllerTxtField = TextEditingController();

  String? selectedOption;

  void initState() {
    lista = date.listaCategorias;
    // _controller.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                "precios",
                textAlign: TextAlign.center,
              )),
            ),
            body: Column(children: [
              Expanded(child: listaProductos()),
              SizedBox(
                height: 15.0,
              ),
              _dialogo(),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                onPressed: () {
                 
                  date.consultaProductos();
                },
                child: Text("obtener datos "),
              ),
              lectorQr(),
            ])));
  }

  Widget listaProductos() {
    return StreamBuilder(
      stream: date.consultaProductos(),
      builder: (context, snapshot) {
        /* if (snapshot.hasData) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
      
        }*/
        if (snapshot.hasError) {
          return Text('Error al obtener los datos');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return Center(child: Text('Cargando...'));
          return CircularProgressIndicator();
        }
        // Obtiene los datos del documento
        var documentData = snapshot.data!.data();

        Map<String, dynamic> data = documentData as Map<String, dynamic>;

        return Column(
          children: [
            Text("Producto :" + data["Marca"]),
            Text("Marca :" + data["Descripcion"]),
            Text("Descripcion :" + data["precio"]),//este campo debe obtenerse le array precio supermercado el ultimo item
              Text("ID del producto :" + data["precio"]),
              Text("Fecha ultimo precio :" + data["precio"]),//este campo debe llenarse con los diferentes precios de los puermercados
              //tantos campos como  supermercados co su respectiva clasificacion
            ElevatedButton(onPressed: (){}, child: Text("Actualizar datos")),
             ElevatedButton(onPressed: (){}, child: Text("Agregar supermercado")),
              ElevatedButton(onPressed: (){}, child: Text("Actualizar ultimo precio")),
              ElevatedButton(onPressed: (){}, child: Text("Agregar precio"))
          ],
        );
      },
    );
  }

  Widget listaCategorias() {
    return StreamBuilder<QuerySnapshot>(
      stream: date.consultaCategorias().snapshots(),
      //stream: date.consultaProductos().snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          
          return Text('Error al obtener los datos');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Cargando...'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              hoverColor: Colors.lightBlueAccent,
              onTap: () => _onItemTapped(index, snapshot.data!.docs[index].id),
              leading: CircleAvatar(
                backgroundColor: const Color(0xff764abc),
                child: Text(index.toString()),
              ),
              title: Text(
                snapshot.data!.docs[index].id,
                textAlign: TextAlign.center,
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  // your logic
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    PopupMenuItem(
                      child: Text("Editar"),
                      value: '/Editar',
                    ),
                    PopupMenuItem(
                        child: Text("Eliminar"),
                        value: '/Eliminar',
                        onTap: () {
                          date.deleteDocument(snapshot.data!.docs[index].id);
                        }),
                  ];
                },
              ),
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index, String categoria) {
    // Manejar el evento de toque en el elemento de la lista
    print('Elemento tocado: $index = $categoria');
    Fluttertoast.showToast(
      msg: "$categoria",
      backgroundColor: Colors.green,
    );
    GoProductos();
  }

  Widget _dialogo() {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side:new  BorderSide(color: Color(0xFF2A8068))
          ),
          title: const Text(
            'Agreagar categoria',
            textAlign: TextAlign.center,
          ),
          content: Container(
              width: 200,
              height: 70,
              child: Column(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Ingresa una categoria',
                    suffixIcon: Icon(Icons.keyboard),
                    // contentPadding: EdgeInsets.all(20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                  controller: _controllerTxtField,
                  textAlign: TextAlign.center,
                ),
              ])),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Text('Cancel'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                print(_controllerTxtField.text);
                date.addCategoria(_controllerTxtField.text);
                _controllerTxtField.text = "";
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 13.0, right: 13.0),
                child: Text('Ok'),
              ),
            ),
          ],
        ),
      ),
      child: const Padding(
          padding:
              EdgeInsets.only(top: 15.0, right: 30.0, bottom: 15.0, left: 30.0),
          child: Text('Agregar Categoria')),
    );
  }
Widget lectorQr(){

return  ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    //result = res;
                    print("barcode = $res");
                  }
                });
              },
              child: const Text('Open Scanner'),
            );
}
  GoProductos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Productos()),
    );
  }
}
