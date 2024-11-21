class ProblemPlatform {
    final String title;
    final String redirectUrl;

    ProblemPlatform({required this.title,required this.redirectUrl});

  static ProblemPlatform fromJson(dynamic json) {
      return ProblemPlatform(title: json['title'] as String,redirectUrl: json['redirect_url'] as String);
  }
}
