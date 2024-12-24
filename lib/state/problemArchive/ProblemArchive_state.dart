part of 'ProblemArchive_bloc.dart';

@Immutable("cannot modify ProblemArchiveState state")
class ProblemArchiveState extends Equatable with WithHttpState {
  final Map<ProblemLanguage,Map<int,Map<String,ProblemArchive>>> problemsInfo; //{language->page,{id->problem}}
  final Map<int,Map<String,ProblemTag>> tagsInfo; //page,{tagId->tag}
  final Map<String,Map<int,Map<String,ProblemArchive>>> tagProblems;//{ tagId -> { pageNo -> { problemId -> problem } } }
  static const pageSize=10;
  final Map<String,int> totalPages;
  final Map<ProblemLanguage,ProblemDifficulty?> selectedDifficulty;

  ProblemArchiveState._({
    Map<String,HttpState>? httpStates,
    this.problemsInfo=const {},
    this.totalPages=const {},
    this.tagsInfo=const {},
    this.tagProblems=const {},
    this.selectedDifficulty=const {},
  }){
    this.httpStates.addAll(httpStates ?? {});
  }

  ProblemArchiveState.initial() : this._();

  ProblemArchiveState copyWith({
    Map<String, HttpState>? httpStates,
    Map<ProblemLanguage,Map<int,Map<String,ProblemArchive>>>? problemsInfo,
    Map<String,int>? totalPages,
    Map<int,Map<String,ProblemTag>>? tags,
    Map<String,Map<int,Map<String,ProblemArchive>>>? tagProblems,
    Map<ProblemLanguage,ProblemDifficulty?>? selectedDifficulty
  }) {
    return ProblemArchiveState._(
      httpStates: httpStates ?? this.httpStates,
      problemsInfo: problemsInfo ?? this.problemsInfo,
      totalPages: totalPages ?? this.totalPages,
      tagsInfo: tags ?? tagsInfo,
      tagProblems: tagProblems ?? this.tagProblems,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty
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

  ProblemArchive? getProblemInfoById({String? tagId,required ProblemLanguage language,required String problemId}){
    if(tagId!=null){
      if(!tagProblems.containsKey(tagId)) return null;
      for(final tagProblemPageWise in tagProblems[tagId]!.entries){
        if(!tagProblemPageWise.value.containsKey(problemId)) continue;
        return tagProblemPageWise.value[problemId];
      }
    }else{
      if(problemsInfo[language]==null) return null;
      for(final problemsPage in problemsInfo[language]!.entries){
        if(!problemsPage.value.containsKey(problemId)) continue;
        return problemsPage.value[problemId];
      }
    }
    return null;
  }

  ProblemArchive? getProblemInfo({required ProblemLanguage language,required int pageNo,required String problemId}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return problemsInfo[language]?[pageNo]?[problemId];
  }

  List<ProblemTag> getTags() {
    return tagsInfo.values.map((tags)=>tags.values).expand((tags)=>tags).toList();
  }

  List<ProblemArchive> getTagProblems({required String tagId}){
    return (tagProblems[tagId] ?? {}).values.map((tagProblems) => tagProblems.values).expand((problems) => problems).toList();
  }

  @override
  List<Object?> get props => [httpStates, problemsInfo, totalPages,selectedDifficulty,tagsInfo,tagProblems];

}
