import 'dart:ui';

import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/rounded_text_field.dart';
import 'package:frontend/widgets/action_card.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final double textFieldWidth = 0.27;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrationViewModel>();

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/login_background2.jpeg"),
                      fit: BoxFit.cover,
                      filterQuality:
                          FilterQuality.high, // Adds better anti-aliasing
                    ),
                  ),
                ),
              ],
            ),

            // blues the background image
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
            ),

            Center(
              child: ActionCard(
                width: MediaQuery.of(context).size.width * 0.34,
                height: MediaQuery.of(context).size.height * 0.75,
                bgColor: const Color.fromARGB(255, 255, 255, 255),
                content: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Text(
                        "CES MANAGEMENT TRACKER",
                        style: TextStyle( 
                          fontFamily: GoogleFonts.inter().fontFamily, 
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(
                        height: 30,
                        width: 30,
                      ),

                      RoundedTextField(
                        hintText: "username",
                        labelText: "Username",
                        height: MediaQuery.of(context).size.height * 0.1,
                        width:
                            MediaQuery.of(context).size.width * textFieldWidth,
                        textController: usernameController,
                      ),

                      RoundedTextField(
                        hintText: "email",
                        labelText: "Email",
                        height: MediaQuery.of(context).size.height * 0.1,
                        width:
                            MediaQuery.of(context).size.width * textFieldWidth,
                        textController: emailController,
                      ),
                      

              

                      RoundedTextField(
                        hintText: "password",
                        labelText: "Password",
                        height: MediaQuery.of(context).size.height * 0.1,
                        width:
                            MediaQuery.of(context).size.width * textFieldWidth,
                        textController: passwordController,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          viewModel.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: Colors.red,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      Divider(
                        indent: 60,
                        endIndent: 60,
                        thickness: 2,
                        color: const Color.fromARGB(255, 192, 192, 192),
                      ),

                      SizedBox(
                        height: 30,
                        width: 30,
                      ),

                      RoundedButton(
                        onPressed: () => {
                          viewModel.updateText(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                          ),
                        },
                        borderVal: 0,
                        height: MediaQuery.of(context).size.height * 0.075,
                        width:
                            MediaQuery.of(context).size.width * textFieldWidth,
                        child: Text("Submit"),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
