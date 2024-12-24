import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/pages/ProblemsHomeScreen.dart';
import 'package:code_sprout/pages/ProblemsInfoScreen.dart';
import 'package:code_sprout/pages/SplashScreen.dart';
import 'package:code_sprout/pages/TagProblemsScreen.dart';
import 'package:code_sprout/pages/problemDetailScreen.dart';
import 'package:code_sprout/routes.dart';
import 'package:code_sprout/services/problemArchive/ProblemArchiveRepository.dart';
import 'package:code_sprout/singletons/NotificationService.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final parentNavKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static final _whiteListedRoutes = [];
  final router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: AppRoutes.splashRoute.path,
      routes: [
        GoRoute(
          name: AppRoutes.splashRoute.name,
          path: AppRoutes.splashRoute.path,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
            name: AppRoutes.problems.name,
            path: AppRoutes.problems.path,
            redirect: (context, state) {
              if (state.fullPath == AppRoutes.problems.path) {
                return '${AppRoutes.problems.path}/${AppRoutes.problemsHome.path}';
              }
              return null;
            },
            routes: [
              GoRoute(
                name: AppRoutes.problemsHome.name,
                path: AppRoutes.problemsHome.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProblemsHomeScreen(title: "Sprouts"),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                  name: AppRoutes.problemsByCategory.name,
                  path: AppRoutes.problemsByCategory.path,
                  pageBuilder: (context, state) {
                    final language = state.pathParameters['language']!;
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: ProblemsInfoScreen(
                          title: "${language.capitalize()} Problems",
                          language: ProblemLanguage.fromValue(language)!),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    );
                  }),
              GoRoute(
                  name: AppRoutes.tagProblems.name,
                  path: AppRoutes.tagProblems.path,
                  pageBuilder: (context, state) {
                    final tagTitle = (state.extra as Map)['tagTitle']!;
                    final tagId = state.pathParameters['tagId']!;
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: TagProblemsScreen(title: tagTitle, tagId: tagId),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                    );
                  }),
              GoRoute(
                name: AppRoutes.problemDetail.name,
                path: AppRoutes.problemDetail.path,
                pageBuilder: (context, state) {
                  final problemId=state.pathParameters['problemId']!;
                  final language=ProblemLanguage.fromValue(state.pathParameters['language']!)!;
                  String? tagId= state.uri.queryParameters['tagId'];
                  return CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: ProblemDetailscreen(
                        tagId: tagId,
                        language: language,
                        problemId: problemId,),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                  );
                },
              )
            ]),
      ]);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); //lifecycycle events
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProblemArchiveBloc>(
            lazy: false,
            create: (ctx) => ProblemArchiveBloc(
                problemsArchiveRepository: ProblemArchiveRepository()))
      ],
      child: MaterialApp.router(
        key: parentNavKey,
        scaffoldMessengerKey: NotificationService.messengerKey,
        title: 'Code Sprout',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true,
            fontFamily: 'monospace',
            iconTheme: const IconThemeData(color: Colors.white)),
        routerConfig: router,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
}
