class UserModel {
  String userName;
  String email;
  String password;
  String role;
  int status;
  String createdAt;

//Constructor for UserModel
  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.createdAt,
  });


  //Static function to create an empty user model
  static UserModel empty() => UserModel( userName: '', email: '', password: '', role: 'user', status: 1, createdAt: '');

  //Convert model to Json structure for storing data in sqlite.
  Map<String, dynamic> toJson() {
    return{
      'username':userName,
      'email':email,
      'password':password,
      'role':role,
      'status':status,
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
    createdAt: data['createdAt'] ?? '',
    );
  }

}