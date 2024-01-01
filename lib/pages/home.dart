import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("To-Do's",
        style: GoogleFonts.getFont('Roboto',
          textStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500),

        ),
      )
        ,backgroundColor: Color(0xFF6D852B),
        elevation: 4.0,
        titleSpacing: 35.0,
      ),
      resizeToAvoidBottomInset: false,

      body:TODOLIST(),
    );
  }
}



class Todo {
  String text;
  bool isCompleted;

  Todo({
    required this.text,
    this.isCompleted = false,
  });
}



class TODOLIST extends StatefulWidget {
  const TODOLIST({super.key});

  @override
  State<TODOLIST> createState() => _TODOLISTState();
}


class _TODOLISTState extends State<TODOLIST> {



  void editTodo(Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo',
            style:TextStyle(
              fontSize: 15.0,
            ),),
          content: TextField(
            controller: TextEditingController(text: todo.text),
            autofocus: true,
            onSubmitted: (String value) {
              setState(() {
                if(value!=""){
                  todo.text = value;
                }
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }


  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      title: Text(todo.text,
        style: GoogleFonts.getFont('Montserrat',
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.w500),
                decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                decorationThickness: 2.0,
                decorationColor: Colors.white,
        ),
      ),


      leading: Checkbox(
        value: todo.isCompleted,
        activeColor: Colors.green,
        onChanged: (value) => toggleTodo(todo),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        color: Colors.blueGrey,
        onPressed: () => deleteTodo(todo),
      ),
      onLongPress: (){
        editTodo(todo);
      },
    );
  }

  List<Todo> todos = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = (prefs.getStringList('todos') ?? []).map((task) {
        // print("n\n\n\n\n\n\n\n\t\t\t "+task+" \t\t\t \n\n\n\n\n\n");
        List<String> parts = task.split('::');
        return Todo(text: parts[0], isCompleted: parts[1] == 'true');
      }).toList();
    });
  }


  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'todos',
      todos.map((todo) => '${todo.text}::${todo.isCompleted}').toList(),
    );
  }



  void _addTodo(String todoText) {
    setState(() {
      if(todoText!="") {
        todos.add(Todo(text: todoText, isCompleted: false));
        saveTodos();
        _loadTodoList();
      }
    });
  }


  void toggleTodo(Todo todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
      saveTodos();
    });
  }

  void deleteTodo(Todo todo) {
    setState(() {
      todos.remove(todo);
      saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top:13.0,right: 8.0,left: 8.0,bottom: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color:Color(0xFFD2DAB4),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                boxShadow: [
                  BoxShadow(
                    color:Color(0xFFA2A2A2),
                    offset: Offset(1,1),
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: Color(0xFFA2A2A2),
                    offset: Offset(-1, -1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return _buildTodoItem(todos[index]);
                      },
                    ),
                      height: 650.0,),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFffffff),

          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add To Do'),
                  content: TextField(
                    autofocus: true,
                    onSubmitted: (String value) {
                      _addTodo(value);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
          tooltip: "made by Bharadwaj Reddy",
          child: Icon(Icons.add,
            color: Colors.black,),
        ),

      ),
    );
  }
}
