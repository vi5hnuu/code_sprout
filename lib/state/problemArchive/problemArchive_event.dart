part of 'ProblemArchive_bloc.dart';

@immutable
abstract class ProblemArchiveEvent {
  final CancelToken? cancelToken;
  const ProblemArchiveEvent({this.cancelToken});
}

class FetchProblemInfoPage extends ProblemArchiveEvent {
  final int pageNo;
  final ProblemLanguage language;
  final ProblemDifficulty? difficulty;
  const FetchProblemInfoPage({required this.pageNo,super.cancelToken, required this.language,this.difficulty});
}

class FetchProblemTagsPage extends ProblemArchiveEvent {
  final int pageNo;
  const FetchProblemTagsPage({required this.pageNo,super.cancelToken});
}

class FetchTagProblemsPage extends ProblemArchiveEvent {
  final int pageNo;
  final String tagId;
  const FetchTagProblemsPage({required this.tagId,required this.pageNo,super.cancelToken});
}