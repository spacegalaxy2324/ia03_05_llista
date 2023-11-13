import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ia03_05_llista/npc_model.dart';
import 'dutysupport_icons.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
              CustomContent(formKey: _formKey),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContent extends StatefulWidget {
  const CustomContent({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;

  @override
  State<CustomContent> createState() => _CustomContentState();
}

// Future<List<NPC>> dutySupport() async {
//   HttpClient http = HttpClient();
//   var uri = Uri.https('654e59c7cbc325355742c905.mockapi.io', '/api/v1/trust/');
//   var request = await http.getUrl(uri);
//   var response = await request.close();
//   var responseBody = await response.transform(utf8.decoder).join();

//   return jsonDecode(responseBody);
// }

Future<List<NPC>> fetchPhotos(http.Client client) async {
  final response = await client.get(
      Uri.parse('https://654e59c7cbc325355742c905.mockapi.io/api/v1/trust/'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<NPC> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<NPC>((json) => NPC.fromJson(json)).toList();
}

class _CustomContentState extends State<CustomContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Column(
        children: [
          NPCFilter(formKey: widget._formKey),
          FutureBuilder<List<NPC>>(
            future: fetchPhotos(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return PhotosList(photos: snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
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
        key: _formKey,
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
            child: Container(
                child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Dutysupport.dutysupport)),
                const Text('Duty Support Commendation Tool',
                    style: TextStyle(fontSize: 20))
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<NPC> photos;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(photos[index].name));
        },
      ),
    );
  }
}
