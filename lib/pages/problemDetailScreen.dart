import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/ProblemImage.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/singletons/AdsSingleton.dart';
import 'package:code_sprout/singletons/DioSingleton.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/BannerAdd.dart';
import 'package:code_sprout/widgets/DrawOnScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class ProblemDetailscreen extends StatefulWidget {
  final String? tagId;
  final ProblemLanguage language;
  final String problemId;

  const ProblemDetailscreen(
      {super.key, this.tagId,required this.language, required this.problemId});

  @override
  State<ProblemDetailscreen> createState() => _ProblemDetailscreenState();
}

class _ProblemDetailscreenState extends State<ProblemDetailscreen> {
  var activeHighlightTheme = vsTheme;
  late final ProblemArchive problemDetail;
  ProblemImage? selectedProblemImage;
  String? code;
  bool isDrawEnabled=false;
  Color penColor=Colors.blue;

  @override
  void initState() {
    AdsSingleton().dispatch(LoadInterstitialAd());
    problemDetail = BlocProvider.of<ProblemArchiveBloc>(context)
        .state.getProblemInfoById(tagId:widget.tagId,language: widget.language, problemId: widget.problemId)!;
    _loadFileContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late MediaQueryData md=MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text(problemDetail.title),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(isDrawEnabled) IconButton(
              onPressed: () => _showColorPicker(context),
              icon: const Icon(Icons.color_lens, size: 32),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(theme.primaryColor),
                elevation: WidgetStateProperty.all(5),
              ),
            ),
            if(isDrawEnabled) const SizedBox(height: 8),
            IconButton(
              onPressed: ()=>setState(()=>isDrawEnabled=!isDrawEnabled),
              icon: const Icon(Icons.draw,size: 32),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(isDrawEnabled ? theme.primaryColor : Colors.red),
                  elevation: const WidgetStatePropertyAll(5)),
            )
          ],
        ),
        body: Center(
          child: Flex(
            direction: Axis.vertical,
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
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'menlo'),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SpinKitPulse(color: theme.primaryColor),
                          ),
                  ),

                  if(selectedProblemImage!=null)
                    Align(alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black38),
                        height: md.size.height * 0.25,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DraggableInteractiveImage(
                                title: selectedProblemImage!.title,
                                src: selectedProblemImage!.src),
                            Positioned(right: 10,
                                top: 10,
                                child: IconButton(onPressed: () =>
                                    setState(() => selectedProblemImage = null),
                                    icon: Icon(Icons.close))),
                          ],
                        ),),),
                  DrawOnScreen(allowEditing: isDrawEnabled,penColor:penColor),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              if(problemDetail.problemImages.isNotEmpty) SizedBox(
                height: md.size.height*0.08,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8.0),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: problemDetail.problemImages.map((problemImage){
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: QuestionThumbnailImage(onTap: () => setState(() =>selectedProblemImage=problemImage),itemNo: 1,src:problemImage.src),
                    );
                  }).toList(),
                ),
              ),
              const BannerAdd(),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void _showColorPicker(BuildContext context)async {
    final Color? result= await showDialog(
      context: context,
      builder: (context) {
        Color selectedColor=penColor;
        return AlertDialog(
          title: Text('Pick Pen Color',style: TextStyle(color: selectedColor),),
          content: SingleChildScrollView(
            child: BlockPicker(
              useInShowDialog: true,
              pickerColor: selectedColor, // Current selected color
              onColorChanged: (color)=>setState(() => selectedColor = color),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedColor),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
    if(result!=null) setState(()=>penColor=result);
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

class QuestionThumbnailImage extends StatelessWidget {
  final String src;
  final int itemNo;
  final VoidCallback? onTap;

  const QuestionThumbnailImage({
    required this.src,
    required this.itemNo,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.all(4),
            child: Image.network(src,fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) => SizedBox(height: double.infinity,child: Icon(Icons.error,color: Colors.red,),),
              loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : SpinKitCircle(color: Colors.green,),),
          ),
          Positioned(right: 4,top: 4,child: CircleAvatar(child: Text(itemNo.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),maxRadius: 10,),)
        ],
      ),
    );
  }
}


class DraggableInteractiveImage extends StatelessWidget {
  final String src;
  final String title;

  const DraggableInteractiveImage({super.key,required this.src,required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(50),
        minScale: 0.5,
        maxScale: 5.0,
        constrained: true,
        child: Image.network(
          src,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => SizedBox(height: double.infinity,child: Icon(Icons.error,color: Colors.red,),),
          loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : SpinKitCircle(color: Colors.green,),)),
          Positioned(top: 5,left: 5,child:Container(constraints: const BoxConstraints(maxWidth: 300),padding: const EdgeInsets.symmetric(horizontal: 8),decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(4)),child: Text(title,style: const TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis),),))
      ],
    );
  }
}