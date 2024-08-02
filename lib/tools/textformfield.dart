import 'package:flutter/material.dart';

class CustomTextForm1 extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;

  const CustomTextForm1(
      {super.key, required this.hinttext, required this.mycontroller});

  @override
  Widget build(BuildContext context) {
    return TextFormField( keyboardType: TextInputType.emailAddress,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    );
  }
}
class CustomTextForm2 extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;

  const CustomTextForm2(
      {super.key, required this.hinttext, required this.mycontroller});

  @override
  Widget build(BuildContext context) {
    return TextFormField( keyboardType: TextInputType.visiblePassword,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    );
  }
}
class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;

  const CustomTextForm(
      {super.key, required this.hinttext, required this.mycontroller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    );
  }
}