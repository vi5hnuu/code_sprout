part of 'compiler_bloc.dart';

@immutable
abstract class CompilerEvent {
  final CancelToken? cancelToken;
  const CompilerEvent({this.cancelToken});
}

class ExecuteCode extends CompilerEvent {
  final String language;
  final String code;
  const ExecuteCode({required this.language,required this.code,super.cancelToken});
}