import 'package:code_sprout/models/ApiResponse.dart';
import 'package:code_sprout/models/Pageable.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/ProblemTag.dart';
import 'package:code_sprout/models/enums/ProblemDifficulty.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:code_sprout/services/apis/ProblemArchiveApi.dart';
import 'package:dio/dio.dart';

import 'ProblemArchiveService.dart';

class ProblemArchiveRepository implements ProblemArchiveService {
  final ProblemArchiveApi _problemArchiveApi;
  static final ProblemArchiveRepository _instance = ProblemArchiveRepository._();

  ProblemArchiveRepository._() : _problemArchiveApi = ProblemArchiveApi();
  factory ProblemArchiveRepository() => _instance;

  @override
  Future<ApiResponse<Pageable<ProblemArchive>>> getProblemsInfoPage({required pageNo, required pageSize, CancelToken? cancelToken, ProblemLanguage? language, ProblemDifficulty? difficulty}) async {
    final res = await _problemArchiveApi.getProblemsInfoPage(pageNo: pageNo,pageSize:pageSize,language:language,difficulty:difficulty, cancelToken: cancelToken);
    final pageableRaw=res['data'];//pageable
    return ApiResponse<Pageable<ProblemArchive>>(success: res['success'], data:Pageable(data: (pageableRaw['data'] as List).map((problem)=>ProblemArchive.fromJson(problem)).toList(), pageNo: pageableRaw['pageNo'] as int, totalPages: pageableRaw['totalPages'] as int));
  }

  @override
  Future<ApiResponse<Pageable<ProblemTag>>> getProblemTagsPage({required pageNo, required pageSize, CancelToken? cancelToken}) async {
    final res = await _problemArchiveApi.getProblemTagsPage(pageNo: pageNo,pageSize:pageSize,cancelToken: cancelToken);
    final pageableRaw=res['data'];//pageable
    return ApiResponse<Pageable<ProblemTag>>(success: res['success'], data:Pageable(data: (pageableRaw['data'] as List).map((tag)=>ProblemTag.fromJson(tag)).toList(), pageNo: pageableRaw['pageNo'] as int, totalPages: pageableRaw['totalPages'] as int));
  }

  @override
  Future<ApiResponse<Pageable<ProblemArchive>>> getTagProblemsPage({required String tagId, required pageNo, required pageSize, CancelToken? cancelToken}) async {
    final res = await _problemArchiveApi.getTagProblemsPage(tagId: tagId,pageNo: pageNo,pageSize:pageSize, cancelToken: cancelToken);
    final pageableRaw=res['data'];//pageable
    return ApiResponse<Pageable<ProblemArchive>>(success: res['success'], data:Pageable(data: (pageableRaw['data'] as List).map((problem)=>ProblemArchive.fromJson(problem)).toList(), pageNo: pageableRaw['pageNo'] as int, totalPages: pageableRaw['totalPages'] as int));
  }
}
