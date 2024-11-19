class ErrorModel{
  final String message;
  final int? statusCode;

  ErrorModel({required this.message,this.statusCode});
}

class HttpState<T>{
  final bool? loading;
  final ErrorModel? error;
  final T? value;

  const HttpState._({this.loading=false,this.error,this.value}):assert(loading!=null || error!=null || value!=null);
  const HttpState.loading():this._(loading: true);
  const HttpState.error({required ErrorModel? error}):this._(error: error);
  const HttpState.value({required T value}):this._(value: value);
}