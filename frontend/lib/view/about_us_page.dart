import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedButton.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 1536,
          padding: EdgeInsets.all(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero Banner ──────────────────────────────────────────
              Container(
                height: 595,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("testimg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Lorem Ipsum Dolor Sit Amet",
                            style: TextStyle(color: Colors.white, fontSize: 32),
                          ),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum Dolor Sit Amet"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Our Vision ───────────────────────────────────────────
              Container(
                height: 595,
                padding: EdgeInsets.all(48),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 485,
                        width: 671,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('testimg1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 38),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Our Vision", style: TextStyle(fontSize: 32)),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum dolor sit amet"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Our Mission ──────────────────────────────────────────
              Container(
                height: 595,
                color: Colors.green,
                padding: EdgeInsets.all(48),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Our Mission", style: TextStyle(fontSize: 32)),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum dolor sit amet"),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 485,
                        width: 671,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('testimg1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Team / Feature Cards ─────────────────────────────────
              Container(
                height: 595,
                padding: EdgeInsets.all(48),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum Dolor Sit Amet"),
                        ],
                      ),
                    ),
                    SizedBox(width: 100),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum Dolor Sit Amet"),
                        ],
                      ),
                    ),
                    SizedBox(width: 100),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum Dolor Sit Amet"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── About Us Blurb ───────────────────────────────────────
              Container(
                height: 595,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ABOUT US", style: TextStyle(fontSize: 45)),
                    SizedBox(height: 20),
                    Text("Lorem Ipsum Dolor Sit Amet"),
                  ],
                ),
              ),

              // ── Login / Register CTA ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 595,
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login text", style: TextStyle(fontSize: 35)),
                          SizedBox(height: 16),
                          RoundedButton(onPressed: () {}, child: Text("Login")),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 595,
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Register text", style: TextStyle(fontSize: 35)),
                          SizedBox(height: 16),
                          RoundedButton(
                            length: 100,
                            width: 100,
                            onPressed: () {},
                            child: Text("Register"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 595,
                padding: EdgeInsets.all(48),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Adress", style: TextStyle(fontSize: 32)),
                          SizedBox(height: 16),
                          Text("Lorem Ipsum dolor sit amet"),
                          SizedBox(height: 10),
                          Text("Lorem Ipsum dolor sit amet"),
                          SizedBox(height: 10),
                          Text("Lorem Ipsum dolor sit amet"),
                          SizedBox(height: 30),
                          Container(
                            height: 61,
                            width: 61,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 61,
                            width: 61,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 61,
                            width: 61,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 485,
                        width: 671,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('testimg1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
