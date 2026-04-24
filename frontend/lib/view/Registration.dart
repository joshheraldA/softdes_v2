import 'dart:ui';

import 'package:frontend/viewmodel/RegistrationViewModel.dart';
import 'package:frontend/widgets/RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedTextField.dart';
import 'package:frontend/widgets/actionCard.dart';

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
                      image: AssetImage("assets/JHYA_LP_image1.png"),
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
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.12,
              top: MediaQuery.of(context).size.height * 0.1,
              child: ActionCard(
                width: MediaQuery.of(context).size.width * 0.34,
                height: MediaQuery.of(context).size.height * 0.75,
                bgColor: const Color.fromARGB(255, 255, 255, 255),
                content: Padding(
                  padding: const EdgeInsets.only(top: 105),
                  child: Column(
                    children: [
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

                      Text(
                        viewModel.text,
                        style: TextStyle(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: Colors.red,
                          letterSpacing: 1,
                        ),
                      ),

                      Divider(
                        indent: 60,
                        endIndent: 60,
                        thickness: 2,
                        color: const Color.fromARGB(255, 192, 192, 192),
                      ),

                      RoundedButton(
                        onPressed: () => {
                          viewModel.updateText(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                          ),
                        },
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
