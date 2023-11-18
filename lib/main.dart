// ignore_for_file: camel_case_types

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ia03_05_llista/add_duty_character_page.dart';
import 'package:ia03_05_llista/npc_information_page.dart';
import 'package:ia03_05_llista/npc_model.dart';
import 'dutysupport_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

String baseUrl = 'https://654e59c7cbc325355742c905.mockapi.io/api/v1/trust/';
String currentUrl = 'https://654e59c7cbc325355742c905.mockapi.io/api/v1/trust/';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

List<NPC> initialize() {
  Future<List<NPC>> fetchedList =
      fetchnpcs(http.Client(), '$currentUrl?expansion=ARR');
  fetchedList.then((value) {
    return value;
  });
  return [];
}

class ChangedCharacterList extends ChangeNotifier {
  List<NPC> dutySupportCurrentList = [];

  void initialize() {
    if (dutySupportCurrentList.isEmpty) {
      Future<List<NPC>> fetchedList =
          fetchnpcs(http.Client(), '$currentUrl?expansion=ARR');
      fetchedList.then((value) {
        dutySupportCurrentList = value;
        notifyListeners();
      });
    }
  }

  void updateRating(NPC npc, int newValue) {
    int index = dutySupportCurrentList.indexOf(npc);
    dutySupportCurrentList[index].rating = newValue;
    notifyListeners();
  }

  void addCharacterToList(NPC character) {
    dutySupportCurrentList.add(character);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangedCharacterList(),
      child: MaterialApp(
        title: 'M08 - Llista de Personatges',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 19, 10, 55)),
          useMaterial3: true,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor:
                    ColorScheme.fromSeed(seedColor: const Color(0x00130a37))
                        .onPrimary,
                displayColor:
                    ColorScheme.fromSeed(seedColor: const Color(0x00130a37))
                        .onPrimary,
              ),
          iconTheme: IconThemeData(
              color: ColorScheme.fromSeed(seedColor: const Color(0x00130a37))
                  .onPrimary),
          chipTheme: const ChipThemeData(
            labelPadding: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            showCheckmark: false,
            backgroundColor: Color.fromARGB(255, 39, 7, 91),
            selectedColor: Color.fromARGB(255, 3, 80, 108),
            side: BorderSide.none,
            elevation: 3,
            selectedShadowColor: Color.fromARGB(255, 41, 198, 255),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ChangedCharacterList>();
    appState.initialize();

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 39, 7, 91),
                Color.fromARGB(255, 3, 80, 108)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CustomAppBar(),
              CustomContent(
                  formKey: _formKey, list: appState.dutySupportCurrentList),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AudioPlayer().play(AssetSource('sfx/FFXIV_Open_Window.mp3'));
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (BuildContext context, _, __) {
            return AddDutyCharacterPage();
          }, transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFd6b475),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomContent extends StatefulWidget {
  List<NPC> list = [];

  CustomContent({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.list,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;

  @override
  State<CustomContent> createState() => _CustomContentState();
}

class _CustomContentState extends State<CustomContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Column(
        children: [
          NPCFilter(formKey: widget._formKey),
          npcsList(npcs: widget.list)
        ],
      ),
    );
  }
}

class NPCFilter extends StatelessWidget {
  const NPCFilter({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        onChanged: () => {
              _formKey.currentState?.saveAndValidate(),
              currentUrl =
                  "$baseUrl?expansion=${_formKey.currentState?.value["choice_chips"]}",
              debugPrint(currentUrl),
              debugPrint(_formKey.currentState?.value["choice_chips"])
            },
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              //-------------------------------------------------
              FormBuilderChoiceChip(
                  name: 'choice_chips',
                  alignment: WrapAlignment.start,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 5.0)),
                  options: [
                    const FormBuilderChipOption(
                      value: 'ALL',
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Center(child: Text('All'))),
                    ),
                    FormBuilderChipOption(
                      value: 'ARR',
                      child: Image.asset(
                        'assets/UI/arr.png',
                        scale: 1.5,
                      ),
                    ),
                    FormBuilderChipOption(
                      value: 'HVW',
                      child: Image.asset(
                        'assets/UI/hvw.png',
                        scale: 1.5,
                      ),
                    ),
                    FormBuilderChipOption(
                      value: 'STB',
                      child: Image.asset(
                        'assets/UI/stb.png',
                        scale: 1.5,
                      ),
                    ),
                    FormBuilderChipOption(
                      value: 'SHB',
                      child: Image.asset(
                        'assets/UI/shb.png',
                        scale: 1.5,
                      ),
                    ),
                    FormBuilderChipOption(
                      value: 'ENW',
                      child: Image.asset(
                        'assets/UI/enw.png',
                        scale: 1.5,
                      ),
                    ),
                  ]),
            ],
          ),
        ));
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Dutysupport.dutysupport)),
                const Text('Duty Support Commendation Tool',
                    style: TextStyle(fontSize: 20))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class npcsList extends StatefulWidget {
  const npcsList({super.key, required this.npcs});

  final List<NPC> npcs;

  @override
  State<npcsList> createState() => _npcsListState();
}

class _npcsListState extends State<npcsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.npcs.length,
          itemBuilder: (context, index) {
            return NPCCard(npcs: widget.npcs, index: index);
          },
        ),
      ),
    );
  }
}

class NPCCard extends StatelessWidget {
  const NPCCard({
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
          debugPrint('Card tapped.');
        },
        child: SizedBox(
          width: 300,
          height: 90,
          child: Stack(
            children: [
              CardBackground(category: npcs[index].class_category),
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
                    Text(
                      npcs[index].rating.toString(),
                      style: GoogleFonts.michroma(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 29.5,
                            color: Colors.black45,
                            letterSpacing: 0.5),
                        //smcp as
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

class CardBackground extends StatelessWidget {
  CardBackground({
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
