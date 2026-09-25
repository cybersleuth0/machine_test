class UserData {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserDataModel> userDataModel;

  UserData({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.userDataModel,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 5,
      total: json['total'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 1,
      userDataModel: json['data'] != null
          ? (json['data'] as List).map((item) => UserDataModel.fromJson(item as Map<String, dynamic>)).toList()
          : <UserDataModel>[],
    );
  }
}

class UserDataModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserDataModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}
