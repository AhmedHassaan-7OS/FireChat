// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase2/tools/textformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
   bool Showspinner = false;
  Future<void> _sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> _checkEmailVerified(User user) async {
    await user.reload();
    if (user.emailVerified) {
      Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email Verification'),
          content: Text('Please verify your email to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Showspinner == true ? Center(child: CircularProgressIndicator(),) : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 15, 56),
              Colors.blueAccent,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(70)),
                    child: Image.asset(
                      'Images/Untitled.png',
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(height: 20,),
                Text('Signup', style: TextStyle(fontSize: 35),),
                Container(height: 20,),
                Text('Username', style: TextStyle(fontSize: 25),),
                Container(height: 10,),
                CustomTextForm(
                    hinttext: "Enter Your Username", mycontroller: username),
                Container(height: 10,),
                Text('Email', style: TextStyle(fontSize: 25),),
                Container(height: 10,),
                CustomTextForm1(
                    hinttext: "Enter Your Email", mycontroller: email),
                Container(height: 10,),
                Text('Password', style: TextStyle(fontSize: 25),),
                Container(height: 10,),
                CustomTextForm2(
                    hinttext: "Enter Password", mycontroller: password),
                Container(height: 20,),
                MaterialButton(
                  onPressed: () async {
                    Showspinner = true;
                    setState(() {
                      
                    });
                    if (email.text.isEmpty || password.text.isEmpty) {
                      print('Email and password must not be empty.');
                      return;
                    }
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      await _sendEmailVerification(credential.user!);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Verification Email Sent'),
                          content: Text('Please check your email to verify your account.'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await _checkEmailVerified(credential.user!);
                                Navigator.of(context).pop();
                              },
                              child: Text('I have verified'),
                            ),
                          ],
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  color: Colors.blueGrey,
                  minWidth: 500,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: Text('Signup', style: TextStyle(color: Colors.white),),
                ),
                Container(height: 20),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Have An Account? ",
                        ),
                        TextSpan(
                            text: "Login",
                            style: TextStyle(
                                color: Colors.orange, fontWeight: FontWeight.bold)),
                      ])),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
