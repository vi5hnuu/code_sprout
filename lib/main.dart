import 'dart:io';

import 'package:code_sprout/extensions/string-etension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/codepen-embed.dart';
import 'package:flutter_highlight/themes/github-gist.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/sunburst.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var activeHighlightTheme=githubTheme;
  String? code;

  @override
  void initState() {
    _loadFileContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: code!=null ? HighlightView(
                code!,
                language: 'cpp',
                theme: activeHighlightTheme,
                padding: const EdgeInsets.all(24),
                textStyle: const TextStyle(
                    fontFamily:
                        'SFMono-Regular,Consolas,Liberation Mono,Menlo,monospace'),
              ):SpinKitCircle(color: theme.primaryColor),
            ),
            Align(
              alignment: Alignment(0.90, -0.95),
              child: IconButton(
                onPressed: _showThemeMenu,
                icon: const Icon(Icons.format_paint),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(theme.primaryColorLight),
                    elevation: WidgetStatePropertyAll(5)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _loadFileContent() async {
    try {
      final file = File("/assets/temp.cpp");
      final content = await file.readAsString(); // Read the file as a string
      setState(()=>code=content);
    } catch (e) {

    }
  }

  void _showThemeMenu() {
    final mediaQuery=MediaQuery.of(context);
    final theme=Theme.of(context);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(1,0.1,0.5,0.5),
      menuPadding: EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      surfaceTintColor: theme.primaryColorLight,
      constraints: BoxConstraints.tight(Size(mediaQuery.size.width*0.4, mediaQuery.size.height*0.6)),
      items: themeMap.keys.map((String themeName) {
        return PopupMenuItem<String>(
          value: themeName,
          child: Text(themeName.capitalize().split('-').join(' ')),
        );
      }).toList(),
    ).then((selectedTheme) {
      if (selectedTheme == null) return;
      setState(() =>activeHighlightTheme = themeMap[selectedTheme]!);
    });
  }
}
