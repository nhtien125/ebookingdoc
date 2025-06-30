import 'package:ebookingdoc/src/constants/services/api_caller.dart';
import 'package:ebookingdoc/src/data/model/userModel.dart';

class UserService {
  Future<User?> getUserById(String id) async {
    final response = await APICaller.getInstance().get('api/auth/getById/$id');
    if (response != null && response['code'] == 200) {
      return User.fromJson(response['data']);
    }
    return null;
  }

  Future<List<User>> getlistUserById(String id) async {
    try {
      final response =
          await APICaller.getInstance().get('api/patient/getById/$id');
      print('API DATA: $response');
      if (response != null &&
          response['code'] == 200 &&
          response['data'] != null) {
        return [User.fromJson(response['data'])];
      }
    } catch (e) {}
    return [];
  }
}
