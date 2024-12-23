import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/map-entensions.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/ProblemTag.dart';
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

class ProblemArchiveBloc
    extends Bloc<ProblemArchiveEvent, ProblemArchiveState> {
  ProblemArchiveBloc(
      {required ProblemArchiveRepository problemsArchiveRepository})
      : super(ProblemArchiveState.initial()) {
    on<FetchProblemInfoPage>((event, emit) async {
      if (event.difficulty != state.selectedDifficulty[event.language]) {
        if (event.pageNo != 1) throw Exception("Page no should be 1 as difficulty changed");
        emit(state.copyWith(problemsInfo: state.problemsInfo.clone()..remove(event.language), selectedDifficulty: state.selectedDifficulty.clone(withh: MapEntry(event.language, event.difficulty)), httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, const HttpState.loading())));
      } else if (state.hasProblemsInfoPage(language: event.language, pageNo: event.pageNo)) {
        return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      } else {
        emit(state.copyWith(selectedDifficulty: state.selectedDifficulty.clone(withh: MapEntry(event.language,event.difficulty)),httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, const HttpState.loading())));
      }
      try {
        final problemsInfoPage = await problemsArchiveRepository.getProblemsInfoPage(pageNo: event.pageNo, pageSize: ProblemArchiveState.pageSize, language: event.language, difficulty: event.difficulty, cancelToken: event.cancelToken);
        final problemsInfo = state.problemsInfo.clone();
        if (problemsInfo[event.language] == null) problemsInfo[event.language] = {};
        problemsInfo[event.language]!.put(event.pageNo, LinkedHashMap.fromEntries(problemsInfoPage.data!.data.map((problem) => state.getEntry(problem))));
        emit(state.copyWith(problemsInfo: problemsInfo, totalPages: state.totalPages.clone(withh: MapEntry(event.language.value, problemsInfoPage.data!.totalPages)),httpStates: state.httpStates.clone()..remove(HttpStates.PROBLEMS_INFO_PAGE)));
      } on DioException catch (e) {
        emit(state.copyWith(
            httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE, HttpState.error(error: e.toString()))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEMS_INFO_PAGE,HttpState.error(error: e.toString()))));
      }
    });

    on<FetchProblemTagsPage>((event, emit) async {
      if (state.tagsInfo[event.pageNo] != null) return emit(state.copyWith());
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEM_TAGS_PAGE, const HttpState.loading())));
        final problemTagsPage =
            await problemsArchiveRepository.getProblemTagsPage(pageNo: event.pageNo, pageSize: ProblemArchiveState.pageSize, cancelToken: event.cancelToken);
        emit(state.copyWith(
            totalPages: state.totalPages.clone(withh: MapEntry(HttpStates.PROBLEM_TAGS_PAGE, problemTagsPage.data!.totalPages)),
            tags: state.tagsInfo.clone(withh: MapEntry(event.pageNo,LinkedHashMap.fromEntries(problemTagsPage.data!.data.map((tag) => MapEntry(tag.id, tag))))),
            httpStates: state.httpStates.clone()..put(HttpStates.PROBLEM_TAGS_PAGE, const HttpState.done())));
      } on DioException catch (e) {
        emit(state.copyWith(
            httpStates: state.httpStates.clone()..put(HttpStates.PROBLEM_TAGS_PAGE, HttpState.error(error: e.toString()))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.PROBLEM_TAGS_PAGE,HttpState.error(error: e.toString()))));
      }
    });

    on<FetchTagProblemsPage>((event, emit) async {
      // if (state.tagsInfo[event.pageNo] != null) return emit(state.copyWith());
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.TAG_PROBLEMS_PAGE, const HttpState.loading())));
        final tagProblemsPage = await problemsArchiveRepository.getTagProblemsPage(tagId: event.tagId, pageNo: event.pageNo, pageSize: ProblemArchiveState.pageSize, cancelToken: event.cancelToken);

        final tagProblems=state.tagProblems.clone();
        if(!tagProblems.containsKey(event.tagId)) tagProblems.put(event.tagId, {});
        tagProblems[event.tagId]!.put(event.pageNo, LinkedHashMap.fromEntries(tagProblemsPage.data!.data.map((tagProblem) => MapEntry(tagProblem.id, tagProblem))));
        emit(state.copyWith(totalPages: state.totalPages.clone()..put(HttpStates.TAG_PROBLEMS_PAGE, tagProblemsPage.data!.totalPages), tagProblems: tagProblems, httpStates: state.httpStates.clone()..put(HttpStates.TAG_PROBLEMS_PAGE, const HttpState.done())));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.TAG_PROBLEMS_PAGE, HttpState.error(error: e.toString()))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.TAG_PROBLEMS_PAGE, HttpState.error(error: e.toString()))));
      }
    });
  }
}
