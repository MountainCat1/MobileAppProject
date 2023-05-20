class PostDTO {
  int userId;
  int id;
  String title;
  String body;

  PostDTO({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostDTO.fromJson(Map<String, dynamic> json) {
    return PostDTO(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  static List<PostDTO> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => PostDTO.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
  PostDTO.loading() : this(
    body: "...",
    id: -1,
    title: "...",
    userId: -1
  );

  PostDTO.empty() : this(
      body: "...",
      id: -1,
      title: "EMPTY",
      userId: -1
  );

  bool get isLoading => title == '...';
}
