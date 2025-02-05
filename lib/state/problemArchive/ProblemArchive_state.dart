part of 'ProblemArchive_bloc.dart';

@Immutable("cannot modify ProblemArchiveState state")
class ProblemArchiveState extends Equatable with WithHttpState {
  final Map<ProblemLanguage,Map<int,Map<String,ProblemArchive>>> problemsInfo; //{language->page,{id->problem}}
  static const pageSize=20;
  final Map<ProblemLanguage,int> totalPages;
  final Map<ProblemLanguage,ProblemCategory?> selectedCategory;

  ProblemArchiveState._({
    Map<String,HttpState>? httpStates,
    this.problemsInfo=const {},
    this.totalPages=const {},
    this.selectedCategory=const {},
  }){
    this.httpStates.addAll(httpStates ?? {});
  }

  ProblemArchiveState.initial() : this._(
          httpStates: const {},
          problemsInfo: const {},
          totalPages: {}
        );

  ProblemArchiveState copyWith({
    Map<String, HttpState>? httpStates,
    Map<ProblemLanguage,Map<int,Map<String,ProblemArchive>>>? problemsInfo,
    Map<ProblemLanguage,int>? totalPages,
    Map<ProblemLanguage,ProblemCategory?>? selectedCategory
  }) {
    return ProblemArchiveState._(
      httpStates: httpStates ?? this.httpStates,
      problemsInfo: problemsInfo ?? this.problemsInfo,
      totalPages: totalPages ?? this.totalPages,
      selectedCategory: selectedCategory ?? this.selectedCategory
    );
  }

  MapEntry<String, ProblemArchive> getEntry(ProblemArchive problem) => MapEntry(problem.id, problem);

  int getProblemCount({required ProblemLanguage language}) {
    if(problemsInfo.isEmpty || problemsInfo[language]==null) return 0;
    return (problemsInfo[language]!.entries.length-1)*pageSize+problemsInfo[language]!.entries.last.value.length;
  }

  hasProblemsInfoPage({required ProblemLanguage language,required int pageNo}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return problemsInfo[language]?.containsKey(pageNo)==true;
  }

  List<MapEntry<String,ProblemArchive>> getProblems({required ProblemLanguage language}){
    return (problemsInfo[language] ?? {}).entries.map((pageEntry) => pageEntry.value).expand((element) => element.entries).toList();
  }

  bool canLoadNextPage({required ProblemLanguage language,required int pageNo}) {
    assert(pageNo>=1);

    if(pageNo>1 && totalPages[language]==null) throw Exception("total pages not initialized");
    if(isLoading(forr: HttpStates.PROBLEMS_INFO_PAGE) || hasProblemsInfoPage(language: language,pageNo: pageNo) || (pageNo>1 && pageNo>totalPages[language]!) ) return false;
    return true;
  }


  ProblemArchive? getProblemInfoById({required ProblemLanguage language,required String problemId}){
    if(problemsInfo[language]==null) return null;
    for(final problemsPage in problemsInfo[language]!.entries){
      if(!problemsPage.value.containsKey(problemId)) continue;
      return problemsPage.value[problemId];
    }
    return null;
  }

  ProblemArchive? getProblemInfo({required ProblemLanguage language,required int pageNo,required String problemId}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return problemsInfo[language]?[pageNo]?[problemId];
  }

  @override
  List<Object?> get props => [httpStates, problemsInfo, totalPages,selectedCategory];



}
