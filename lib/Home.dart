import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<String> _tarefas = ["Agradecer a Deus", "Se alimentar bem", "Trabalhar", "Estudar", "Cuidar de mim"];

  @override
  Widget build(BuildContext context) {
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
                  title: Text(_tarefas[index]),
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
