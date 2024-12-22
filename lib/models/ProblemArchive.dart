import 'package:code_sprout/models/ProblemPlatform.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';

class ProblemArchive {
  final String id;
  final String title;
  final String? description;
  final ProblemLanguage language;
  final ProblemDifficulty difficulty;
  final String filePath;
  final List<ProblemPlatform> platforms;

  ProblemArchive({required this.id,
      required this.title,
      this.description,
      required this.language,
      required this.difficulty,
      required this.filePath,
      required this.platforms});

  factory ProblemArchive.fromJson(Map<String, dynamic> json) {
    return ProblemArchive(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        language: ProblemLanguage.fromValue(json['language'] as String) ?? ProblemLanguage.CPP,
        difficulty: ProblemDifficulty.fromValue(json['difficulty'] as String) ?? ProblemDifficulty.EASY,
        filePath: json['file_path'] as String,
        platforms: (json['platforms'] as List).map((platform)=>ProblemPlatform.fromJson(platform)).toList());
  }
}
