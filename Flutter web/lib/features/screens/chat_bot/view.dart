

import 'package:flutter/material.dart';

import '../../../core/widgets/app_bar.dart';




class Message {
  final String text;
  final bool isUser;
  final bool isVoice;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    this.isVoice = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Message> messages;

  ChatSession({
    required this.id,
    required this.title,
    DateTime? createdAt,
    List<Message>? messages,
  })  : createdAt = createdAt ?? DateTime.now(),
        messages = messages ?? [];
}

class LearnMateChat extends StatefulWidget {
  const LearnMateChat({super.key});

  @override
  State<LearnMateChat> createState() => _LearnMateChatState();
}

class _LearnMateChatState extends State<LearnMateChat> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedMenuItem = 0;
  String? _selectedChatId;


  final List<ChatSession> _chatSessions = [
    ChatSession(
      id: '1',
      title: 'Revision Plan for Final Exam',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChatSession(
      id: '2',
      title: 'Chapter 4 Notes',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ChatSession(
      id: '3',
      title: 'Safety Guidelines Aviation',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ChatSession(
      id: '4',
      title: 'How to submit project',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ChatSession(
      id: '5',
      title: 'Video Explanation Networking',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ChatSession(
      id: '6',
      title: 'Lesson 3 Summary',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  final List<Message> _currentMessages = [

    // TODO : complete
    // Message(
    //   text: "Hi! I'm Learning Assistant. I can help you with courses, assignments, quizzes, and progress tracking. How can I help you today?",
    //   isUser: false,
    // ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _currentMessages.add(Message(
        text: _messageController.text,
        isUser: true,
      ));
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _currentMessages.add(Message(
          text: _getBotResponse(userMessage),
          isUser: false,
        ));
      });
    });
  }

  String _getBotResponse(String userMessage) {
    final msg = userMessage.toLowerCase();

    if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey')) {
      return "Hello! How can I assist you with your learning today? 😊";
    } else if (msg.contains('course') || msg.contains('lesson')) {
      return "I can help you with:\n• Course progress tracking\n• Lesson summaries\n• Assignment deadlines\n• Quiz preparation\n\nWhat would you like to know?";
    } else if (msg.contains('progress') || msg.contains('status')) {
      return "You've completed 45% of the AI course.\n• Lessons completed: 5/12\n• Assignments completed: 2/3\n• Quizzes passed: 4/5\n\nKeep up the excellent work! 💪";
    } else if (msg.contains('help')) {
      return "I'm here to help! You can ask me about:\n✓ Course materials\n✓ Assignment submissions\n✓ Progress tracking\n✓ Study schedules\n✓ Quiz preparation\n\nWhat do you need help with?";
    } else if (msg.contains('quiz') || msg.contains('exam')) {
      return "Your upcoming assessments:\n• AI Fundamentals Quiz - Due in 3 days\n• Machine Learning Project - Due in 1 week\n• Final Exam - Scheduled for next month\n\nWould you like study tips? 📚";
    } else {
      return "I understand you're asking about '$userMessage'. Let me help you with that!\n\nCould you provide more details about what specific information you need?";
    }
  }

  void _createNewChat() {
    setState(() {
      final newChat = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Chat ${_chatSessions.length + 1}',
      );
      _chatSessions.insert(0, newChat);
      _selectedChatId = newChat.id;
      _currentMessages.clear();
      // _currentMessages.add(Message(
      //   text: "Hi! I'm your Learning Assistant. I can help you with courses, assignments, quizzes, and progress tracking. How can I help you today?",
      //   isUser: false,
      // ));
    });
  }

  void _selectChat(ChatSession chat) {
    setState(() {
      _selectedChatId = chat.id;
      // TODO: load messages from the selected chat
    });
  }

  void _deleteChat(String chatId) {
    setState(() {
      _chatSessions.removeWhere((chat) => chat.id == chatId);
      if (_selectedChatId == chatId) {
        _selectedChatId = null;
      }
    });
  }

  void _clearCurrentChat() {
    setState(() {
      _currentMessages.clear();
      _currentMessages.add(Message(
        text: "Chat cleared!😊",
        isUser: false,
      ));
    });
  }

  // void _toggleRecording() {
  //   setState(() {
  //     _isRecording = !_isRecording;
  //   });
  //
  //   if (_isRecording) {
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (_isRecording) {
  //         setState(() {
  //           _isRecording = false;
  //           _currentMessages.add(Message(
  //             text: "Voice message",
  //             isUser: true,
  //             isVoice: true,
  //           ));
  //         });
  //
  //         Future.delayed(const Duration(milliseconds: 1000), () {
  //           setState(() {
  //             _currentMessages.add(Message(
  //               text: "I received your voice message! How can I assist you further?",
  //               isUser: false,
  //             ));
  //           });
  //         });
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1300,
              maxHeight: 1000,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Row(
                      children: [
                        _buildSidebar(),
                        Expanded(child: _buildMainChatArea()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 288,
      color: Colors.blue.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Image(image: AssetImage("assets/images/chatbot image.png",),height: 60,width: 60,),
                const SizedBox(width: 12),
                const Text(
                  'LearnMate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildMenuItem(Icons.chat_bubble_outline, 'Chat', 0),
                _buildMenuItem(Icons.add, 'New Chat', 1, onTap: _createNewChat),
                _buildMenuItem(Icons.search, 'Search Chats', 2),
                _buildMenuItem(Icons.history, 'History', 3),
                _buildMenuItem(Icons.delete_outline, 'Clear Chat', 4,
                    onTap: _clearCurrentChat),
                _buildMenuItem(Icons.settings, 'Settings', 5),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Chats',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _chatSessions.length,
                      itemBuilder: (context, index) {
                        final chat = _chatSessions[index];
                        final isSelected = _selectedChatId == chat.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => _selectChat(chat),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '• ${chat.title}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isSelected
                                              ? Colors.grey.shade900
                                              : Colors.grey.shade700,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        onPressed: () => _deleteChat(chat.id),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index, {VoidCallback? onTap}) {
    final isActive = _selectedMenuItem == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedMenuItem = index;
            });
            onTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey.shade700),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,

                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainChatArea() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // const SizedBox(height: 12),
          //
          // const Text(
          //   'Welcome! 👋',
          //   style: TextStyle(
          //     fontSize: 36,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87,
          //   ),
          // ),
          // const SizedBox(height: 12),
          // Text(
          //   "Type or record your question and I'll help you.",
          //   style: TextStyle(
          //     fontSize: 20,
          //     color: Colors.grey.shade600,
          //   ),
          // ),
          Expanded(
            child: _currentMessages.isEmpty
                ? _buildWelcomeScreen()
                : _buildMessagesList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome! 👋',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Type or record your question and I'll help you.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(48),
      itemCount: _currentMessages.length,
      itemBuilder: (context, index) {
        final message = _currentMessages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: message.isUser
              ? (message.isVoice
              ? _buildUserVoiceMessage()
              : _buildUserMessage(message.text))
              : _buildBotMessage(message.text),
        );
      },
    );
  }

  Widget _buildBotMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   width: 48,
          //   height: 48,
          //   decoration: BoxDecoration(
          //     color: Colors.blue.shade200,
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Icon(
          //     Icons.chat_bubble_outline,
          //     color: Colors.black87,
          //     size: 24,
          //   ),
          // ),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/chatbot image.png",),
            radius: 24,
            backgroundColor: Colors.blue.shade100,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/chatbot man.png"),
            radius: 24,
            backgroundColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildUserVoiceMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 256),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      40,
                          (index) => Container(
                        width: 2,

                        //TODO this formula will be adjusted

                        height: (index % 5 + 1) * 4.0,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.grey.shade400, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Ask Anything',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // IconButton(
            //   onPressed: _toggleRecording,
            //   icon: Icon(
            //     _isRecording ? Icons.stop : Icons.mic,
            //     color: _isRecording ? Colors.red : Colors.grey.shade400,
            //     size: 24,
            //   ),
            // ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _sendMessage,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}