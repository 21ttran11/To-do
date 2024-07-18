import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'userlogin.dart';
import 'makeaccount.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'to do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFfaf0d4),
      ),
      home: const MyHomePage(title: '(￣□￣」)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/devil_logo.png'),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserLogin(title: 'signin')),
                );
              },
              child: Image.asset(
                'assets/sign_in.png',
                width: 300,
                height: 90,
              ),
            ),
            GestureDetector(
              onTap:(){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MakeAccount(title: 'makeaccount')),
                );
              },
              child: Image.asset(
                'assets/make_account.png',
              width: 300,
              height: 90,
            ),
            ),
            const Text(
                'ψ(▼へ▼メ)',
                style: TextStyle(
                  color: Colors.black38,
                ),
            ),
          ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
