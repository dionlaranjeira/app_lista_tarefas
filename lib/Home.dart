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
  Map<String, dynamic> _tarefaExcluida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }


  _salvarTarefa(){
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = _controllerTarefa.text;
    tarefa["realizada"] = false;
    setState(() {
      _tarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  void _salvarArquivo() async {
    var arquivo = await _getFile();
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


  Widget criarItemLista(context, index){

    final item = _tarefas[index]["titulo"];

    return Dismissible(
        key: Key(item+index.toString()+DateTime.now().microsecondsSinceEpoch.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){

          _tarefaExcluida = _tarefas[index];

          _tarefas.removeAt(index);
          _salvarArquivo();

          final snackbar = SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
              content: Text("Tarefa removida!"),
              action: SnackBarAction(
              label: "Desfazer",
              textColor: Colors.white,
              onPressed: (){

                setState(() {
                  _tarefas.insert(index, _tarefaExcluida);
                });

                _salvarArquivo();
              },
          ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);

        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
        child: CheckboxListTile(
            title: Text(_tarefas[index]["titulo"]),
            value: _tarefas[index]["realizada"],
            onChanged: (valorAlterado){
              setState(() {
                _tarefas[index]["realizada"]= valorAlterado;
              });
              _salvarArquivo();
            }));
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
              itemBuilder: criarItemLista))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context,
              builder: (context){
                return AlertDialog(
                 title: Text("Adicinar tarefa"),
                 content: TextField(
                   decoration: const InputDecoration(
                     labelText: "Digite a tarefa",
                   ),
                   onChanged: null,
                   controller: _controllerTarefa,
                 ),
                  actions: [TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                    TextButton(
                        onPressed: (){
                          _salvarTarefa();
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
