part of 'ProblemArchive_bloc.dart';

@immutable
abstract class ProblemArchiveEvent {
  final CancelToken? cancelToken;
  const ProblemArchiveEvent({this.cancelToken});
}

class FetchProblemInfoPage extends ProblemArchiveEvent {
  final int pageNo;
  final ProblemLanguage language;
  final ProblemCategory? category;
  const FetchProblemInfoPage({required this.pageNo,super.cancelToken, required this.language,this.category});
}