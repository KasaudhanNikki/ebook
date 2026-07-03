import '../../domain/entities/ebook.dart';

class EbookModel extends Ebook {
  const EbookModel({
    required int id,
    required String title,
    required String author,
    required String filename,
    required String pdfUrl,
  }) : super(
          id: id,
          title: title,
          author: author,
          filename: filename,
          pdfUrl: pdfUrl,
        );

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      filename: json['filename'],
      pdfUrl: json['pdf_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filename': filename,
      'pdf_url': pdfUrl,
    };
  }
}
