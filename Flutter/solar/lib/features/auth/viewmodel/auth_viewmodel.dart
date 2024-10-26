import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solar/core/model/user_model.dart';
import 'package:solar/core/notifier/current_user_notifier.dart';
import 'package:solar/features/auth/repository/auth_local_repository.dart';
import 'package:solar/features/auth/repository/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthRemoteRepository _authRemoteRepository;
  late final AuthLocalRepository _authLocalRepository;
  late final CurrentUserNotifier _currentUserNotifier;
  bool _isDisposed = false;

  @override
  AsyncValue<UserModel>? build() {
    // Initialization moved to the build method
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    ref.onDispose(() {
      _isDisposed = true;
    });

    return null; // Initial state
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_isDisposed) return; // Exit if disposed
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    if (_isDisposed) return; // Re-check if disposed
    res.match(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => _authSuccess(r),
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (_isDisposed) return;
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    if (_isDisposed) return;
    res.match(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => _authSuccess(r),
    );
  }

  AsyncValue<UserModel>? _authSuccess(UserModel user) {
    if (_isDisposed) return null;
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    if (_isDisposed) return null;
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);

      if (_isDisposed) return null;
      res.match(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => _getDataSuccess(r),
      );
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    if (_isDisposed) {
      return AsyncValue.error('Provider disposed', StackTrace.current);
    }
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
