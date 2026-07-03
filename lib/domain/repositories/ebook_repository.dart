import 'dart:io';
import '../entities/ebook.dart';

abstract class EbookRepository {
  Future<List<Ebook>> getEbooks({String query = ''});
  Future<Ebook> uploadEbook(String title, String author, File pdfFile);
  Future<void> deleteEbook(int id);
}
