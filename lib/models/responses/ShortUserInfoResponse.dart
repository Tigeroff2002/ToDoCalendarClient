class ShortUserInfoResponse {

  final int userId;
  final String userName;
  final String userEmail;
  final String phoneNumber;

  ShortUserInfoResponse({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phoneNumber
  });

  factory ShortUserInfoResponse.fromJson(Map <String, dynamic> json) {
    return ShortUserInfoResponse(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      phoneNumber: json['phone_number']
    );
  }
}