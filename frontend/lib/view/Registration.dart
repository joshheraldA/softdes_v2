import 'dart:ui';

import 'package:frontend/viewmodel/RegistrationViewModel.dart';
import 'package:frontend/widgets/RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedTextField.dart';
import 'package:frontend/widgets/actionCard.dart';

import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo.png"),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: RoundedTextField(
                          hintText: "username",
                          labelText: "Username",
                          height: MediaQuery.of(context).size.height * 0.1,
                          width:
                              MediaQuery.of(context).size.width *
                              textFieldWidth,
                          textController: usernameController,
                        ),
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

                      Text(viewModel.text, style: TextStyle(color: Colors.red)),

                      Divider(
                        indent: 60,
                        endIndent: 60,
                        thickness: 2,
                        color: const Color.fromARGB(255, 192, 192, 192),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Pushes items to opposite ends
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    197,
                                    197,
                                    197,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    197,
                                    197,
                                    197,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RoundedButton(
                          onPressed: () => {
                            viewModel.updateText(
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                            ),
                          },
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.06,
                          backGroundColor: const Color.fromARGB(
                            255,
                            104,
                            206,
                            136,
                          ),
                          colors: Colors.white,
                          child: Text("Submit"),
                        ),
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
