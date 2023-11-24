import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final fireauth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  void regUser() async {
    try {
      fireauth
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then((value) {});
    } on Exception catch (e) {
      if (kDebugMode) {
        print("reg exception: $e");
      }
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
                regUser();
              },
              child: const Text("Register"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
              child: const Text("Go to Login"),
            )
          ],
        ),
      ),
    );
  }
}
