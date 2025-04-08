class Podcast {
  final String audio;
  final String image;
  final String title;
  final String id;

  const Podcast({
    required this.audio,
    required this.image,
    required this.title,
    required this.id,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    audio: json['audio'] ?? '',
    image: json['image'] ?? '',
    title: json['title_original'] ?? json['title'] ?? '',
    id: json['id'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'audio': audio,
    'image': image,
    'title_original': title,
    'id': id,
  };
}
