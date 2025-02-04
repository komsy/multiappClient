class UserModel {
  String userName;
  String email;
  String password;
  String role;
  int status;
  int userStatus;
  int licStatus;
  String createdAt;

//Constructor for UserModel
  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.userStatus,
    required this.licStatus,
    required this.createdAt,
  });


  //Static function to create an empty user model
  static UserModel empty() => UserModel( userName: '', email: '', password: '', role: 'user', status: 1,userStatus: 0,licStatus: 0, createdAt: '');

  //Convert model to Json structure for storing data in sqlite.
  Map<String, dynamic> toJson() {
    return{
      'username':userName,
      'email':email,
      'password':password,
      'role':role,
      'status':status,
      'userStatus':userStatus,
      'licStatus':licStatus,
      'createdAt':createdAt,
    };
  }

  //factory method to create a usermodel from sqlite document snapshot.
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
    userName: data['username'] ?? '',
    email: data['email'] ?? '',
    password: data['password'] ?? '',
    role: data['role'] ?? 'user',
    status: data['status'] ?? 1,
    userStatus: data['userStatus'] ?? 0,
    licStatus: data['licStatus'] ?? 0,
    createdAt: data['createdAt'] ?? '',
    );
  }

}