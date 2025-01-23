class Photo {
  int id;
  String url;
  String title;

  Photo({required this.id, required this.url, required this.title});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'],
      title: json['title'],
    );
  }
}
