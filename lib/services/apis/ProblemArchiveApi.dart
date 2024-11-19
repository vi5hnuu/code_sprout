import 'package:code_sprout/constants/Constants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ProblemArchiveApi {
  static final ProblemArchiveApi _instance = ProblemArchiveApi._();
  static const String _problemsInfoPage = "${Constants.baseUrl}/problem/all/info"; //GET

  ProblemArchiveApi._();
  factory ProblemArchiveApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getProblemsInfoPage({required int pageNo,required int pageSize,CancelToken? cancelToken}) async {
    var url = '$_problemsInfoPage?pageNo=$pageNo&pageSize=$pageSize';
    var res = await DioSingleton().dio.get(url,cancelToken:cancelToken);
    return res.data;
  }
}
