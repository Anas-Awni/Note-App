import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Views/note_view.dart';
import 'package:myapp/Views/register_view.dart';

import '../Res/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: width * 0.75,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.cyan,
                    radius: 35,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/login.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text for email';
                      }
                      if (value.contains("@") == false) {
                        return 'You Must Add @ Symbol';
                      }
                      // return null if the text is valid
                      return null;
                    }),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.cyan),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gapPadding: 20,
                          borderSide: BorderSide(width: 50)),
                      prefixIcon: Icon(Icons.email),
                      label: Text("Email"),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text for password';
                      }
                      if (value.length < 6) {
                        return 'incorrect';
                      }
                      // return null if the text is valid
                      return null;
                    }),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.cyan),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gapPadding: 20,
                        borderSide: BorderSide(width: 50),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      label: Text("Password"),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 160,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.cyan),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing')));
                              }
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                FirebaseAuth authObject = FirebaseAuth.instance;

                                UserCredential user =
                                    await authObject.signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NoteView()));
                              } on FirebaseAuthException catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(e.message.toString()),
                                      );
                                    });
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(e.toString()),
                                      );
                                    });
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      child: !isLoading
                          ? const Text(
                              "Login",
                            )
                          : const CircularProgressIndicator(
                              color: CustomColors.cardColor,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do not have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const RegisterView();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
