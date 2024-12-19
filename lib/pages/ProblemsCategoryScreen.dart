import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/routes.dart';
import 'package:code_sprout/singletons/AdsSingleton.dart';
import 'package:code_sprout/singletons/NotificationService.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/BannerAdd.dart';
import 'package:code_sprout/widgets/RetryAgain.dart';
import 'package:code_sprout/widgets/ProblemListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemsCategoryScreen extends StatefulWidget {
  final String title;

  const ProblemsCategoryScreen({super.key, required this.title});

  @override
  State<ProblemsCategoryScreen> createState() => _ProblemsCategoryScreenState();
}

class _ProblemsCategoryScreenState extends State<ProblemsCategoryScreen> {
  late GoRouter router=GoRouter.of(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "monospace",
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Flex(direction: Axis.vertical,children: [
          Expanded(child: GridView.extent(
            padding: EdgeInsets.all(12.0),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            maxCrossAxisExtent: 70,shrinkWrap: true,children: [
            GestureDetector(
              child: SvgPicture.asset('assets/icons/cpp.svg',width: 150,),
              onTap: ()=>router.pushNamed(AppRoutes.problemsByCategory.name,pathParameters: {'language':ProblemLanguage.CPP.value}),
            ),
            GestureDetector(
              child: SvgPicture.asset('assets/icons/sql.svg',width: 150,),
              onTap: ()=>router.pushNamed(AppRoutes.problemsByCategory.name,pathParameters: {'language':ProblemLanguage.SQL.value}),
            )
          ],)),
          const BannerAdd()
        ],));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
