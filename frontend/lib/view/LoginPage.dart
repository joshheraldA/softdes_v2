import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedButton.dart';
import 'package:frontend/widgets/RoundedTextField.dart';
import 'package:frontend/widgets/actionCard.dart';

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

            Center(
              child: ActionCard(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.60,
                bgColor: const Color.fromARGB(255, 255, 255, 255),
                content: Text("WASSUP"),
                borderRadiusVal: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
