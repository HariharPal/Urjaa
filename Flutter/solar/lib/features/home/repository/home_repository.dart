import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solar/core/constant/server_constant.dart';
import 'package:solar/core/failure/failure.dart';
import 'package:solar/features/home/model/project_model.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, List<ProjectModel>>> getProducts({
    required String token,
  }) async {
    try {
      // Make the HTTP request
      final res = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/u/projects"),
        headers: {
          'Content-Type': 'application/json',
          'token': token
        }, // Make sure to send the token
      );
      print(res.statusCode);
      if (res.statusCode != 200) {
        var resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
        print(resBodyMap['detail']);
        return Left(AppFailure(resBodyMap['detail']));
      }
      print("Res Body: ${res.body}");
      List<dynamic> resBodyList = jsonDecode(res.body) as List<dynamic>;
      List<ProjectModel> sectionsAttributes =
          resBodyList.map((section) => ProjectModel.fromMap(section)).toList();
      return Right(sectionsAttributes);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
