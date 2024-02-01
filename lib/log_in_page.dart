import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/authentication/auth.dart';
import 'package:firebase_project/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  Future<void> signInWithEmailAndPassWord() async {
    try {
      await Auth().signInWithEmainAndpassword(
          id: _idcontroller.text, password: _passWordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                controller: _idcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'ID'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _passWordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'PassWord'),
              ),
            ),
            const SizedBox(height: 15),
            Text(errorMessage == '' ? '' : 'Hmm $errorMessage'),
            ElevatedButton(
              onPressed: signInWithEmailAndPassWord,
              child: const Text('Sign-in'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              child: const Text('Go to register'),
            )
          ],
        ),
      ),
    );
  }
}
