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
  bool dialogoNuevoProducto = false;
  ValueNotifier<bool> _miVariableBool = ValueNotifier<bool>(true);

  @override
  void initState() {
    // TODO: implement initState
    estado = "sin consultar";
    dialogoNuevoProducto = false;
    _miVariableBool = ValueNotifier<bool>(false);
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
            infoConsulta(estado),
            AlertAddProducto(),
          ],
        ),
      ),
    );
  }

  Widget AlertAddProducto() {
//encaso de no haber encontrado se mostrara un alertdialog que nos preguntara si queremos registrar un nuevo producto
    return ValueListenableBuilder<bool>(
        valueListenable: _miVariableBool,
        builder: (context, value, child) {
          if (!value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //consultar que hace esta linea de codigo
              alert(context);
            });
          }
          return Text(" ");
        });
  }

  alert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Título del diálogo'),
          content: Text('Contenido del diálogo'),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                // Cerrar el diálogo
                //Navigator.of(context).pop();
                // dialogoNuevoProducto=false;
              },
            ),
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                // dialogoNuevoProducto=false;

                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  btnAddManual() {
    //ingresa el  barcode de forma manual para poder consultar un producto abre un alertdialog para ingresar los datos
   ButtonStyle styleButton=ButtonStyle( padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
    ),);
    return Container(padding: EdgeInsets.all(15),child: ElevatedButton(
      style: styleButton,
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

                    addDate()
                        .checkCollectionExistence(_controllerTxtField.text)
                        .then((value) {
                      setState(() {
                        if(value){
                           estado = "El producto "+ _controllerTxtField.text +  " esta registrado";
                        }
                        else{
                              estado = "El producto " +_controllerTxtField.text  + " No esta registrado";
                        }
                       
                        dialogoNuevoProducto = value;
                        _miVariableBool.value = value;
                      });
                    });
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
        child: Text("Ingresar barcode manual")),);
    
  }

  Widget infoConsulta(String res) {
    //retorna un text que nos informara el estado de la consulta si encontro o no el producto
    TextStyle styleAlertDialog = TextStyle(color: Colors.cyan, fontSize: 20);
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          res,
          style: styleAlertDialog,
          textAlign: TextAlign.center,
        ));
  }

  Widget lectorQr() {
     ButtonStyle styleButton=ButtonStyle( padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    ),);

   return Container(  padding: EdgeInsets.all(15.0),child:


    ElevatedButton(
      style:styleButton ,
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
    )
);
    
  }

  GoProductos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Productos()),
    );
  }
}
