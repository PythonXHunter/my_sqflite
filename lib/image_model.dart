class ImageModel {
  int? id;
  final String filePath;
  final String fileName;
  final DateTime dateAdded;

  ImageModel({this.id,
    required this.filePath,
    required this.fileName,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_path': filePath,
      'file_name': fileName,
      'date_added': dateAdded.toIso8601String(),
    };
  }

  static ImageModel fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      filePath: map['file_path'],
      fileName: map['file_name'],
      dateAdded: DateTime.parse(map['date_added']),
    );
  }
}
