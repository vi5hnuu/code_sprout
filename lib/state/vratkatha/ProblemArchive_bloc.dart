import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/map-entensions.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/services/problemArchive/ProblemArchiveRepository.dart';
import 'package:code_sprout/state/WithHttpState.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/HttpState.dart';
part 'vratKatha_event.dart';
part 'ProblemArchive_state.dart';

class ProblemArchiveBloc extends Bloc<ProblemArchiveEvent, ProblemArchiveState> {
  ProblemArchiveBloc({required ProblemArchiveRepository problemsArchiveRepository}) : super(ProblemArchiveState.initial()) {

    on<FetchProblemInfoPage>((event,emit)async{
       if (state.hasProblemsInfoPage(pageNo: event.pageNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE,const HttpState.loading())));
      try {
        final problemsInfoPage = await problemsArchiveRepository.getProblemsInfoPage(pageNo: event.pageNo,pageSize: ProblemArchiveState.pageSize,cancelToken: event.cancelToken);

        final problemsInfo=state.problemsInfo.clone(withh: MapEntry(event.pageNo, LinkedHashMap.fromEntries(problemsInfoPage.data!.data.map((problem)=>state.getEntry(problem)))));
        emit(state.copyWith(problemsInfo: problemsInfo,totalPages: problemsInfoPage.data!.totalPages,httpStates:state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, HttpState.error(error: ErrorModel(message: e.message ?? "something went wrong")))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, HttpState.error(error: ErrorModel(message: e.toString())))));
      }
    });
  }
}
