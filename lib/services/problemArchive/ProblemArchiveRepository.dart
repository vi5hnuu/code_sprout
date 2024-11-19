import 'package:code_sprout/models/ApiResponse.dart';
import 'package:code_sprout/models/Pageable.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/services/apis/ProblemArchiveApi.dart';
import 'package:dio/dio.dart';

import 'ProblemArchiveService.dart';

class ProblemArchiveRepository implements ProblemArchiveService {
  final ProblemArchiveApi _problemArchiveApi;
  static final ProblemArchiveRepository _instance = ProblemArchiveRepository._();

  ProblemArchiveRepository._() : _problemArchiveApi = ProblemArchiveApi();
  factory ProblemArchiveRepository() => _instance;

  @override
  Future<ApiResponse<Pageable<ProblemArchive>>> getProblemsInfoPage({required pageNo, required pageSize, CancelToken? cancelToken}) async {
    final res = await _problemArchiveApi.getProblemsInfoPage(pageNo: pageNo,pageSize:pageSize, cancelToken: cancelToken);
    return ApiResponse<Pageable<ProblemArchive>>(success: res['success'], data: ProblemArchive.fromJson(res['data']));
  }
}
