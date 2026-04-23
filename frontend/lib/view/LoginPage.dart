import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedButton.dart';
import 'package:frontend/widgets/RoundedTextField.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RoundedButton(onPressed: (){}, child: Text("TestBtn"),),
            RoundedTextField(hintText: "Enter email", labelText: "Email", width: 100,length: 50,),
          ],
        ),
      ),
    );
  }
}