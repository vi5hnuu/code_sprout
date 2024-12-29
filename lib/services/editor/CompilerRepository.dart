import 'package:code_sprout/models/CompilerResponse.dart';
import 'package:code_sprout/services/apis/EditorApi.dart';
import 'package:dio/dio.dart';

import 'CompilerService.dart';

class CompilerRepository implements CompilerService {
  final EditorApi _editorApi;
  static final CompilerRepository _instance = CompilerRepository._();

  CompilerRepository._() : _editorApi = EditorApi();
  factory CompilerRepository() => _instance;
  
  @override
  Future<CompilerResponse> executeCode({required String language, required String code, CancelToken? cancelToken}) async {
    final res = await _editorApi.executeCode(language: language,code: code, cancelToken: cancelToken);
    return CompilerResponse(executionTime: res['executionTime'] as int,result: res['result'],error: res['error']);
  }
}
