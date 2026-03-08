import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/todo.dart';
import '../services/device_service.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  late WebSocketChannel _channel;
  String _deviceId = '';
  String _deviceName = '';
  bool _isConnected = false;
  bool _isInitialized = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  List<Todo> get todos => _todos;
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;
  bool get isConnecting => _isConnecting;
  int get reconnectAttempts => _reconnectAttempts;
  String get deviceId => _deviceId;

  String get currentUser {
    if (_deviceId.isEmpty) {
      return 'Loading...';
    }
    if (_deviceId.length < 8) {
      return '$_deviceName ($_deviceId)';
    }
    return '$_deviceName (${_deviceId.substring(0, 8)})';
  }

  TodoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _getDeviceInfo();
    _isInitialized = true;
    _connectWebSocket();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final deviceService = DeviceService();
      _deviceId = await deviceService.getDeviceId();
      _deviceName = await deviceService.getDeviceName();
      print('📱 Device ID: $_deviceId');
      print('📱 Device Name: $_deviceName');
      notifyListeners();
    } catch (e) {
      print('Error getting device info: $e');
      _deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      _deviceName = 'Unknown Device';
      notifyListeners();
    }
  }

  void _connectWebSocket() {
    if (_isConnecting) return;

    _isConnecting = true;
    _reconnectAttempts = 0;
    notifyListeners();

    try {
      final wsUrl = 'wss://collaborative-todo-backend-c4p6.onrender.com';

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel.stream.listen(
            (message) {
          _isConnected = true;
          _isConnecting = false;
          _reconnectAttempts = 0;
          notifyListeners();
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
          _isConnecting = false;
          notifyListeners();
          _reconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
          _isConnecting = false;
          notifyListeners();
          _reconnect();
        },
      );
    } catch (e) {
      print('Connection error: $e');
      _isConnected = false;
      _isConnecting = false;
      notifyListeners();
      _reconnect();
    }
  }

  void _reconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      print('Max reconnection attempts reached');
      _isConnecting = false;
      notifyListeners();
      return;
    }

    _reconnectAttempts++;
    _isConnecting = true;
    notifyListeners();

    final delay = Duration(seconds: 3 * _reconnectAttempts);

    Future.delayed(delay, () {
      if (!_isConnected && _isInitialized) {
        print('Reconnecting... Attempt $_reconnectAttempts');
        _connectWebSocket();
      }
    });
  }

  Future<void> refreshConnection() async {
    if (_isConnecting) return;

    try {
      _channel.sink.close();
    } catch (e) {

    }

    _isConnected = false;
    _reconnectAttempts = 0;
    _connectWebSocket();
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = json.decode(message);

      switch (data['type']) {
        case 'INITIAL_TODOS':
          _handleInitialTodos(data['payload']);
          break;
        case 'TODO_ADDED':
          _handleTodoAdded(data['payload']);
          break;
        case 'TODO_UPDATED':
          _handleTodoUpdated(data['payload']);
          break;
        case 'TODO_DELETED':
          _handleTodoDeleted(data['payload']);
          break;
        case 'STATUS_UPDATED':
          _handleStatusUpdated(data['payload']);
          break;
        case 'ERROR':
          print('Server error: ${data['payload']['message']}');
          break;
      }

      notifyListeners();
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  void _handleInitialTodos(List<dynamic> todosJson) {
    _todos = todosJson.map((json) => Todo.fromJson(json)).toList();
  }

  void _handleTodoAdded(Map<String, dynamic> todoJson) {
    final todo = Todo.fromJson(todoJson);
    _todos.insert(0, todo);
  }

  void _handleTodoUpdated(Map<String, dynamic> todoJson) {
    final updatedTodo = Todo.fromJson(todoJson);
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
    }
  }

  void _handleTodoDeleted(Map<String, dynamic> todoJson) {
    _todos.removeWhere((t) => t.id == todoJson['id']);
  }

  void _handleStatusUpdated(Map<String, dynamic> todoJson) {
    final index = _todos.indexWhere((t) => t.id == todoJson['id']);
    if (index != -1) {
      _todos[index] = Todo.fromJson(todoJson);
    }
  }

  void addTodo(String title, String description) {
    if (!_isInitialized || !_isConnected) {
      print('Provider not ready yet');
      return;
    }

    final now = DateTime.now();
    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: TodoStatus.pending,
      createdBy: currentUser,
      updatedBy: currentUser,
      createdAt: now,
      updatedAt: now,
    );

    final payload = {
      ...todo.toJson(),
      'deviceId': _deviceId,
      'deviceName': _deviceName,
    };

    _sendMessage('ADD_TODO', payload);
  }

  void updateTodo(Todo todo, String title, String description) {
    if (!_isInitialized || !_isConnected) return;

    final updatedTodo = todo.copyWith(
      title: title,
      description: description,
      updatedBy: currentUser,
      updatedAt: DateTime.now(),
    );

    final payload = {
      ...updatedTodo.toJson(),
      'deviceId': _deviceId,
      'deviceName': _deviceName,
    };

    _sendMessage('UPDATE_TODO', payload);
  }

  void deleteTodo(Todo todo) {
    if (!_isInitialized || !_isConnected) return;
    final payload = {
      'id': todo.id,
      'deviceId': _deviceId,
      'deviceName': _deviceName,
    };
    _sendMessage('DELETE_TODO', payload);
  }

  void updateStatus(Todo todo, TodoStatus newStatus) {
    if (!_isInitialized || !_isConnected) return;

    final updatedTodo = todo.copyWith(
      status: newStatus,
      updatedBy: currentUser,
      updatedAt: DateTime.now(),
    );

    final payload = {
      ...updatedTodo.toJson(),
      'deviceId': _deviceId,
      'deviceName': _deviceName,
    };

    _sendMessage('UPDATE_STATUS', payload);
  }

  void _sendMessage(String type, Map<String, dynamic> payload) {
    if (_isConnected) {
      _channel.sink.add(json.encode({
        'type': type,
        'payload': payload,
      }));
    }
  }

  Map<TodoStatus, int> getStatusCounts() {
    return {
      TodoStatus.pending: _todos.where((t) => t.status == TodoStatus.pending).length,
      TodoStatus.in_progress: _todos.where((t) => t.status == TodoStatus.in_progress).length,
      TodoStatus.completed: _todos.where((t) => t.status == TodoStatus.completed).length,
    };
  }

  @override
  void dispose() {
    try {
      _channel.sink.close();
    } catch (e) {
    }
    super.dispose();
  }
}
