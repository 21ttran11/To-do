import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'todohome.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key, required this.title});

  final String title;

  @override
  State<UserLogin> createState() => UserLoginState();
}

class UserLoginState extends State<UserLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        print("Successful sign in!");
        // Navigate to your home page or perform any other actions upon successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ToDoHome(title: 'ToDo Home')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password provided for that user.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in: ${e.message}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in')));
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '	.･ﾟﾟ･sign in below･ﾟﾟ･.',
              style: TextStyle(fontSize: 18, color: Colors.black38)
            ),
            Container(
              width: 300,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/input_box.png'),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 18), // Add const here
                    decoration: const InputDecoration(
                      labelText: 'email',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black38), // Add const here
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0), // Add const here
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/input_box.png'),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 18),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'password',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black38), // Add const here
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0), // Add const here
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: signInWithEmailAndPassword,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/submit.png',
                    width: 300,
                    height: 100,
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
                  );
                },
                child: const Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Text(
                        'ψ dont have an account?',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                        ),
                      ),
                    ]
                )
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
