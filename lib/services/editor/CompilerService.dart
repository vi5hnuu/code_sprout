import 'package:code_sprout/models/CompilerResponse.dart';
import 'package:dio/dio.dart';

abstract class CompilerService {
  Future<CompilerResponse> executeCode({required String language,required String code,CancelToken? cancelToken});
}
