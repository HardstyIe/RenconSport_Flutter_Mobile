import 'package:dio/dio.dart';
import 'package:renconsport/models/message.dart';

class MessageService {
  static const url = "http://localhost:3000/messages";
  static final Dio _dio = Dio();

  static Future<Message?> sendMessage(Map<String, dynamic> messageData) async {
    try {
      final response = await _dio.post(url, data: messageData);

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

  static Future<List<Message>> fetchMessages() async {
    try {
      final response = await _dio.get(url);

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

}