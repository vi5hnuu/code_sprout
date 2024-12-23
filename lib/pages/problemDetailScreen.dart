import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/singletons/AdsSingleton.dart';
import 'package:code_sprout/singletons/DioSingleton.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/BannerAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class ProblemDetailscreen extends StatefulWidget {
  final ProblemLanguage language;
  final String problemId;

  const ProblemDetailscreen(
      {super.key, required this.language, required this.problemId});

  @override
  State<ProblemDetailscreen> createState() => _ProblemDetailscreenState();
}

class _ProblemDetailscreenState extends State<ProblemDetailscreen> {
  var activeHighlightTheme = githubTheme;
  late final ProblemArchive problemDetail;
  String? code;

  @override
  void initState() {
    AdsSingleton().dispatch(LoadInterstitialAd());
    problemDetail = BlocProvider.of<ProblemArchiveBloc>(context)
        .state
        .getProblemInfoById(
            language: widget.language, problemId: widget.problemId)!;
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
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
                              language:
                                  problemDetail.language.value.toLowerCase(),
                              theme: activeHighlightTheme,
                              padding: const EdgeInsets.all(24),
                              textStyle: const TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontFamily: 'monospace'),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SpinKitPulse(color: theme.primaryColor),
                          ),
                  ),
                  Align(
                    alignment: const Alignment(0.98, -0.90),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Opacity(
                        opacity: 0.7,
                        child: Column(
                          children: [
                            if (code != null)
                              IconButton(
                                onPressed: () => Clipboard.setData(
                                    ClipboardData(text: code!)),
                                icon: const Icon(Icons.copy),
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        theme.primaryColorLight),
                                    elevation: const WidgetStatePropertyAll(5)),
                              ),
                            if (code != null)
                              IconButton(
                                onPressed: () => Share.share(code!),
                                icon: const Icon(Icons.share),
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        theme.primaryColorLight),
                                    elevation: const WidgetStatePropertyAll(5)),
                              ),
                            IconButton(
                              onPressed: _showThemeMenu,
                              icon: const Icon(Icons.format_paint),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      theme.primaryColorLight),
                                  elevation: const WidgetStatePropertyAll(5)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              const BannerAdd(),
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
      rethrow;
    }
  }

  void _showThemeMenu() {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1, 0.1, 0.5, 0.5),
      menuPadding: const EdgeInsets.all(12),
      elevation: 5,
      shape: const RoundedRectangleBorder(
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
