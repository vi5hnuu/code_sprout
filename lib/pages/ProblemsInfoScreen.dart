import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/state/vratkatha/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/RetryAgain.dart';
import 'package:code_sprout/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ProblemsInfoScreen extends StatefulWidget {
  final String title;

  const ProblemsInfoScreen({super.key, required this.title});

  @override
  State<ProblemsInfoScreen> createState() => _ProblemsInfoScreenState();
}

class _ProblemsInfoScreenState extends State<ProblemsInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  CancelToken cancelToken = CancelToken();
  int pageNo = 1;

  @override
  void initState() {
    loadCurrentPage();
    _scrollController.addListener(_loadNextPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:BlocBuilder<ProblemArchiveBloc, ProblemArchiveState>(
    buildWhen: (previous, current) => previous != current,
    builder: (context, state) {
      final pageItems=state.problemsInfo[pageNo]?.entries;
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(pageItems!=null) Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: pageItems.length,
              itemBuilder: (context, index) {
                final problem = pageItems.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: RoundedListTile(
                      itemNo: index + 1,
                      onTap: () => GoRouter.of(context).pushNamed('problems detail',pathParameters: {'problemId':problem.value.id}),
                      text: '${problem.value.title}'),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: (state.isLoading(forr: HttpStates.PROBLEMS_INFO_PAGE))
                ? Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitThreeBounce(color: Theme.of(context).primaryColor, size: 24))
                : ((state.isError(forr: HttpStates.PROBLEMS_INFO_PAGE))
                ? RetryAgain(
                onRetry: loadCurrentPage,
                error: state
                    .getError(
                    forr: HttpStates.PROBLEMS_INFO_PAGE)!
                    .message)
                : null),
          )
        ],
      );
    },
    ));

  }

  loadCurrentPage(){
    _loadPage(pageNo: pageNo);
  }

  void _loadPage({required int pageNo}) {
    BlocProvider.of<ProblemArchiveBloc>(context).add(FetchProblemInfoPage(pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    // Calculate the scroll percentage
    double scrollPercentage = currentScrollPosition / maxScrollExtent;
    // Check if scroll percentage is greater than or equal to 80%
    if (scrollPercentage <= 0.8) return;
    final bloc=BlocProvider.of<ProblemArchiveBloc>(context);
    if(bloc.state.canLoadNextPage(pageNo:pageNo)) setState(() => _loadPage(pageNo: ++pageNo));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling vrat katha page info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
