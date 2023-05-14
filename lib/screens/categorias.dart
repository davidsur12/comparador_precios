import 'package:flutter/material.dart';
import 'package:precios/firestore/addDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  var date=addDate();
  var lista=[];
  var db = FirebaseFirestore.instance;

  

 
void initState() {
  lista=date.listaCategorias;
}

final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [   Expanded(child: Container(
        width: 200,
        color:Color.fromRGBO(124, 77, 255, 1),
        child: date.leerdatos(_controller)) ), 
        ElevatedButton(onPressed: (){date.addCategoria();}, child: Text("Agregar datos")),
         dialogo()], );
    
  }
Widget lista2(){

   final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

  return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: entries.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber[colorCodes[index]],
        child: Center(child: Text('Entry ${entries[index]}')),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
 
 
  Widget lista3(){

    return  ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount:lista.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
       // color: Colors.amber[colorCodes[index]],
        child: Center(child: Text( lista[index])),
      );
    }
  );

  }
  Widget dialogo(){

    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Agreagar categoria'),
          content: SizedBox(width: 200, height: 100,
            child:Column(children:[Text("Nombre de la categoria") ,
           TextField(textAlign: TextAlign.center,),
           ElevatedButton(onPressed: (){}, child: Text("Agregar categoria"))])),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
  
}