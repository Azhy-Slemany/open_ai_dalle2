class GeneratedImage {
  final List<String> images;
  final bool isCreated;
  final String? error;

  GeneratedImage({required this.images, required this.isCreated, this.error});

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error'))
      return GeneratedImage(
          images: [], isCreated: false, error: json['error']['message']);

    final imageUrls = json['data'] as List<dynamic>;
    return GeneratedImage(
        images: imageUrls.map((url) {
          final dict = url as Map<dynamic, dynamic>;
          return dict['url']! as String;
        }).toList(),
        isCreated: true);
  }
}
