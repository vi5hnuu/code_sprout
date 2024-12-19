import 'package:code_sprout/constants/Constants.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ProblemArchiveApi {
  static final ProblemArchiveApi _instance = ProblemArchiveApi._();
  static const String _problemsInfoPage = "${Constants.baseUrl}/problem/all/info"; //GET

  ProblemArchiveApi._();
  factory ProblemArchiveApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getProblemsInfoPage({required int pageNo,required int pageSize,CancelToken? cancelToken, ProblemLanguage? language, ProblemCategory? category}) async {
    var url = '$_problemsInfoPage?pageNo=$pageNo&pageSize=$pageSize';
    if(language!=null) url+='&language=${language.value}';
    if(category!=null) url+='&difficultyLevel=${category.value}';
    var res = await DioSingleton().dio.get(url,cancelToken:cancelToken);
    return res.data;
  }
}
