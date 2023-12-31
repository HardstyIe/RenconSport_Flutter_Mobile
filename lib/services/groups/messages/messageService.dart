import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport/constants/auth.dart';
import 'package:renconsport/models/group/message/message.dart';

class MessageService {
  static const url = Api.NESTJS_BASE_URL;
  static const allMessage = "messages";
  static const message = "messages/:id";
  static const sendMessage = "messages/:id";
  static const putMessage = "messages/:id";
  static const patchMessages = "messages/:id";
  static const delMessage = "messages/:id";

  static final Dio _dio = Dio();
  static final storage = FlutterSecureStorage(); // Ajouté

  static Future<String?> getToken() async {
    return await storage.read(key: 'authToken'); // Ajouté
  }

  static Future<Message?> createMessage(
      Map<String, dynamic> messageData) async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.post(
        url + sendMessage,
        data: messageData,
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final messageDataJson = response.data as Map<String, dynamic>;
        final message = Message.fromJson(messageDataJson);
        return message;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<List<Message>> getAllMessage() async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.get(
        url + allMessage,
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> messageDataList = response.data as List<dynamic>;
        final List<Message> messages = messageDataList.map((data) {
          return Message.fromJson(data as Map<String, dynamic>);
        }).toList();
        return messages;
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (error) {
      throw Exception('Failed to fetch messages: $error');
    }
  }

  static Future<Message?> getMessage(String id) async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.get(
        url + message.replaceAll(':id', id),
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final messageDataJson = response.data as Map<String, dynamic>;
        final message = Message.fromJson(messageDataJson);
        return message;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Message?> deleteMessage(String id) async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.delete(
        url + delMessage.replaceAll(':id', id),
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final messageDataJson = response.data as Map<String, dynamic>;
        final message = Message.fromJson(messageDataJson);
        return message;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Message?> updateMessage(
      String id, Map<String, dynamic> messageData) async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.put(
        url + putMessage.replaceAll(':id', id),
        data: messageData,
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final messageDataJson = response.data as Map<String, dynamic>;
        final message = Message.fromJson(messageDataJson);
        return message;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Message?> patchMessage(
      String id, Map<String, dynamic> messageData) async {
    try {
      String? token = await getToken(); // Ajouté

      final response = await _dio.patch(
        url + patchMessages.replaceAll(':id', id),
        data: messageData,
        options: Options(
          headers: {"Authorization": "Bearer $token"}, // Ajouté
        ),
      );

      if (response.statusCode == 200) {
        final messageDataJson = response.data as Map<String, dynamic>;
        final message = Message.fromJson(messageDataJson);
        return message;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
