import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solar/core/notifier/current_user_notifier.dart';
import 'package:solar/features/home/model/project_model.dart';
import 'package:solar/features/home/repository/home_repository.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<ProjectModel>> fetchProducts(
  FetchProductsRef ref,
) async {
  final homeRepository = ref.read(homeRepositoryProvider);
  final token = ref.read(currentUserNotifierProvider)!.token;

  final res = await homeRepository.getProducts(token: token);

  return res.match(
    (l) => throw Exception(l.message),
    (r) => r,
  );
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }
}
