import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/models/HttpState.dart';
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
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TagProblemsScreen extends StatefulWidget {
  final String title;
  final String tagId;

  const TagProblemsScreen(
      {super.key, required this.title, required this.tagId});

  @override
  State<TagProblemsScreen> createState() => _TagProblemsScreenState();
}

class _TagProblemsScreenState extends State<TagProblemsScreen> {
  late final bloc = BlocProvider.of<ProblemArchiveBloc>(context);
  final ScrollController _scrollController = ScrollController();
  CancelToken cancelToken = CancelToken();
  int pageNo = 1;

  @override
  void initState() {
    AdsSingleton().dispatch(LoadInterstitialAd());
    _loadPage(pageNo: pageNo);
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
          actions: [
            if(bloc.state.totalPages[widget.tagId]!=null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text('${pageNo}/${bloc.state.totalPages[widget.tagId]}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
              )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ProblemArchiveBloc, ProblemArchiveState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            final tagProblems = state.getTagProblems(tagId:widget.tagId);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          controller: _scrollController,
                          itemCount: tagProblems.length,
                          itemBuilder: (context, index) {
                            final problem = tagProblems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ProblemListTile(
                                problem: problem,
                                onTap: () {
                                  GoRouter.of(context).pushNamed(
                                      AppRoutes.problemDetail.name,
                                      queryParameters: {'tagId': widget.tagId,},
                                      pathParameters: {
                                        'language': problem.language.value,
                                        'problemId': problem.id
                                      });
                                },
                                onPlatformTap: _openUrl,
                              ),
                            );
                          },
                        ),
                      ),
                      if (tagProblems.isEmpty &&
                          !state.anyState(forr: HttpStates.TAG_PROBLEMS_PAGE))
                        const Text("No Problems found",
                            style: TextStyle(color: Colors.grey, fontSize: 24)),
                      if (state.isLoading(forr: HttpStates.TAG_PROBLEMS_PAGE))
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                                size: 24))
                      else if (state.isError(
                          forr: HttpStates.TAG_PROBLEMS_PAGE))
                        RetryAgain(
                            onRetry: () => _loadPage(pageNo: pageNo),
                            error: state.getError(
                                forr: HttpStates.TAG_PROBLEMS_PAGE)!)
                    ],
                  )),
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

  void _loadPage({required int pageNo}) {
    bloc.add(FetchTagProblemsPage(
        tagId: widget.tagId, pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    // Calculate the scroll percentage
    double scrollPercentage = currentScrollPosition / maxScrollExtent;
    // Check if scroll percentage is greater than or equal to 80%
    if (scrollPercentage <= 0.8) return;

    final totalPages = bloc.state.totalPages[widget.tagId];
    if (!bloc.state.isLoading(forr: HttpStates.TAG_PROBLEMS_PAGE) && (totalPages == null || totalPages >= pageNo + 1)) {
      setState(() => _loadPage(pageNo: ++pageNo));
    }
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling problems page info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
