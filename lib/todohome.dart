import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key, required this.title});

  final String title;

  @override
  State<ToDoHome> createState() => ToDoHomeState();
}

class ToDoHomeState extends State<ToDoHome> {
  final TextEditingController _toDoController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'log out ψ',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            _buildToDoForm(),
            Expanded(
              child: _buildToDoList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToDoForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _toDoController,
              decoration: const InputDecoration(
                hintText: 'what do you need to do?',
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black38),
            onPressed: _addToDo,
          ),
        ],
      ),
    );
  }

  void _addToDo() async {
    if (_toDoController.text.isNotEmpty) {
      try {
        await todos.add({
          'uid': user!.uid,
          'task': _toDoController.text,
          'completed': false,
          'timestamp': Timestamp.now(),
        });
        _toDoController.clear();
      } catch (e) {
        print('Failed to add to-do: $e');
      }
    }
  }

  Widget _buildToDoList() {
    return StreamBuilder<QuerySnapshot>(
      stream: todos.where('uid', isEqualTo: user!.uid).orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No to-do items yet.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            bool completed = data['completed'] ?? false;  // Handle null case
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      data['task'],
                      style: TextStyle(
                        decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: completed,
                    onChanged: (bool? value) {
                      if (value != null) {
                        _updateToDoStatus(document.id, value);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black38),
                    onPressed: () {
                      _deleteToDoItem(document.id);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _updateToDoStatus(String documentId, bool newStatus) async {
    try {
      await todos.doc(documentId).update({
        'completed': newStatus,
      });
    } catch (e) {
      print('Failed to update to-do status: $e');
    }
  }

  void _deleteToDoItem(String documentId) async {
    try {
      await todos.doc(documentId).delete();
    } catch (e) {
      print('Failed to delete to-do: $e');
    }
  }
}


