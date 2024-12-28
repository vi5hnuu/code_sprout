import 'dart:convert';

import 'package:code_sprout/constants/Constants.dart';
import 'package:code_sprout/models/enums/ProblemDifficulty.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class EditorApi {
  static final EditorApi _instance = EditorApi._();
  static const String _executeApi = "${Constants.compilersBaseUrl}/execute"; //GET

  EditorApi._();
  factory EditorApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> executeCode({required String language,required String code,CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.post(_executeApi,data:jsonEncode({"language":language,"code":code}),cancelToken:cancelToken);
    return res.data;
  }
}
