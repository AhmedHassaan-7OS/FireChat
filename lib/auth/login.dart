// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase2/tools/textformfield.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
  }
bool Showspinner = false;
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
                Text('Login',style: TextStyle(fontSize: 35),),
                Container(height: 20,),
                Text('Email',style: TextStyle(fontSize: 25),),
                Container(height: 10,),
                CustomTextForm1(
                  hinttext: "Enter Your Email", mycontroller: email),
                Container(height: 20,),
                Text('Password',style: TextStyle(fontSize: 25),),
                Container(height: 10,),
                CustomTextForm2(
                  hinttext: "Enter Password", mycontroller: password),
                Container(height: 7.5,),
                Container(alignment: Alignment.topRight, child: TextButton(onPressed: ()async{
                  email.text.isEmpty ? showDialog(context: context, builder: (context)=>AlertDialog(
            content: const Text('You Must enter an Email'),
            actions: [MaterialButton(onPressed: (){Navigator.of(context).pop();},
            child: const Text('OK'),
            ),],
                  )) :
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                  AlertDialog(content: Text('reset pass email has been send'),);
                }, child: Text('Forget Password?',style: TextStyle(color: Colors.white),))),
                Container(height: 20,),
               MaterialButton(
  onPressed: () async {
    if (email.text.isEmpty || password.text.isEmpty) {
      // Use ScaffoldMessenger to show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password must not be empty.')),
      );
      return;
    }

    try {
      Showspinner = true;
      setState(() {});
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Showspinner = false;
      setState(() {});
      Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')),
        );
         Showspinner = false;
      setState(() {});

      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided for that user.')),
        );
         Showspinner = false;
      setState(() {});

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${e.message}')),
        );
         Showspinner = false;
      setState(() {});

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
       Showspinner = false;
      setState(() {});

    }
  },
  color: Colors.blueGrey,
  minWidth: 500,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  child: Text('Login', style: TextStyle(color: Colors.white)),
),

                Container(height: 7.5,),
                Container(alignment: Alignment.center, child: Text('Or Login With', style: TextStyle(fontSize: 17, color: Colors.white))),
                Container(height: 15,),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(width: 0,),
                      MaterialButton(
                        onPressed: () async {
                          try {
                            await signInWithGoogle();
                            Navigator.of(context).pushReplacementNamed('homepage');
                          } catch (e) {
                            print('Google sign-in failed: $e');
                          }
                        },
                        child: Image.asset('Images/Google.png'),
                      ),
                      Container(width: 25,),
                      MaterialButton(onPressed: () {}, child: Image.asset('Images/Apple.png')),
                      Container(width: 25,),
                      MaterialButton(onPressed: () {}, child: Image.asset('Images/Facebook.png')),
                    ],
                  ),
                ),
                Container(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("signup");
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "Don't Have An Account? ",
                      ),
                      TextSpan(
                          text: "Register",
                          style: TextStyle(
                              color: Colors.orange, fontWeight: FontWeight.bold)),
                    ])),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
