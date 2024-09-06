import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:fb_noteapp/presentation/view/notes/homepage.dart';
import 'package:fb_noteapp/presentation/view/auth/reg_page.dart';
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
  final _formKey = GlobalKey<FormState>();

  void loginFn() async {
    try {
      fireauth.signInWithEmailAndPassword(
          email: email.text, password: pass.text);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 40),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Password"),
                      controller: pass,
                      obscureText: true,
                      // obscuringCharacter: '*',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //   builder: (context) => NewPassword(),
                      // ));
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(color: Colors.black87)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      loginFn();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 38, 62, 103),
                        foregroundColor: Colors.white,
                        shadowColor: const Color.fromARGB(255, 123, 148, 169),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(100, 40),
                        fixedSize: const Size(400, 50)),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text("Don't have an Account?"),
                    InkWell(
                        onTap: () {
                          _formKey.currentState!.validate();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegScreen(),
                          ));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
