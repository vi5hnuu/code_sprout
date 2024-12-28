import 'package:bloc/bloc.dart';
import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/state/compilerState/compiler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';

class CodeEditor extends StatefulWidget {
  final String? language;
  final String? code;

  const CodeEditor({super.key, this.code,this.language}):assert((language!=null && code!=null) || (language==null && code==null));

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late var bloc=BlocProvider.of<CompilerBloc>(context);
  final supportedLanguages={
    "java":java,
    "cpp":cpp,
    "python":python,
    "javascript":javascript
  };
  late final theme=Theme.of(context);
  var activeHighlightTheme = vsTheme;
  late final controller = CodeController(
    text: widget.code ?? "console.log('hello devs')", // Initial code
    language: supportedLanguages[widget.language] ?? javascript,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: _showThemeMenu,
            icon: const Icon(Icons.format_paint)
          ),
        )],
      ),
      body: SafeArea(
        child:BlocBuilder<CompilerBloc,CompilerState>(
        buildWhen: (previous, current) => previous!=current,
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [Flex(direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DropdownMenu(
                            width: double.infinity,
                            initialSelection: _getLanguage(),
                            onSelected: (value) {
                              controller.setLanguage(supportedLanguages[value]!,analyzer: DefaultLocalAnalyzer());
                            },
                            label: const Text("Language"),
                            dropdownMenuEntries: supportedLanguages.keys.map((language) =>
                                DropdownMenuEntry<String?>(
                                    value: language,
                                    label: language)).toList()),
                      ),
                      const SizedBox(width: 12,),
                      FilledButton(onPressed: () => bloc.add(ExecuteCode(language: _getLanguage(), code: controller.code.text)), child: Text("Compile"))
                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(
                  child: CodeTheme(
                    data: CodeThemeData(styles: activeHighlightTheme),
                    child: SingleChildScrollView(
                      child: CodeField(
                        wrap: false,
                        minLines: 100,
                        gutterStyle: const GutterStyle(showErrors: true,showFoldingHandles: true,showLineNumbers: true),
                        controller: controller,
                      ),
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.black),
                  height: MediaQuery.of(context).size.height*0.25,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        if(state.isLoading(forr: HttpStates.COMPILER_CODE_EXECUTION)) Positioned(top: 5,right: 5,child: const SpinKitCircle(size: 16,color: Colors.green)),
                        RichText(text: TextSpan(children: [const TextSpan(text: "\$code-sprout >> ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green),),TextSpan(text: state.response?.result ?? state.response?.error ?? "",style: TextStyle(color: state.response?.error!=null ? Colors.red : Colors.white))])),
                      ],
                    ),
                  ),
                )
              ],
            )],
          );
        },),
      ),
    );
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

  _getLanguage() {
    return supportedLanguages.entries.firstWhere((langEntry)=>langEntry.value==controller.language).key;
  }

}