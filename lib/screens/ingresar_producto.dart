import 'package:flutter/material.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precios/screens/productos.dart';

class LectorProductos extends StatefulWidget {
  const LectorProductos({super.key});

  @override
  State<LectorProductos> createState() => _LectorProductosState();
}

class _LectorProductosState extends State<LectorProductos> {
  String estado = "sin consultar";
  TextEditingController _controllerTxtField = TextEditingController();
  bool dialogoNuevoProducto = true;

  @override
  void initState() {
    // TODO: implement initState
    estado = "sin consultar";
    dialogoNuevoProducto = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Precios"),
      ),
      body: Center(
        child: Column(
          children: [
            lectorQr(),
            btnAddManual(),
            Text(estado),
            exi(estado),
            dialogoNuevoProductoView()
          ],
        ),
      ),
    );
  }

  Widget dialogoNuevoProductoView() {
    if (dialogoNuevoProducto) {
      return Text("");
    } else {
      return ElevatedButton(
          child: Text("Agregar  producto"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Producto no encontrado"),
                    content: Text(
                        "El prducto no se encuentra en la base de datos deseas agregarlo"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
/*
    setState(() {
      dialogoNuevoProducto=false;
    });*/
                          },
                          child: Text("No")),
                      ElevatedButton(onPressed: () {}, child: Text("Si"))
                    ],
                  );
                });
          });
    }
  }

  Widget btnAddManual() {
    return ElevatedButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                //side:new  BorderSide(color: Color(0xFF2A8068))
              ),
              title: const Text(
                'Ingresar Barcode',
                textAlign: TextAlign.center,
              ),
              content: Container(
                  width: 200,
                  height: 70,
                  child: Column(children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Ingresa Barcode',
                        suffixIcon: Icon(Icons.keyboard),
                        // contentPadding: EdgeInsets.all(20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2),
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
                    //  addDate().checkCollectionExistence("Productos").then(());
                    addDate()
                        .checkCollectionExistence(_controllerTxtField.text)
                        .then((value) {
                      // result=value.toString();
                      setState(() {
                        estado = value.toString();
                        dialogoNuevoProducto = value;
                      });
                    });
                    // addDate().addCollectioId(addDate().categoria,  _controllerTxtField.text);
                    // print(_controllerTxtField.text);
                    //date.addCategoria(_controllerTxtField.text);
                    //_controllerTxtField.text = "";
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 13.0, right: 13.0),
                    child: Text('Ok'),
                  ),
                ),
              ],
            ),
          );
        },
        child: Text("Ingresar barcode manual"));
  }

  Widget exi(String res) {
/*addDate().checkCollectionExistence("Productos" , addDate().producto).then((value) {
 // result=value.toString();
  setState(() {
    estado=value.toString();
  });
   
}
);*/

/*
Fluttertoast.showToast(
                    msg: estado,
                    backgroundColor: Colors.green,
                  );*/
    return Text(estado);
  }

  Widget lectorQr() {
    return ElevatedButton(
      onPressed: () async {
        var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SimpleBarcodeScannerPage(),
            ));
        setState(() {
          if (res is String) {
            //result = res;
            // print("barcode = $res");
            /*  Fluttertoast.showToast(
              msg: "barcode = $res",
              backgroundColor: Colors.green,
            );*/

            addDate().barcode = res;
            setState(() {
              estado = res;
            });
            FutureBuilder(
              future: addDate().checkCollectionExistence(res),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("producto $res Si esxiste");
                  Fluttertoast.showToast(
                    msg: "Consultando...",
                    backgroundColor: Colors.green,
                  );

                  setState(() {
                    estado = "Consultando...";
                  });
                  return Text("Consultando");
                } else if (snapshot.hasError) {
                  Fluttertoast.showToast(
                    msg: "error al consultar",
                    backgroundColor: Colors.green,
                  );
                  print("error al consultar");
                  setState(() {
                    estado = "error al consultar";
                  });
                  return Text("Error al Consultar");
                } else {
                  //return Text('Datos: ${snapshot.data}');
                  if (snapshot.data!) {
                    Fluttertoast.showToast(
                      msg: "producto $res Si esxiste",
                      backgroundColor: Colors.green,
                    );
                    print("producto $res Si esxiste");
                    setState(() {
                      estado = "producto $res Si esxiste";
                    });
                    return Text("producto $res Si esxiste");
                  } else {
                    Fluttertoast.showToast(
                      msg: "producto $res No esxiste",
                      backgroundColor: Colors.green,
                    );
                    print("producto $res No esxiste");
                    setState(() {
                      estado = "producto $res No esxiste";
                    });
                    return Text("producto $res NO esxiste");
                  }
                }
              },
            );
            // GoProductos();
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
