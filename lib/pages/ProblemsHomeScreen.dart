import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/models/ProblemTag.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/routes.dart';
import 'package:code_sprout/state/ProblemArchive/ProblemArchive_bloc.dart';
import 'package:code_sprout/widgets/BannerAdd.dart';
import 'package:code_sprout/widgets/RetryAgain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ProblemsHomeScreen extends StatefulWidget {
  final String title;

  const ProblemsHomeScreen({super.key, required this.title});

  @override
  State<ProblemsHomeScreen> createState() => _ProblemsHomeScreenState();
}

class _ProblemsHomeScreenState extends State<ProblemsHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late ProblemArchiveBloc bloc = BlocProvider.of<ProblemArchiveBloc>(context);
  late GoRouter router = GoRouter.of(context);
  late ThemeData theme = Theme.of(context);
  late MediaQueryData md = MediaQuery.of(context);
  int tagsPageNo = 1;

  @override
  void initState() {
    _loadTags(pageNo: tagsPageNo);
    _scrollController.addListener(_loadNextPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: ()=>router.pushNamed(AppRoutes.editor.name),
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text("Open Editor",style: TextStyle(fontFamily: "monospace",fontWeight: FontWeight.bold,color: Colors.white)),
                    SizedBox(width: 8,),
                    Icon(Icons.code)
                  ],
                ),
              ),
            )
          ],
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "monospace",
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            GridView.extent(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              maxCrossAxisExtent: 70,
              shrinkWrap: true,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/icons/cpp.svg',
                    width: 150,
                  ),
                  onTap: () => router.pushNamed(
                      AppRoutes.problemsByCategory.name,
                      pathParameters: {'language': ProblemLanguage.CPP.value}),
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/icons/sql.svg',
                    width: 150,
                  ),
                  onTap: () => router.pushNamed(
                      AppRoutes.problemsByCategory.name,
                      pathParameters: {'language': ProblemLanguage.SQL.value}),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ProblemArchiveBloc, ProblemArchiveState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  final imageWidth = md.size.width * 0.18;
                  final tags = state.getTags();
                  return Flex(
                    direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        tileColor: theme.highlightColor.withOpacity(0.2),
                        title: const Text(
                          "Curated Lists",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        leading: const Icon(
                          FontAwesomeIcons.tableList,
                          size: 20,
                        ),
                      ),
                      if (tags.isEmpty &&
                          !state.anyState(forr: HttpStates.PROBLEM_TAGS_PAGE))
                        const Text(
                          "No Curated list found 😢",
                          style: TextStyle(color: Colors.black, height: 6),
                        ),
                      Flexible(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: tags.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 24),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final tag = tags[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: TagItem(
                                key: ValueKey(tag.id),
                                  imageWidth: imageWidth,
                                  tag: tag,
                                  onTap: () => router.pushNamed(
                                      AppRoutes.tagProblems.name,
                                      pathParameters: {'tagId': tag.id},
                                      extra: {'tagTitle': tag.title})),
                            );
                          },
                        ),
                      ),
                      if (state.isLoading(forr: HttpStates.PROBLEM_TAGS_PAGE))
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SpinKitThreeBounce(
                            color: theme.primaryColor,
                            size: 24,
                          ),
                        ))
                      else if (state.isError(
                          forr: HttpStates.PROBLEM_TAGS_PAGE))
                        Center(
                            child: RetryAgain(
                                onRetry: () => _loadTags(pageNo: tagsPageNo),
                                error: state.getError(
                                    forr: HttpStates.PROBLEM_TAGS_PAGE)!))
                    ],
                  );
                },
              ),
            ),
            const BannerAdd()
          ],
        ));
  }

  void _loadTags({required int pageNo}) {
    bloc.add(FetchProblemTagsPage(pageNo: pageNo));
  }

  void _loadNextPage() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    // Calculate the scroll percentage
    double scrollPercentage = currentScrollPosition / maxScrollExtent;
    // Check if scroll percentage is greater than or equal to 80%
    if (scrollPercentage <= 0.8) return;

    final totalPages = bloc.state.totalPages[HttpStates.PROBLEM_TAGS_PAGE];
    if (!bloc.state.isLoading(forr: HttpStates.PROBLEM_TAGS_PAGE) && (totalPages == null || totalPages >= tagsPageNo + 1)) {
      setState(() => _loadTags(pageNo: ++tagsPageNo));
    }
  }


  @override
  void dispose() {
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}

class TagItem extends StatelessWidget {
  final VoidCallback? onTap;

  const TagItem({
    super.key,
    required this.imageWidth,
    required this.tag,
    this.onTap,
  });

  final double imageWidth;
  final ProblemTag tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            loadingBuilder: (context, child, loadingProgress) =>SizedBox(
              width: imageWidth,
              child:loadingProgress!=null ? const Padding(
                padding: EdgeInsets.all(24.0),
                child: SpinKitCircle(color: Colors.blueAccent,size: 24,),
              ):child,
            ),
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: imageWidth,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Icon(Icons.error, color: Colors.red),
                ),
              );
            },
            tag.imageUrl,
            fit: BoxFit.contain,
            width: imageWidth,
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    tag.description ?? '',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
