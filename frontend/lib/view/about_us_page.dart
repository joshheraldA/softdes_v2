import 'package:flutter/material.dart';
import 'package:frontend/widgets/RoundedButton.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    image: AssetImage("mottoSection.jpg"),
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
                            "Love in action is service to the world",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "- Mother Teresa",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
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
                            image: AssetImage('ourVision.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Our Vision",
                            style: TextStyle(
                              fontSize: 65,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(color: Color(0xFFd3d3d3)),
                          SizedBox(height: 16),
                          Text(
                            "To be the key player in promoting the spirit of active volunteerism through digital convenience",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                            textAlign: TextAlign.center,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Our Mission",
                            style: TextStyle(
                              fontSize: 65,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(color: Color(0xFFd3d3d3)),
                          SizedBox(height: 16),
                          Text(
                            "To provide our users with the information they need to better actively participate in acts of service to others",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('ourMission.jpg'),
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
                                image: AssetImage('featureIcon1.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Keep track of your acquired CES points and see how much you need to graduate",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
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
                                image: AssetImage('featureIcon2.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Stay connected and aware of any ongoing and upcoming CES activities by browsing the events list",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
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
                                image: AssetImage('featureIcon3.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            width: 300,
                            child: Text(
                              "Allow the calendar to show you when a CES activity requires your participation and stay notified",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 950,
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "ABOUT US",
                        style: TextStyle(
                          fontSize: 60,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),

                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 750,
                      child: Text(
                        "Josh's Doctor Playhouse is a software development company that strives to design clear, secure, and scaleable solutions through enhanced communication. We take pride in our ability to connect with our clients in order to wholly understand their problems and what solutions they need. ",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
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
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
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
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Create an account with your USC email.",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
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
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Email: ouremail@email.com",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "#: 0991 991 9911",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                          SizedBox(height: 35),
                          Container(
                            height: 61,
                            width: 61,

                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('facebookIcon.png'),
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
                                image: AssetImage('instagramIcon.png'),
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
                                image: AssetImage('xIcon.png'),
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
                            image: AssetImage('location.png'),
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
