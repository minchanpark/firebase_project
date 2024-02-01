import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage> {
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  String? errorMessage = '';

  Future<void> createUserIDandpassword() async {
    try {
      await Auth().createUserIDandpassword(
          id: _idcontroller.text, password: _passWordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    Get.offAll(() => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
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
            ElevatedButton(
                onPressed: createUserIDandpassword,
                child: const Text('Register')),
          ],
        ),
      ),
    );
    ;
  }
}
