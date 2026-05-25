import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:frontend/view/home_page.dart';
import 'package:frontend/view/registration.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/widgets/action_card.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:frontend/widgets/rounded_text_field.dart';
import 'package:frontend/widgets/two_fa_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final double textFieldWidth = 0.27;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginPageViewModel>();

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
                          hintText: "email",
                          labelText: "Email",
                          height: MediaQuery.of(context).size.height * 0.1,
                          width:
                              MediaQuery.of(context).size.width *
                              textFieldWidth,
                          textController: emailController,
                          obscure: false,
                        ),
                      ),

                      RoundedTextField(
                        hintText: "password",
                        labelText: "Password",
                        height: MediaQuery.of(context).size.height * 0.1,
                        width:
                            MediaQuery.of(context).size.width * textFieldWidth,
                        textController: passwordController,
                        obscure: true,
                      ),

                      Text(
                        viewModel.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),

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
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (_) =>
                                              RegistrationViewModel(),
                                          child: const RegistrationPage(),
                                        ),
                                  ),
                                );
                              },
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
                          onPressed: () async {
                            // 1. Trigger the backend to verify credentials and send the 2FA email
                            await viewModel.updateText(
                              emailController.text,
                              passwordController.text,
                            );

                            // 2. Check if the backend response set the 'awaitingTwoFa' flag to true
                            if (viewModel.awaiting2Fa && mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                        value:
                                            viewModel, // Pass the existing viewModel to the next page
                                        child: TwoFaPage(
                                          email: emailController.text,
                                        ),
                                      ),
                                ),
                              );
                            }
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
                          child: const Text("Submit"),
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
