part of 'ProblemArchive_bloc.dart';

@immutable
abstract class ProblemArchiveEvent {
  final CancelToken? cancelToken;
  const ProblemArchiveEvent({this.cancelToken});
}

class FetchProblemInfoPage extends ProblemArchiveEvent {
  final int pageNo;
  const FetchProblemInfoPage({required this.pageNo,super.cancelToken});
}
