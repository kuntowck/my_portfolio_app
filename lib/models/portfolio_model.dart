class Portfolio {
  int? id;
  String title;
  String description;
  String category;
  List stack;
  String imageUrl;
  DateTime completionDate;
  String? projectLink;

  Portfolio({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.stack,
    required this.imageUrl,
    required this.completionDate,
    this.projectLink,
  });

  factory Portfolio.fromJson(Map<String, dynamic> data) {
    return Portfolio(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      category: data['category'],
      stack: data['stack'] != null
          ? data['stack'].split(',').map((s) => s.trim()).toList()
          : [],
      imageUrl: data['image'] ?? '',
      completionDate: DateTime.parse(data['completion_date']),
      projectLink: data['project_link'],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "category": category,
    "stack": stack.join(', '),
    "image": imageUrl,
    "completion_date": completionDate.toIso8601String().split('T').first,
    "project_link": projectLink,
  };
}
