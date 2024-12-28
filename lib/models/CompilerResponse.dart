class CompilerResponse {
  final String? result;
  final String? error;
  const CompilerResponse({this.result,this.error}):assert(result!=null || error!=null);
}
