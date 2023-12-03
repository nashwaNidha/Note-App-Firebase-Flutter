import 'package:email_validator/email_validator.dart';

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
  final _formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
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
              Form(
                key: _formKey,
                child: Padding(
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
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //   builder: (context) => NewPassword(),
                      // ));
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(color: Colors.black87)),
                  )),
              ElevatedButton(
                onPressed: () {
                  loginFn();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                },
                child: const Text("Login"),
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
    );
  }
}
