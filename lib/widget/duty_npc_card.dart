// ignore_for_file: camel_case_types, must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ia03_05_llista/pages/duty_npc_information_page.dart';
import 'package:ia03_05_llista/models/duty_npc_model.dart';

class DutyNpcCard extends StatelessWidget {
  const DutyNpcCard({
    super.key,
    required this.npcs,
    required this.index,
  });

  final List<NPC> npcs;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          AudioPlayer().play(AssetSource('sfx/FFXIV_Open_Window.mp3'));
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (BuildContext context, _, __) {
            return NPCInformationPage(npc: npcs[index]);
          }, transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
        },
        child: SizedBox(
          width: 300,
          height: 90,
          child: Stack(
            children: [
              DutyNpcCardBg(category: npcs[index].class_category),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.network('${npcs[index].avatar}?raw=true'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          npcs[index].class_avatar,
                          width: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(npcs[index].class_name.toUpperCase(),
                              style: GoogleFonts.playfairDisplay(
                                textStyle: TextStyle(
                                    fontSize: 22,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.yellow,
                                          blurRadius: 4.0),
                                      Shadow(
                                          color: Colors.yellow,
                                          blurRadius: 4.0),
                                      Shadow(
                                          color: Colors.yellow,
                                          blurRadius: 4.0),
                                    ],
                                    color: Colors.yellow.shade100,
                                    letterSpacing: 0.5),
                                //smcp as in small caps
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          npcs[index].rating.toString(),
                          style: GoogleFonts.michroma(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                                color: Colors.white54,
                                letterSpacing: 0.5),
                            //smcp as
                          ),
                        ),
                      ),
                    ),
                    Text(
                      npcs[index].name.toUpperCase(),
                      style: GoogleFonts.michroma(
                        textStyle: TextStyle(
                            fontSize: 18,
                            shadows: [
                              const Shadow(
                                  color: Colors.yellow, blurRadius: 4.0),
                              const Shadow(
                                  color: Colors.yellow, blurRadius: 4.0),
                              Shadow(
                                  color: Colors.yellow.shade800,
                                  blurRadius: 4.0),
                              const Shadow(
                                  color: Colors.black, blurRadius: 10.0),
                            ],
                            color: Colors.yellow.shade100,
                            letterSpacing: 0.5),
                        //smcp as
                      ),
                    )
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

class DutyNpcCardBg extends StatelessWidget {
  DutyNpcCardBg({
    super.key,
    required this.category,
  });

  final String category;
  List<Color> gradientColors = [];

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case 'dps':
        gradientColors = [
          const Color(0xFF260d11),
          const Color(0xFF5f242a),
          const Color(0xFF572026)
        ];
        break;
      case 'tank':
        gradientColors = [
          const Color(0xFF11152e),
          const Color(0xFF2e3d80),
          const Color(0xFF293774)
        ];
        break;
      case 'healer':
        gradientColors = [
          const Color(0xFF0e220a),
          const Color(0xFF265a1c),
          const Color(0xFF245118)
        ];
        break;
      case 'allrounder':
        gradientColors = [
          const Color.fromARGB(255, 38, 24, 13),
          const Color.fromARGB(255, 95, 77, 36),
          const Color.fromARGB(255, 87, 71, 32)
        ];
        break;
      default:
        gradientColors = [Colors.red, Colors.blue];
        break;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      )),
      child: Row(
        children: [
          Center(
            child: Image.asset('assets/UI/role/role_$category.png'),
          ),
        ],
      ),
    );
  }
}
