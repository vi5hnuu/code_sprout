import 'package:code_sprout/extensions/string-etension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/codepen-embed.dart';
import 'package:flutter_highlight/themes/github-gist.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/sunburst.dart';

const dummyCode = '''
 // /**
//  * Definition for a binary tree node.
//  * struct TreeNode {
//  *     int val;
//  *     TreeNode *left;
//  *     TreeNode *right;
//  *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
//  *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
//  *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
//  * };
//  */
// class Solution {
//     int heightTree(TreeNode *root){
//         if(!root){
//             return 0;
//         }
//         if(!root->left && !root->right){
//             return 1;
//         }
//         return 1+max(heightTree(root->left),heightTree(root->right));
//     }
//     int dls(TreeNode *root,int h){
//         if(!root){
//             return 0;
//         }
//         if(h==1){
//             return root->val;
//         }
//         return dls(root->left,h-1)+dls(root->right,h-1);
//     }
// public:
//     int deepestLeavesSum(TreeNode* root) {
//         int h=heightTree(root);
//         return dls(root,h);
//     }
// };
///////////////
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int deepestLeavesSum(TreeNode* root) {
        queue<TreeNode*> nodes;
        nodes.push(root);

        while(!nodes.empty()){
            int sz=nodes.size();
            int levelSum=0;
            bool lastLevel=true;
            while(sz>0){
                auto node=nodes.front();
                levelSum+=node->val;
                nodes.pop();
                if(node->left){
                    nodes.push(node->left);
                    lastLevel=false;
                }
                if(node->right){
                    nodes.push(node->right);
                    lastLevel=false;
                }
                sz--;
            }
            if(lastLevel) return levelSum;
        }
        return -1;
    }
};
''';

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
              child: HighlightView(
                dummyCode,
                language: 'cpp',
                theme: activeHighlightTheme,
                padding: const EdgeInsets.all(24),
                textStyle: const TextStyle(
                    fontFamily:
                        'SFMono-Regular,Consolas,Liberation Mono,Menlo,monospace'),
              ),
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
