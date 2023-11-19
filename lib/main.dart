// ignore_for_file: camel_case_types, must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ia03_05_llista/pages/add_duty_npc_page.dart';
import 'package:ia03_05_llista/models/duty_npc_model.dart';
import 'widget/duty_npc_list.dart';
import 'dutysupport_icons.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

String currentUrl = 'https://654e59c7cbc325355742c905.mockapi.io/api/v1/trust/';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class ChangedCharacterList extends ChangeNotifier {
  List<NPC> dutySupportCurrentList = [];

  void initialize() {
    if (dutySupportCurrentList.isEmpty) {
      Future<List<NPC>> fetchedList =
          fetchNpcList(http.Client(), '$currentUrl?expansion=ARR');
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
        ),
        home: const MyHomePage(),
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
              CustomContent(list: appState.dutySupportCurrentList),
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

class CustomContent extends StatefulWidget {
  List<NPC> list = [];

  CustomContent({
    super.key,
    required this.list,
  });

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
          DutyNpcList(npcs: widget.list),
        ],
      ),
    );
  }
}
