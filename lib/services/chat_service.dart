import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'api_service.dart';

class ChatService {
  static io.Socket? _socket;
  static const String _serverUrl = 'http://localhost:5000';

  // Connect to Socket.io server
  static void connect(String chatId, Function(Map<String, dynamic>) onMessage) {
    _socket = io.io(_serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to Socket.io');
      _socket!.emit('joinChat', chatId);
    });

    _socket!.on('receiveMessage', (data) {
      if (data is Map) {
        onMessage(Map<String, dynamic>.from(data));
      }
    });

    _socket!.onDisconnect((_) => print('Disconnected from Socket.io'));
  }

  // Send a message via Socket.io
  static void sendMessage(String chatId, String senderId, String content) {
    _socket?.emit('sendMessage', {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
    });
  }

  // Disconnect
  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  // Create or get a chat room via REST
  static Future<Map<String, dynamic>?> createChat(String customerId, String craftsmanId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/chats'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'customerId': customerId, 'craftsmanId': craftsmanId}),
      );
      if (response.statusCode == 201) return jsonDecode(response.body);
      return null;
    } catch (e) {
      print('Create chat error: $e');
      return null;
    }
  }

  // Get message history
  static Future<List<dynamic>> getMessages(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/chats/$chatId/messages'),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      print('Get messages error: $e');
      return [];
    }
  }

  // Get user chats list
  static Future<List<dynamic>> getUserChats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/chats/user/$userId'),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      print('Get user chats error: $e');
      return [];
    }
  }
}