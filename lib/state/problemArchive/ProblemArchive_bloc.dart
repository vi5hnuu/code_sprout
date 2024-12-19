import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/map-entensions.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/services/problemArchive/ProblemArchiveRepository.dart';
import 'package:code_sprout/state/WithHttpState.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/HttpState.dart';
part 'problemArchive_event.dart';
part 'ProblemArchive_state.dart';

class ProblemArchiveBloc extends Bloc<ProblemArchiveEvent, ProblemArchiveState> {
  ProblemArchiveBloc({required ProblemArchiveRepository problemsArchiveRepository}) : super(ProblemArchiveState.initial()) {

    on<FetchProblemInfoPage>((event,emit) async{
      if(event.category!=state.selectedCategory[event.language]){
        if(event.pageNo!=1) throw Exception("Page no should be 1 as category changed");
        emit(state.copyWith(problemsInfo: state.problemsInfo.clone()..remove(event.language),selectedCategory: state.selectedCategory.clone(withh: MapEntry(event.language,event.category)),httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE,const HttpState.loading())));
      }else if(state.hasProblemsInfoPage(language: event.language,pageNo: event.pageNo)){
        return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      }else{
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE,const HttpState.loading())));
      }
      try {
        final problemsInfoPage = await problemsArchiveRepository.getProblemsInfoPage(pageNo: event.pageNo,pageSize: ProblemArchiveState.pageSize,language:event.language,category:event.category,cancelToken: event.cancelToken);
        final problemsInfo=state.problemsInfo.clone();
        if(problemsInfo[event.language]==null) problemsInfo[event.language]={};
        problemsInfo[event.language]!.put(event.pageNo, LinkedHashMap.fromEntries(problemsInfoPage.data!.data.map((problem)=>state.getEntry(problem))));
        emit(state.copyWith(problemsInfo: problemsInfo,totalPages: state.totalPages.clone(withh: MapEntry(event.language, problemsInfoPage.data!.totalPages)),httpStates:state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, HttpState.error(error: ErrorModel(message: e.toString())))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, HttpState.error(error: ErrorModel(message: e.toString())))));
      }
    });
  }
}
