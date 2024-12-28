import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:code_sprout/constants/httpStates.dart';
import 'package:code_sprout/extensions/map-entensions.dart';
import 'package:code_sprout/models/CompilerResponse.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/enums/ProblemDifficulty.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/services/editor/CompilerRepository.dart';
import 'package:code_sprout/services/problemArchive/ProblemArchiveRepository.dart';
import 'package:code_sprout/state/WithHttpState.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/HttpState.dart';
part 'Compiler_event.dart';
part 'Compiler_state.dart';

class CompilerBloc extends Bloc<CompilerEvent, CompilerState> {
  CompilerBloc({required CompilerRepository compilerRepository}) : super(CompilerState.initial()) {
    on<ExecuteCode>((event, emit) async {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.COMPILER_CODE_EXECUTION, const HttpState.loading())));
      try {
        final executionResult = await compilerRepository.executeCode(language: event.language,code: event.code, cancelToken: event.cancelToken);
        emit(state.copyWith(res:executionResult,httpStates: state.httpStates.clone()..remove(HttpStates.COMPILER_CODE_EXECUTION)));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.COMPILER_CODE_EXECUTION, HttpState.error(error: e.toString()))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(HttpStates.COMPILER_CODE_EXECUTION,HttpState.error(error: e.toString()))));
      }
    });
  }
}
