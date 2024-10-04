
class ImageData {
  final int id;
  final String url;
  final int likes;
  final int views;
  final String title;

  ImageData({
    required this.id,
    required this.url,
    required this.likes,
    required this.views,
    required this.title,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      url: json['webformatURL'],
      likes: json['likes'],
      views: json['views'],
      title: json['tags'],
    );
  }
}
