class Endpoints {
  // Auth (v2)
  static const String login = '/api/v2/auth/login';
  static const String register = '/api/v2/auth/register';
  static const String getMe = '/api/v2/users/me';

  // Chat (v3)
  static const String getMyChats = '/api/v3/chats';
  static String getChatById(String id) => '/api/v3/chats/$id';
  static String getChatMessages(String chatId) => '/api/v3/chats/$chatId/messages';
  static const String initiateChat = '/api/v3/chats';
  static String deleteChat(String id) => '/api/v3/chats/$id';
}
