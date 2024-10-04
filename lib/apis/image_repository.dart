import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_data.dart';
import 'service/api_service.dart';


final searchQueryProvider = StateProvider<String>((ref) => '');


class ImageNotifier extends StateNotifier<List<ImageData>> {

  ImageNotifier(this.ref) : super([]) {
    fetchInitialImages();
  }

  final Ref ref;


  int _page = 1;


  bool _isLoading = false;


  Future<void> fetchInitialImages() async {
    _resetPaginationAndState();


    for (int i = 0; i < 3; i++) {
      await fetchImages(isLoadMore: true);
    }
  }


  Future<void> fetchImages({bool isLoadMore = false}) async {
    if (_isLoading) return;


    _isLoading = true;

    final query = ref.read(searchQueryProvider);


    try {
      final newImages =
          await ApiService().fetchImages(query: query, page: _page);
      state = isLoadMore ? [...state, ...newImages] : newImages;


      _page++;

    } catch (e) {

      _handleError(e);
    } finally {
      _isLoading = false;

    }
  }


  void reset() {
    _resetPaginationAndState();
    fetchInitialImages();
  }


  void fetchNextPage() {
    fetchImages(isLoadMore: true);
  }


  void _resetPaginationAndState() {
    _page = 1;
    state = [];
  }


  void _handleError(Object error) {

    debugPrint('Error fetching images: $error');
  }
}

final imageProvider =
    StateNotifierProvider<ImageNotifier, List<ImageData>>((ref) {
  return ImageNotifier(ref);
});
