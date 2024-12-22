import 'package:code_sprout/models/ApiResponse.dart';
import 'package:code_sprout/models/Pageable.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/ProblemTag.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';
import 'package:dio/dio.dart';

abstract class ProblemArchiveService {
  Future<ApiResponse<Pageable<ProblemArchive>>> getProblemsInfoPage({required pageNo,required pageSize,ProblemLanguage? language,CancelToken? cancelToken});
  Future<ApiResponse<Pageable<ProblemTag>>> getProblemTagsPage({required pageNo,required pageSize,CancelToken? cancelToken});
  Future<ApiResponse<Pageable<ProblemArchive>>> getTagProblemsPage({required String tagId,required pageNo,required pageSize,CancelToken? cancelToken});
}
