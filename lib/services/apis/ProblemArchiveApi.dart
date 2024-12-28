import 'package:code_sprout/constants/Constants.dart';
import 'package:code_sprout/models/enums/ProblemDifficulty.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ProblemArchiveApi {
  static final ProblemArchiveApi _instance = ProblemArchiveApi._();
  static const String _problemsInfoPage = "${Constants.baseUrl}/problem/all/info"; //GET
  static const String _problemTagsPage = "${Constants.baseUrl}/tags/info"; //GET
  static const String _tagProblemsPage = "${Constants.baseUrl}/tag/{tagId}/problems"; //GET

  ProblemArchiveApi._();
  factory ProblemArchiveApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getProblemsInfoPage({required int pageNo,required int pageSize,CancelToken? cancelToken, ProblemLanguage? language, ProblemDifficulty? difficulty}) async {
    var url = '$_problemsInfoPage?pageNo=$pageNo&pageSize=$pageSize';
    if(language!=null) url+='&language=${language.value}';
    if(difficulty!=null) url+='&difficultyLevel=${difficulty.value}';
    var res = await DioSingleton().dio.get(url,cancelToken:cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getProblemTagsPage({required int pageNo,required int pageSize,CancelToken? cancelToken}) async {
    var url = '$_problemTagsPage?pageNo=$pageNo&pageSize=$pageSize';
    var res = await DioSingleton().dio.get(url,cancelToken:cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getTagProblemsPage({required String tagId,required int pageNo,required int pageSize,CancelToken? cancelToken}) async {
    var url = '$_tagProblemsPage?pageNo=$pageNo&pageSize=$pageSize';
    url=url.replaceFirst('{tagId}', tagId);
    var res = await DioSingleton().dio.get(url,cancelToken:cancelToken);
    return res.data;
  }
}
