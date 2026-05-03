import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/widgets/indicator.dart';
import 'package:frontend/widgets/action_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                ActionCard(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1, 
                  bgColor: const Color.fromARGB(255, 246, 246, 246),
                  content: ProgBarIndicator(
                    progress: 100, 
                    width: MediaQuery.of(context).size.height * 0.1, 
                    height: MediaQuery.of(context).size.height * 0.1,
                    strokeWidth: 2,
                    offset: 20,
                  ),
                  borderRadiusVal: MediaQuery.of(context).size.height * 0.1, 
                ),    


                SizedBox(width: 45), 
                
                ActionCard(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1, 
                  bgColor: const Color.fromARGB(255, 246, 246, 246),
                  content: ProgBarIndicator(
                    progress: 100, 
                    width: MediaQuery.of(context).size.height * 0.1, 
                    height: MediaQuery.of(context).size.height * 0.1
                  ),
                  borderRadiusVal: MediaQuery.of(context).size.height * 0.1, 
                )        
              ],





              // children: [
              //   Padding(
              //     padding: EdgeInsets.all(8.0),
              // R    child: ActionCard(
              //       width: 110,
              //       height: 110, 
              //       content: Stack(
              //         children: [
              //           ProgBarIndicWidg(progress: 50, width: 110, height: 110)
              //         ],
              //       )
              //     ),
              //   ),
              // ],
            ),
          ],
        ),
      )
    );
  }
}