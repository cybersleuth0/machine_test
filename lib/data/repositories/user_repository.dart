
import 'package:machine_test/core/constants/AppUrls.dart';
import 'package:machine_test/core/network/api_helper.dart';
import 'package:machine_test/data/models/userModel.dart';

class UserRepository {
  final ApiHelper apiHelper;
  UserRepository({required this.apiHelper});

  Future<UserData> fetchUsers({ int page = 1, int perPage = 5}) async {
    final response = await apiHelper.getApi(
      url: '${AppUrls.fetchUsers}?page=$page&per_page=$perPage',
      mHeaders: {
        "x-api-key": "reqres_32e47dacd4744f009b24358d68f0272d",
      },
    );

    return UserData.fromJson(response);
  }
}
