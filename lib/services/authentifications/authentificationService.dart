import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport/constants/auth.dart';
import 'package:renconsport/models/user/user.dart';

class AuthentificationServices {
  static const url = Api.NESTJS_BASE_URL;
  static const register = "auth/register";
  static const login = "auth/login";
  static const logout = "auth/logout";
  static final Dio _dio = Dio();
  static final storage = new FlutterSecureStorage();

  static Future<User?> registerUser(
      Map<String, dynamic> userData, BuildContext context) async {
    try {
      final response = await _dio.post(
        url + register,
        data: userData,
      );

      if (response.statusCode != 201)
        throw Exception("Erreur lors de l'inscription");
      final userDataJson = response.data as Map<String, dynamic>;
      final user = User.fromJson(userDataJson);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inscription réussie")));
      return user;
    } catch (error) {
      print("Erreur lors de l'inscription: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'inscription'),
        ),
      );
      return null;
    }
  }

  static Future<User?> loginUser(
      Map<String, dynamic> userData, BuildContext context) async {
    try {
      final result = await _dio.post(
        url + login,
        data: userData,
      );

      if (result.statusCode != 201)
        throw Exception("Erreur lors de la connexion");
      final userDataJson = result.data as Map<String, dynamic>;

      final user = User.fromJson(userDataJson);
      String token = userDataJson['token'];

      await storage.write(
          key: 'authToken',
          value: token); // Utilisation de Flutter Secure Storage

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Connexion réussie")));
      return user;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la connexion'),
        ),
      );
      return null;
    }
  }
}
