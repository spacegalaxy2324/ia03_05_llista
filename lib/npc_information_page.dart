// ignore_for_file: camel_case_types

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ia03_05_llista/main.dart';
import 'package:ia03_05_llista/npc_model.dart';
import 'package:provider/provider.dart';

Widget readableExpansion(String expansion) {
  String fullExpansionName = "";

  switch (expansion) {
    case 'ARR':
      fullExpansionName = "A Realm Reborn";
      break;
    case 'HVW':
      fullExpansionName = "Heavensward";
      break;
    case 'STB':
      fullExpansionName = "Stormblood";
      break;
    case 'SHB':
      fullExpansionName = "Shadowbringer";
      break;
    case 'ENW':
      fullExpansionName = "Endwalker";
      break;
    default:
      break;
  }

  return Row(
    children: [
      Text(
        fullExpansionName.toUpperCase(),
        style: GoogleFonts.playfairDisplay(
          textStyle: TextStyle(
              fontSize: 24,
              shadows: [
                const Shadow(color: Colors.yellow, blurRadius: 4.0),
                const Shadow(color: Colors.yellow, blurRadius: 4.0),
                Shadow(color: Colors.yellow.shade800, blurRadius: 4.0),
                const Shadow(color: Colors.black, blurRadius: 10.0),
              ],
              color: Colors.yellow.shade100,
              letterSpacing: 0.5),
        ),
      ),
      Image.asset(
        'assets/UI/${expansion.toLowerCase()}.png',
        scale: 1.75,
      ),
    ],
  );
}

class NPCInformationPage extends StatefulWidget {
  const NPCInformationPage({super.key, required this.npc});

  final NPC npc;

  @override
  State<NPCInformationPage> createState() => _NPCInformationPageState();
}

class _NPCInformationPageState extends State<NPCInformationPage> {
  final myController = TextEditingController();

  List<Color> gradientColors = [];
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.npc.rating.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ChangedCharacterList>();

    switch (widget.npc.class_category) {
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

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CustomAppBar(),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              widget.npc.class_avatar,
                              width: 50,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                widget.npc.name.toUpperCase(),
                                style: GoogleFonts.michroma(
                                  textStyle: TextStyle(
                                      fontSize: 24,
                                      shadows: [
                                        const Shadow(
                                            color: Colors.yellow,
                                            blurRadius: 4.0),
                                        const Shadow(
                                            color: Colors.yellow,
                                            blurRadius: 4.0),
                                        Shadow(
                                            color: Colors.yellow.shade800,
                                            blurRadius: 4.0),
                                        const Shadow(
                                            color: Colors.black,
                                            blurRadius: 10.0),
                                      ],
                                      color: Colors.yellow.shade100,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.network('${widget.npc.avatar}?raw=true',
                                  scale: 0.75),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Class:',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(widget.npc.class_name.toUpperCase(),
                                    style: GoogleFonts.playfairDisplay(
                                      textStyle: TextStyle(
                                          fontSize: 22,
                                          shadows: [
                                            const Shadow(
                                                color: Colors.yellow,
                                                blurRadius: 4.0),
                                            const Shadow(
                                                color: Colors.yellow,
                                                blurRadius: 4.0),
                                            Shadow(
                                                color: Colors.yellow.shade800,
                                                blurRadius: 4.0),
                                            const Shadow(
                                                color: Colors.black,
                                                blurRadius: 10.0),
                                          ],
                                          color: Colors.yellow.shade100,
                                          letterSpacing: 0.5),
                                      //smcp as in small caps
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Expansion:',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                readableExpansion(widget.npc.expansion),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reputation:',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow.shade100,
                                      shadows: [
                                        const Shadow(
                                            color: Colors.yellow,
                                            blurRadius: 4.0),
                                        const Shadow(
                                            color: Colors.yellow,
                                            blurRadius: 4.0),
                                        Shadow(
                                            color: Colors.yellow.shade800,
                                            blurRadius: 4.0),
                                        const Shadow(
                                            color: Colors.black,
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('${widget.npc.rating} / 10',
                                        style: GoogleFonts.michroma(
                                          textStyle: TextStyle(
                                              fontSize: 22,
                                              shadows: [
                                                const Shadow(
                                                    color: Colors.yellow,
                                                    blurRadius: 4.0),
                                                const Shadow(
                                                    color: Colors.yellow,
                                                    blurRadius: 4.0),
                                                Shadow(
                                                    color:
                                                        Colors.yellow.shade800,
                                                    blurRadius: 4.0),
                                                const Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 10.0),
                                              ],
                                              color: Colors.yellow.shade100,
                                              letterSpacing: 0.5),
                                          //smcp as in small caps
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Slider(
                          activeColor: const Color(0xFFd6b475),
                          value: _currentSliderValue,
                          max: 10,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${_currentSliderValue.toInt().toString()}',
                                  style: GoogleFonts.michroma(
                                    textStyle: TextStyle(
                                        fontSize: 35,
                                        shadows: [
                                          const Shadow(
                                              color: Colors.yellow,
                                              blurRadius: 4.0),
                                          const Shadow(
                                              color: Colors.yellow,
                                              blurRadius: 4.0),
                                          Shadow(
                                              color: Colors.yellow.shade800,
                                              blurRadius: 4.0),
                                          const Shadow(
                                              color: Colors.black,
                                              blurRadius: 10.0),
                                        ],
                                        color: Colors.yellow.shade100,
                                        letterSpacing: 0.5),
                                    //smcp as in small caps
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_currentSliderValue < 5) {
                                      AudioPlayer().play(
                                          AssetSource('sfx/FFXIV_Error.mp3'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red.shade900,
                                        content: const Text(
                                            'Commendation cannot be lower than 5!'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {},
                                        ),
                                      ));
                                    } else {
                                      appState.updateRating(widget.npc,
                                          _currentSliderValue.toInt());
                                      AudioPlayer().play(AssetSource(
                                          'sfx/FFXIV_Obtain_Item.mp3'));
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFFd6b475)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white)),
                                  child: Text('Submit Commendation')),
                            ],
                          ),
                        ),
                        Spacer(),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AudioPlayer().play(AssetSource('sfx/FFXIV_Close_Window.mp3'));
          Navigator.pop(context);
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFd6b475),
        shape: const CircleBorder(),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
