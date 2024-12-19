import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/routes.dart';
import 'package:code_sprout/singletons/NotificationService.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/BannerAdd.dart';
import 'package:code_sprout/widgets/RetryAgain.dart';
import 'package:code_sprout/widgets/ProblemListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemsInfoScreen extends StatefulWidget {
  final String title;
  final ProblemLanguage language;

  const ProblemsInfoScreen({super.key, required this.title,required this.language});

  @override
  State<ProblemsInfoScreen> createState() => _ProblemsInfoScreenState();
}

class _ProblemsInfoScreenState extends State<ProblemsInfoScreen> {
  late final bloc=BlocProvider.of<ProblemArchiveBloc>(context);
  final ScrollController _scrollController = ScrollController();
  CancelToken cancelToken = CancelToken();
  int pageNo = 1;
  ProblemCategory? category;

  @override
  void initState() {
    _loadPage(pageNo: pageNo,category: bloc.state.selectedCategory[widget.language]);
    _scrollController.addListener(_loadNextPage);
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
                letterSpacing: 2,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ProblemArchiveBloc, ProblemArchiveState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            final selectedCategory=state.selectedCategory[widget.language];
            final allPageProblems=state.getProblems(language: widget.language);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Expanded(child: Flex(direction: Axis.vertical,children: [
                     if(!state.isLoading(forr: HttpStates.PROBLEMS_INFO_PAGE)) DropdownMenu(
                         width: double.infinity,
                         initialSelection: selectedCategory,
                         onSelected: (value) {
                           _loadPage(pageNo: 1,category:value);
                         },
                         label: const Text("Difficulty level"),
                         dropdownMenuEntries:[const DropdownMenuEntry(value:null,label: "All"), ...ProblemCategory.values
                             .map((category) => DropdownMenuEntry<ProblemCategory?>(value: category, label: category.value.capitalize()))]),
                     if (allPageProblems.isNotEmpty) Expanded(
                         child: ListView.builder(
                           padding: const EdgeInsets.symmetric(vertical: 8),
                           controller: _scrollController,
                           itemCount: state.getProblemCount(language:widget.language),
                           itemBuilder: (context, index) {
                             final problem = allPageProblems[index];
                             return Padding(
                               padding: const EdgeInsets.symmetric(vertical: 2),
                               child: ProblemListTile(
                                 problem: problem.value,
                                 onTap: () {
                                   GoRouter.of(context).pushNamed(AppRoutes.problemDetail.name, pathParameters: {'language': widget.language.value,'problemId': problem.value.id});
                                 },
                                 onPlatformTap: _openUrl,),
                             );
                           },
                         ),
                       )
                     else if(!state.anyState(forr: HttpStates.PROBLEMS_INFO_PAGE)) Text("No Problems found",style: TextStyle(color: Colors.grey,fontSize: 24)),
                     Container(
                       child: (state.isLoading(forr: HttpStates.PROBLEMS_INFO_PAGE))
                           ? Padding(
                           padding: const EdgeInsets.symmetric(vertical: 20),
                           child: SpinKitThreeBounce(
                               color: Theme.of(context).primaryColor, size: 24))
                           : ((state.isError(forr: HttpStates.PROBLEMS_INFO_PAGE))
                           ? RetryAgain(
                           onRetry: ()=> _loadPage(pageNo: pageNo,category:selectedCategory ),
                           error: state
                               .getError(forr: HttpStates.PROBLEMS_INFO_PAGE)!
                               .message)
                           : null),
                     )
                  ],)),
                  const BannerAdd(),
                ],
              ),
            );
          },
        ));
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      NotificationService.showSnackbar(text: "Failed to open page");
    }
  }

  void _loadPage({required int pageNo,required ProblemCategory? category}) {
    BlocProvider.of<ProblemArchiveBloc>(context).add(FetchProblemInfoPage(pageNo: pageNo,language:widget.language,category:category, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    // Calculate the scroll percentage
    double scrollPercentage = currentScrollPosition / maxScrollExtent;
    // Check if scroll percentage is greater than or equal to 80%
    if (scrollPercentage <= 0.8) return;
    if (bloc.state.canLoadNextPage(language:widget.language,pageNo: pageNo+1)) {
      setState(() => _loadPage(pageNo: ++pageNo,category: bloc.state.selectedCategory[widget.language]));
    }
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling vrat katha page info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }

}
