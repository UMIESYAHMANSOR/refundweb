import 'package:flutter/material.dart';
import 'package:refund/component/button.dart';
import 'package:refund/component/textfield.dart';
import 'package:refund/views/screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Website',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/logo.png'),
              ),
              CurvedGradientTextField(
                width: 500,
                height: 50,
                hintText: 'Email',
                controller: _email,
              ),
              SizedBox(height: 20),
              CurvedGradientTextField(
                width: 500,
                height: 50,
                hintText: 'Password',
                controller: _pass,
              ),
              SizedBox(height: 20),
              CurvedGradientButton(
                width: 500,
                height: 50,
                onTap: () {
                  if (_email.text == 'admin@gmail.com' && _pass.text == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  } else {
                    //  Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Home()),);
                    _showErrorDialog('Invalid email or password');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
