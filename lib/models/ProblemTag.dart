class ProblemTag {
    final String id;
    final String title;
    final String? description;
    final String imageUrl;

    ProblemTag({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl
  });

    factory ProblemTag.fromJson(Map<String, dynamic> json) {
        return ProblemTag(
            id: json['id'] as String,
            title: json['title'] as String,
            description: json['description'] as String?,
            imageUrl: json['image_url'] as String);
    }
}