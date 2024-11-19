import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:code_sprout/models/enums/ProblemLanguage.dart';

class ProblemArchive {
  final String id;
  final String title;
  final String? description;
  final ProblemLanguage language;
  final ProblemCategory category;
  final String filePath;

  ProblemArchive({required this.id,
      required this.title,
      this.description,
      required this.language,
      required this.category,
      required this.filePath});

  static fromJson(Map<String, dynamic> json) {
    return ProblemArchive(
        id: json['id'] as String,
        title: json['title'] as String,
        language: json['language'] as ProblemLanguage,
        category: json['category'] as ProblemCategory,
        filePath: json['filePath'] as String);
  }
}
