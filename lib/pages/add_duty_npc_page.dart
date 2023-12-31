// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ia03_05_llista/main.dart';
import 'package:ia03_05_llista/models/duty_npc_model.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

String currentUrl = 'https://654e59c7cbc325355742c905.mockapi.io/api/v1/trust/';

Future<List<NPC>> fetchNpcList(http.Client client, String inputUrl) async {
  final response = await client.get(Uri.parse(inputUrl));

  // Use the compute function to run parsenpcs in a separate isolate.
  return compute(parseNpcList, response.body);
}

// A function that converts a response body into a List<npc>.
List<NPC> parseNpcList(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<NPC>((json) => NPC.fromJson(json)).toList();
}

class AddDutyCharacterPage extends StatelessWidget {
  AddDutyCharacterPage({super.key});
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ChangedCharacterList>();

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
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                        labelText: 'Write a Duty Support character here',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          AudioPlayer()
                              .play(AssetSource('sfx/FFXIV_Notification.mp3'));
                          Future<List<NPC>> fetchedList = fetchNpcList(
                              http.Client(),
                              '$currentUrl?name=${myController.text}');
                          fetchedList.then((value) {
                            appState.addCharacterToList(value.first);
                          });
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFd6b475)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white)),
                        child: const Text('Add new character'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
