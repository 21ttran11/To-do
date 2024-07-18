import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class MakeAccount extends StatefulWidget {
  const MakeAccount({super.key, required this.title});

  final String title;

  @override
  State<MakeAccount> createState() => MakeAccountState();
}

class MakeAccountState extends State<MakeAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _createAccount() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created successfully')));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create account: ${e.message}')));
        print(e.toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create account')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '	.･ﾟﾟ･make account below･ﾟﾟ･.',
              style: TextStyle(fontSize: 18, color: Colors.black38),
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
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'email',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
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
                    obscureText: true, // Obscure password input
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'password',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
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
                    controller: _confirmPasswordController,
                    obscureText: true, // Obscure password input
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'confirm password',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _createAccount,
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
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
                );
              },
              child: const Text(
                'ψ already have an account?',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
