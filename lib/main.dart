
import 'package:code_sprout/pages/ProblemsInfoScreen.dart';
import 'package:code_sprout/pages/SplashScreen.dart';
import 'package:code_sprout/pages/problemDetailScreen.dart';
import 'package:code_sprout/services/problemArchive/ProblemArchiveRepository.dart';
import 'package:code_sprout/singletons/NotificationService.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final parentNavKey=GlobalKey<NavigatorState>();

void main() async{
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
  final router=GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/splash',
      routes: [
        GoRoute(
        name: 'splash',
        path: '/splash',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: 'problem',
          path: '/problem',
          redirect: (context, state) {
            if(state.fullPath=='/problem'){
              return '/problem/info';
            }
            return null;
          },
          routes: [
            GoRoute(name: 'problems info',path: 'info',
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const ProblemsInfoScreen(title: "🥗 Sprouts 🥗"),
                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
              ), ),
            GoRoute(name: 'problems detail',path: ':problemId/detail',
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: ProblemDetailscreen(problemId:state.pathParameters['problemId']!),
                transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
              ), )
          ]
        ),
      ]);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);//lifecycycle events
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProblemArchiveBloc>(lazy: false, create: (ctx) => ProblemArchiveBloc(problemsArchiveRepository: ProblemArchiveRepository()))
      ],
      child:MaterialApp.router(
        key: parentNavKey,
        scaffoldMessengerKey: NotificationService.messengerKey,
        title: 'Code Sprout',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  }
}
