import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  String profilePicture;
  final String role;
  String gender;
  String birthdate;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.role,
    this.gender = '',
    this.birthdate = '',
  });

  // Helper function to get the full name
  String get fullName => '$firstName $lastName';

  // Helper function to format phone number
  String get formattedPhoneNo => FVFormatter.formatPhoneNumber(phoneNumber);

  // Static function to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  // Static function to generate a userName from the full name
  static String generateuserName(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseuserName = "$firstName$lastName";
    String userNameWithPrefix = "cwt_$camelCaseuserName";
    return userNameWithPrefix;
  }

  // Static function to create an empty user model
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        userName: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        role: 'client',
        gender: '',
        birthdate: '',
      );

  // Convert model to JSON structure for storing data in Firebase Realtime Database
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'role': role,
      'gender': gender,
      'birthDate': birthdate,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        userName: data['userName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        profilePicture: data['profilePicture'] ?? '',
        role: data['role'] ?? 'client',
        gender: data['gender'] ?? '',
        birthdate: data['birthDate'] ?? '',
      );
    } else {
      // Handle case when data is null
      throw Exception('DataSnapshot value is null');
    }
  }

  // Method to create a copy of the UserModel with updated fields
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? profilePicture,
    String? gender,
    String? birthdate,
  }) {
    return UserModel(
      id: this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      email: this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: this.role,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
    );
  }
}
