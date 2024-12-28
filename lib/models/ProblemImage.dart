class ProblemImage {
    final String title;
    final String src;

    const ProblemImage({required this.title,required this.src});

    factory ProblemImage.fromJson(Map<String, dynamic> json) {
        return ProblemImage(
            title: json['title'] as String,
            src: json['src'] as String);
    }
}
