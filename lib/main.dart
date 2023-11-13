import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dutysupport_icons.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M08 - Llista de Personatges',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 19, 10, 55)),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor:
                  ColorScheme.fromSeed(seedColor: Color(0x130a37)).onPrimary,
              displayColor:
                  ColorScheme.fromSeed(seedColor: Color(0x130a37)).onPrimary,
            ),
        iconTheme: IconThemeData(
            color: ColorScheme.fromSeed(seedColor: Color(0x130a37)).onPrimary),
        chipTheme: ChipThemeData(
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
          decoration: BoxDecoration(
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
              Expanded(
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
                              icon: Icon(Dutysupport.dutysupport)),
                          Text('Duty Support Commendation Tool',
                              style: TextStyle(fontSize: 20))
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            //-------------------------------------------------
                            FormBuilderChoiceChip(
                                name: 'choice_chips',
                                alignment: WrapAlignment.start,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 5.0)),
                                options: [
                                  FormBuilderChipOption(
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
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[],
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
