import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solar/core/constant/server_constant.dart';
import 'package:solar/core/failure/failure.dart';
import 'package:solar/core/model/user_model.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${ServerConstants.serverUrl}/u/auth/register",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      print("Res Body: $resBody");
      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail']));
      }
      return Right(
          UserModel.fromMap(resBody).copyWith(token: resBody['token']));
    } catch (e) {
      return Left(AppFailure("e.toString()"));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      print(password);
      final response = await http.post(
        Uri.parse(
          "${ServerConstants.serverUrl}/u/auth/login",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      print("Res Body: $resBody");
      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['detail']));
      }
      return Right(
          UserModel.fromMap(resBody).copyWith(token: resBody['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/u/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap).copyWith(
          token: token,
        ),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
