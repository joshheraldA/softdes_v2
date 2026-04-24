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

          // padding: EdgeInsets.only(left: 80, right: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero Banner ──────────────────────────────────────────
              Container(
                height: 300,
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
                            style: TextStyle(color: Colors.white, fontSize: 60),
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
                padding: EdgeInsets.only(
                  left: 50,
                  right: 80,
                  top: 50,
                  bottom: 50,
                ),
                color: Color(0xFFEBEBEB),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('testimg1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Our Vision", style: TextStyle(fontSize: 60)),
                          SizedBox(height: 16),
                          Divider(color: Color(0xFFd3d3d3)),
                          SizedBox(height: 16),
                          Text(
                            "Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Our Mission ──────────────────────────────────────────
              Container(
                height: 595,
                color: Color(0xFFf3f3f3),

                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 50,
                  left: 80,
                  right: 50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Our Mission", style: TextStyle(fontSize: 60)),
                          SizedBox(height: 16),
                          Divider(color: Color(0xFFd3d3d3)),
                          SizedBox(height: 16),
                          Text(
                            "Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                      child: Container(
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
                padding: EdgeInsets.all(50),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── About Us Blurb ───────────────────────────────────────
              Container(
                height: 595,
                color: Color(0xFFEBEBEB),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 950,
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "ABOUT US",
                        style: TextStyle(fontSize: 60),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 750,
                      child: Text(
                        "Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Login / Register CTA ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 595,
                      color: Color(0xFFe2e0e1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 40),
                          ),
                          SizedBox(height: 40),
                          RoundedButton(
                            length: 210,
                            width: 50,
                            backGroundColor: Color(0xFFe8c89a),
                            onPressed: () {},
                            child: Text("Login"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 595,
                      color: Color(0xFFf5f5f5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "let's get you started!",
                            style: TextStyle(fontSize: 35),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Create an account with your USC email.",
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                          RoundedButton(
                            length: 210,
                            width: 50,
                            backGroundColor: Color(0xFFe8c89a),
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
                          Text(
                            "Josh's Doctor Playhouse",
                            style: TextStyle(fontSize: 45),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Email: ouremail@email.com",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "#: 0991 991 9911",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 35),
                          Container(
                            height: 61,
                            width: 61,

                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('testimg1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: RoundedButton(
                              onPressed: () {},
                              backGroundColor: Colors.white.withAlpha(0),
                              child: Text(""),
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
                            child: RoundedButton(
                              onPressed: () {},
                              backGroundColor: Colors.white.withAlpha(0),
                              child: Text(""),
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
                            child: RoundedButton(
                              onPressed: () {},
                              backGroundColor: Colors.white.withAlpha(0),
                              child: Text(""),
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
