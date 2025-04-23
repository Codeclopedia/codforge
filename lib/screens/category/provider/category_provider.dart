import 'package:codforge_assignment/core/service/network_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/category.dart';

enum CategoryStatus { loading, success, error, empty, loadingMore }

class CategoryState {
  final List<Category> categories;
  final CategoryStatus status;
  final String? errorMessage;
  final bool hasMore;

  const CategoryState({
    this.categories = const [],
    this.status = CategoryStatus.loading,
    this.errorMessage,
    this.hasMore = true,
  });

  const CategoryState.initial()
      : categories = const [],
        status = CategoryStatus.loading,
        errorMessage = null,
        hasMore = true;

  bool get isLoading =>
      status == CategoryStatus.loading || status == CategoryStatus.loadingMore;

  CategoryState copyWith({
    List<Category>? categories,
    CategoryStatus? status,
    String? errorMessage,
    bool? hasMore,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState.initial()) {
    loadCategories();
  }

  int _currentPage = 1;
  bool _isLoading = false;

  Future<void> loadCategories() async {
    if (_isLoading || !state.hasMore) return;
    _isLoading = true;

    try {
      final categories = await NetworkService().loadDataFromApi(_currentPage);

      if (categories == null || categories.isEmpty) {
        state = state.copyWith(hasMore: false);
      } else {
        state = state.copyWith(
          categories: [...state.categories, ...categories],
          status: CategoryStatus.success,
        );

        _currentPage++;
      }
    } catch (e) {
      state = state.copyWith(
        status: CategoryStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      _isLoading = false;
    }
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(),
);
