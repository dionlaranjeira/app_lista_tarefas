import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List _tarefas = [];

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  void _salvarTarefas() async {

    var arquivo = await _getFile();

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Agradecer a Deus";
    tarefa["realizada"] = false;

    _tarefas.add(tarefa);

    String dados = json.encode(_tarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
      try{
        final arquivo = await _getFile();
        return arquivo.readAsString();
      }
      catch(e){
        print("ERRO-->"+ e.toString());
        return null;
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    _lerArquivo().then((dados){
      setState(() {
        _tarefas = json.decode(dados);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // _salvarTarefas();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(_tarefas[index]["titulo"]),
                );
              }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context,
              builder: (context){
                return AlertDialog(
                 title: Text("Adicinar tarefa"),
                 content: const TextField(
                   decoration: InputDecoration(
                     labelText: "Digite a tarefa",
                   ),
                   onChanged: null,
                 ),
                  actions: [TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                    TextButton(
                        onPressed: (){
                          //salvar
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
