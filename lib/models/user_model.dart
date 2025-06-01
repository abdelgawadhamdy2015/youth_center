import 'package:json_annotation/json_annotation.dart';

class CenterUser {
  final String? id;
  final String name;
  final String email;
  final String mobile;
  final String youthCenterName;
  final bool admin;

  // Temporary password field (NOT included in JSON)
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? password;

  CenterUser({
     this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.youthCenterName,
    required this.admin,
    this.password,
  });

  factory CenterUser.fromJson(Map<String, dynamic> json) {
    return CenterUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      youthCenterName: json['youthCenterName'],
      admin: json['admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
    
      'name': name,
      'email': email,
      'mobile': mobile,
      'youthCenterName': youthCenterName,
      'admin': admin,
    };
  }
}
