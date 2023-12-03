import 'package:email_validator/email_validator.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Email"),
                    controller: email,
                    validator: (value) {
                      final bool isValid =
                          EmailValidator.validate(value.toString());
                      return isValid ? null : "Enter a valid Email";
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(hintText: "enter the password"),
                    controller: pass,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      // Perform custom password validation here
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return "Password must contain at least one uppercase letter";
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return "Password must contain at least one lowercase letter";
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return "Password must contain at least one numeric character";
                      }
                      if (!value.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                        return "Password must contain at least one special character";
                      }

                      return null; // Password is valid
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  regUser();
                },
                child: const Text("SIGN UP"),
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
      ),
    );
  }
}
