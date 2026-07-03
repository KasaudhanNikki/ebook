import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../../domain/entities/ebook.dart';
import '../../domain/repositories/ebook_repository.dart';
import '../models/ebook_model.dart';

class EbookRepositoryImpl implements EbookRepository {
  final DioClient _dioClient;

  /// true = Mock
  /// false = Ruby API
  final bool useMock;

  EbookRepositoryImpl(this._dioClient, {this.useMock = true});

  /// -----------------------------
  /// MOCK DATABASE
  /// -----------------------------

  final List<EbookModel> _mockDatabase = [
    const EbookModel(
      id: 1,
      title: 'Flutter Clean Architecture',
      author: 'Reso Coder',
      filename: 'flutter_clean_arch.pdf',
      pdfUrl: 'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf',
    ),
    const EbookModel(
      id: 2,
      title: 'Dart Programming',
      author: 'Google',
      filename: 'dart_programming.pdf',
      pdfUrl: 'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf',
    ),
    const EbookModel(
      id: 3,
      title: 'C Programming',
      author: 'Google',
      filename: 'c_programming.pdf',
      pdfUrl:
          'https://www.cimat.mx/ciencia_para_jovenes/bachillerato/libros/%5BKernighan-Ritchie%5DThe_C_Programming_Language.pdf',
    ),
  ];

  int _nextId = 3;

  @override
  Future<List<Ebook>> getEbooks({String query = ''}) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));

      if (query.trim().isEmpty) {
        return List.from(_mockDatabase);
      }

      final search = query.toLowerCase().trim();

      return _mockDatabase.where((ebook) {
        return ebook.title.toLowerCase().contains(search) ||
            ebook.author.toLowerCase().contains(search) ||
            ebook.filename.toLowerCase().contains(search);
      }).toList();
    }

    // ==========================
    // REAL API
    // ==========================

    try {
      final response = await _dioClient.dio.get(
        "/ebooks",
        queryParameters: {"search": query},
      );

      final List data = response.data;

      return data.map((e) => EbookModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? e.message);
    }
  }

  @override
  Future<Ebook> uploadEbook(String title, String author, File pdfFile) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));

      final ebook = EbookModel(
        id: _nextId++,
        title: title,
        author: author,
        filename: pdfFile.path.split('/').last,
        pdfUrl: pdfFile.path,
      );

      _mockDatabase.add(ebook);

      return ebook;
    }

    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "author": author,
        "file": await MultipartFile.fromFile(
          pdfFile.path,
          filename: pdfFile.path.split('/').last,
        ),
      });

      final response = await _dioClient.dio.post("/ebooks", data: formData);

      return EbookModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? e.message);
    }
  }

  @override
  Future<void> deleteEbook(int id) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 700));

      _mockDatabase.removeWhere((e) => e.id == id);

      return;
    }

    // ==========================
    // REAL API
    // ==========================

    try {
      await _dioClient.dio.delete("/ebooks/$id");
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? e.message);
    }
  }
}
