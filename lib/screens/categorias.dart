import 'package:flutter/material.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precios/screens/ingresar_producto.dart';

class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  var date = addDate();
  var lista = [];
  var db = FirebaseFirestore.instance;

  ScrollController _controller = ScrollController();
  TextEditingController _controllerTxtField = TextEditingController();

  String? selectedOption;

  void initState() {
    lista = date.listaCategorias;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: listaCategorias()),
      SizedBox(
        height: 15.0,
      ),
      _dialogo(),
      SizedBox(
        height: 15.0,
      )
    ]);
  }

  Widget listaCategorias() {
    return StreamBuilder<QuerySnapshot>(
      stream: date.consultaCategorias().snapshots(),
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
              hoverColor: Color.fromARGB(255, 23, 158, 203),
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
    date.categoria = categoria;
    GoProductos();
  }

  Widget _dialogo() {
    //donde se agrega una nueva categoria
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
                      borderSide: BorderSide(color: Colors.blue, width: 2),
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

  GoProductos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LectorProductos()),
    );
  }
}
