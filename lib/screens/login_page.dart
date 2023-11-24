import 'package:fb_noteapp/screens/homepage.dart';
import 'package:fb_noteapp/screens/reg_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fireauth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  void loginFn() async {
    try {
      fireauth.signInWithEmailAndPassword(
          email: email.text, password: pass.text);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Email"),
                  controller: email,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Password"),
                  controller: pass,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginFn();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
              },
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegScreen(),
                ));
              },
              child: const Text("Go to Registration"),
            )
          ],
        ),
      ),
    );
  }
}
