import 'package:equatable/equatable.dart';

class Ebook extends Equatable {
  final int id;
  final String title;
  final String author;
  final String filename;
  final String pdfUrl;

  const Ebook({
    required this.id,
    required this.title,
    required this.author,
    required this.filename,
    required this.pdfUrl,
  });

  @override
  List<Object?> get props => [id, title, author, filename, pdfUrl];
}
