import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/singletons/DioSingleton.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProblemDetailscreen extends StatefulWidget {
  final String problemId;

  const ProblemDetailscreen({super.key,required this.problemId});

  @override
  State<ProblemDetailscreen> createState() => _ProblemDetailscreenState();
}

class _ProblemDetailscreenState extends State<ProblemDetailscreen> {
  var activeHighlightTheme = githubTheme;
  late final ProblemArchive problemDetail;
  String? code;

  @override
  void initState() {
    problemDetail = BlocProvider.of<ProblemArchiveBloc>(context)
        .state
        .getProblemInfoById(problemId: widget.problemId)!;
    _loadFileContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(problemDetail.title),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: code != null
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                    child: HighlightView(
                        code!,
                        language: problemDetail.language.value.toLowerCase(),
                        theme: activeHighlightTheme,
                        padding: const EdgeInsets.all(24),
                        textStyle: const TextStyle(
                          overflow: TextOverflow.visible,
                            fontFamily:
                                'monospace'),
                      ),
                  )
                  : Padding(padding: const EdgeInsets.all(24.0),child: SpinKitPulse(color: theme.primaryColor),),
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
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _loadFileContent() async {
    try {
      final response = await DioSingleton().dio.get(problemDetail.filePath);
      if (response.statusCode == 200) {
        setState(() => code = response.data); // Set the file content
      } else {
        throw Exception(
            'Failed to load file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  void _showThemeMenu() {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(1, 0.1, 0.5, 0.5),
      menuPadding: EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      surfaceTintColor: theme.primaryColorLight,
      constraints: BoxConstraints.tight(
          Size(mediaQuery.size.width * 0.4, mediaQuery.size.height * 0.6)),
      items: themeMap.keys.map((String themeName) {
        return PopupMenuItem<String>(
          value: themeName,
          child: Text(themeName.capitalize().split('-').join(' ')),
        );
      }).toList(),
    ).then((selectedTheme) {
      if (selectedTheme == null) return;
      setState(() => activeHighlightTheme = themeMap[selectedTheme]!);
    });
  }
}
