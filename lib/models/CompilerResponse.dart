class CompilerResponse {
  final String? result;
  final String? error;
  final int executionTime;
  const CompilerResponse({required this.executionTime,this.result,this.error}):assert(result!=null || error!=null);

  executionTimeInSec(){
    return executionTime/1000;
  }
}
