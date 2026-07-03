import 'dart:io';
import 'package:get/get.dart';
import '../../domain/entities/ebook.dart';
import '../../domain/repositories/ebook_repository.dart';
import 'dart:async';

class EbookController extends GetxController {
  final EbookRepository _repository;

  EbookController(this._repository);

  var ebooks = <Ebook>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Timer? _debounce;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEbooks();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchEbooks();
    });
  }

  Future<void> fetchEbooks() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getEbooks(query: searchQuery.value);
      ebooks.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> uploadEbook(String title, String author, File file) async {
    try {
      isLoading(true);
      await _repository.uploadEbook(title, author, file);
      fetchEbooks();

      /// refresh list
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteEbook(int id) async {
    try {
      isLoading(true);
      await _repository.deleteEbook(id);
      ebooks.removeWhere((element) => element.id == id);
      Get.snackbar(
        'Success',
        'Ebook deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
