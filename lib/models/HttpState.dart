class HttpState<T>{
  final bool? loading;
  final String? error;
  final T? value;

  const HttpState._({this.loading=false,this.error,this.value}):assert(loading!=null || error!=null || value!=null);
  const HttpState.loading():this._(loading: true);
  const HttpState.error({required String? error}):this._(error: error);
  const HttpState.done({T? value}):this._(value: value);
}