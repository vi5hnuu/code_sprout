part of 'ProblemArchive_bloc.dart';

@Immutable("cannot modify aarti state")
class ProblemArchiveState extends Equatable with WithHttpState {
  final Map<int,Map<String,ProblemArchive>> problemsInfo; //page,{id->problem}
  static const pageSize=20;
  final int? totalPages;

  ProblemArchiveState._({
    Map<String,HttpState>? httpStates,
    this.problemsInfo=const {},
    this.totalPages,
  }){
    this.httpStates.addAll(httpStates ?? {});
  }

  ProblemArchiveState.initial() : this._(
          httpStates: const {},
          problemsInfo: const {},
          totalPages: 0
        );

  ProblemArchiveState copyWith({
    Map<String, HttpState>? httpStates,
    Map<int, Map<String,ProblemArchive>>? problemsInfo,
    int? totalPages
  }) {
    return ProblemArchiveState._(
      httpStates: httpStates ?? this.httpStates,
      problemsInfo: problemsInfo ?? this.problemsInfo,
      totalPages: totalPages ?? this.totalPages
    );
  }

  MapEntry<String, ProblemArchive> getEntry(ProblemArchive problem) => MapEntry(problem.id, problem);

  int getProblemCount() {
    if(problemsInfo.isEmpty) return 0;
    return (problemsInfo.entries.length-1)*pageSize+problemsInfo.entries.last.value.length;
  }

  hasProblemsInfoPage({required int pageNo}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return problemsInfo.containsKey(pageNo);
  }

  bool canLoadNextPage({required int pageNo}) {
    assert(pageNo>=1);

    if(pageNo>1 && totalPages==null) throw Exception("total pages not initialized");
    if(isLoading(forr: HttpStates.PROBLEMS_INFO_PAGE) || problemsInfo.containsKey(pageNo) || (pageNo>1 && pageNo>totalPages!) ) return false;
    return true;
  }


  ProblemArchive? getProblemInfoById({required String problemId}){
    for(final problemsPage in problemsInfo.entries){
      if(!problemsPage.value.containsKey(problemId)) continue;
      return problemsPage.value[problemId];
    }
    return null;
  }

  ProblemArchive? getProblemInfo({required int pageNo,required String problemId}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return problemsInfo[pageNo]?[problemId];
  }

  @override
  List<Object?> get props => [httpStates, problemsInfo, totalPages];



}
