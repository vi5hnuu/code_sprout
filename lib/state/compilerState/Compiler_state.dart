part of 'compiler_bloc.dart';

@Immutable("cannot modify ProblemArchiveState state")
class CompilerState extends Equatable with WithHttpState {
  final CompilerResponse? response;

  CompilerState._({
    this.response,
    Map<String,HttpState>? httpStates,
  }){
    this.httpStates.addAll(httpStates ?? {});
  }

  CompilerState.initial() : this._();

  CompilerState copyWith({
    CompilerResponse? res,
    Map<String, HttpState>? httpStates,
  }) {
    return CompilerState._(
      response: res,
      httpStates: httpStates ?? this.httpStates,
    );
  }

  MapEntry<String, ProblemArchive> getEntry(ProblemArchive problem) => MapEntry(problem.id, problem);

  @override
  List<Object?> get props => [httpStates,response];

}
