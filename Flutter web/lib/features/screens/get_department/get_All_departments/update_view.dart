// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:lms/core/widgets/app_bar.dart';
//
//
//
// class LearnMateApp extends StatelessWidget {
//   const LearnMateApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'LearnMate',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF4A9DEC),
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//         pageTransitionsTheme: const PageTransitionsTheme(
//           builders: {
//             TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
//             TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
//             TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
//             TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//             TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//           },
//         ),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }
//
// // Splash Screen with Animation
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );
//
//     _controller.forward();
//
//     Timer(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//           const ChatScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           transitionDuration: const Duration(milliseconds: 500),
//         ),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF4A9DEC), Color(0xFF1E3A5F)],
//           ),
//         ),
//         child: Center(
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _scaleAnimation.value,
//                 child: Opacity(
//                   opacity: _fadeAnimation.value,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.smart_toy_outlined,
//                           color: Color(0xFF4A9DEC),
//                           size: 50,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'LearnMate',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<ChatMessage> _messages = [];
//   int _selectedNavIndex = 0;
//   bool _isTyping = false;
//   bool _isSidebarExpanded = true;
//
//   late AnimationController _sidebarController;
//   late Animation<double> _sidebarAnimation;
//   late AnimationController _fabController;
//
//   final List<ChatHistory> _chatHistory = [
//     ChatHistory('Revision Plan for Final Exam', DateTime.now()),
//     ChatHistory('Chapter 4 Notes', DateTime.now().subtract(const Duration(hours: 2))),
//     ChatHistory('Safety Guidelines Aviation', DateTime.now().subtract(const Duration(days: 1))),
//     ChatHistory('How to submit project', DateTime.now().subtract(const Duration(days: 2))),
//     ChatHistory('Video Explanation Networking', DateTime.now().subtract(const Duration(days: 3))),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _sidebarController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _sidebarAnimation = Tween<double>(begin: 280, end: 80).animate(
//       CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
//     );
//
//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _sidebarController.dispose();
//     _fabController.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _toggleSidebar() {
//     setState(() {
//       _isSidebarExpanded = !_isSidebarExpanded;
//       if (_isSidebarExpanded) {
//         _sidebarController.reverse();
//       } else {
//         _sidebarController.forward();
//       }
//     });
//   }
//
//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;
//
//     final message = _messageController.text;
//     _messageController.clear();
//
//     setState(() {
//       _messages.add(ChatMessage(
//         text: message,
//         isUser: true,
//         timestamp: DateTime.now(),
//       ));
//       _isTyping = true;
//     });
//
//     _scrollToBottom();
//
//     Timer(const Duration(milliseconds: 1500), () {
//       setState(() {
//         _isTyping = false;
//         _messages.add(ChatMessage(
//           text: _generateResponse(message),
//           isUser: false,
//           timestamp: DateTime.now(),
//         ));
//       });
//       _scrollToBottom();
//     });
//   }
//
//   String _generateResponse(String question) {
//     final responses = [
//       "That's admin_profile great question! Let me help you understand this better...",
//       "Based on my analysis, here's what I recommend...",
//       "I'd be happy to explain! Here's admin_profile detailed breakdown...",
//       "Great thinking! Let me provide some insights on this topic...",
//     ];
//     return responses[DateTime.now().millisecond % responses.length];
//   }
//
//   void _scrollToBottom() {
//     Timer(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _clearChat() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Clear Chat?'),
//         content: const Text('This will delete all messages in this conversation.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() => _messages.clear());
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Clear'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFFE8F4FD),
//               Color(0xFFF5FAFF),
//               Color(0xFFFFFFFF),
//             ],
//           ),
//         ),
//         child: Row(
//           children: [
//             AnimatedBuilder(
//               animation: _sidebarAnimation,
//               builder: (context, child) {
//                 return SizedBox(
//                   width: _sidebarAnimation.value,
//                   child: _buildSidebar(),
//                 );
//               },
//             ),
//             Expanded(child: _buildChatArea()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSidebar() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               _AnimatedLogo(),
//               if (_isSidebarExpanded) ...[
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Text(
//                     'LearnMate',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E3A5F),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//               SizedBox(
//                 child: IconButton(
//                   icon: AnimatedRotation(
//                     turns: _isSidebarExpanded ? 0 : 0.5,
//                     duration: const Duration(milliseconds: 300),
//                     child: const Icon(Icons.chevron_left, color: Color(0xFF6B7280)),
//                   ),
//                   onPressed: _toggleSidebar,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//
//
//           _buildAnimatedNavItem(Icons.chat_bubble_outline, 'Chat', 0, 0),
//           _buildAnimatedNavItem(Icons.add, 'New Chat', 1, 50),
//           _buildAnimatedNavItem(Icons.search, 'Search Chats', 2, 100),
//           _buildAnimatedNavItem(Icons.history, 'History', 3, 150),
//           _buildAnimatedNavItem(Icons.delete_outline, 'Clear Chat', 4, 200),
//           _buildAnimatedNavItem(Icons.settings_outlined, 'Settings', 5, 250),
//
//           if (_isSidebarExpanded) ...[
//             const SizedBox(height: 24),
//             const Text(
//               'Your Chats',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _chatHistory.length,
//                 itemBuilder: (context, index) {
//                   return TweenAnimationBuilder<double>(
//                     tween: Tween(begin: 0, end: 1),
//                     duration: Duration(milliseconds: 300 + (index * 100)),
//                     builder: (context, value, child) {
//                       return Opacity(
//                         opacity: value,
//                         child: Transform.translate(
//                           offset: Offset(-20 * (1 - value), 0),
//                           child: _buildChatHistoryItem(_chatHistory[index], index),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnimatedNavItem(IconData icon, String label, int index, int delay) {
//     final isSelected = _selectedNavIndex == index;
//
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: Duration(milliseconds: 400 + delay),
//       curve: Curves.easeOut,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTap: () {
//           setState(() => _selectedNavIndex = index);
//           if (index == 4) _clearChat();
//         },
//         child: MouseRegion(
//           cursor: SystemMouseCursors.click,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: EdgeInsets.symmetric(
//               horizontal: _isSidebarExpanded ? 16 : 12,
//               vertical: 12,
//             ),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.white : Colors.transparent,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: isSelected
//                   ? [
//                 BoxShadow(
//                   color: const Color(0xFF4A9DEC).withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ]
//                   : null,
//             ),
//             child: Row(
//               mainAxisAlignment: _isSidebarExpanded
//                   ? MainAxisAlignment.start
//                   : MainAxisAlignment.center,
//               children: [
//                 AnimatedScale(
//                   scale: isSelected ? 1.1 : 1.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: Icon(
//                     icon,
//                     size: 20,
//                     color: isSelected
//                         ? const Color(0xFF4A9DEC)
//                         : const Color(0xFF6B7280),
//                   ),
//                 ),
//                 if (_isSidebarExpanded) ...[
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       label,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                         color: isSelected
//                             ? const Color(0xFF1E3A5F)
//                             : const Color(0xFF6B7280),
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatHistoryItem(ChatHistory chat, int index) {
//     return Dismissible(
//       key: Key(chat.title),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           color: Colors.red.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Icon(Icons.delete, color: Colors.red),
//       ),
//       onDismissed: (_) {
//         setState(() => _chatHistory.removeAt(index));
//       },
//       child: InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//           child: Row(
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF4A9DEC),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   chat.title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF4B5563),
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatArea() {
//     return Column(
//       children: [
//         // Header
//         _buildHeader(),
//         // Messages Area
//         Expanded(
//           child: _messages.isEmpty
//               ? _buildWelcomeMessage()
//               : _buildMessagesList(),
//         ),
//         // Typing Indicator
//         if (_isTyping) _buildTypingIndicator(),
//         // Input Area
//         _buildInputArea(),
//       ],
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Chat',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E3A5F),
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_outlined),
//                 onPressed: () {},
//                 tooltip: 'Notifications',
//               ),
//               const SizedBox(width: 8),
//               const CircleAvatar(
//                 radius: 18,
//                 backgroundColor: Color(0xFF4A9DEC),
//                 child: Icon(Icons.person, color: Colors.white, size: 20),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWelcomeMessage() {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.scale(
//             scale: 0.8 + (0.2 * value),
//             child: child,
//           ),
//         );
//       },
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Animated emoji
//             TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0, end: 1),
//               duration: const Duration(milliseconds: 1000),
//               builder: (context, value, child) {
//                 return Transform.rotate(
//                   angle: 0.1 * (1 - value) * 3.14,
//                   child: child,
//                 );
//               },
//               child: const Text(
//                 '👋',
//                 style: TextStyle(fontSize: 60),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Welcome!',
//               style: TextStyle(
//                 fontSize: 36,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1E3A5F),
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Type or record your question and I\'ll help you.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//             const SizedBox(height: 40),
//             // Quick action buttons
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               alignment: WrapAlignment.center,
//               children: [
//                 _buildQuickAction('📚 Study Tips', 'Give me effective study tips'),
//                 _buildQuickAction('✍️ Essay Help', 'Help me write an essay'),
//                 _buildQuickAction('🧮 Math Problem', 'Solve admin_profile math problem'),
//                 _buildQuickAction('🔬 Science Query', 'Explain admin_profile science concept'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickAction(String label, String message) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () {
//           _messageController.text = message;
//           _sendMessage();
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: const Color(0xFFE5E7EB)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF4B5563),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessagesList() {
//     return ListView.builder(
//       controller: _scrollController,
//       padding: const EdgeInsets.all(20),
//       itemCount: _messages.length,
//       itemBuilder: (context, index) {
//         return _MessageBubble(
//           message: _messages[index],
//           index: index,
//         );
//       },
//     );
//   }
//
//   Widget _buildTypingIndicator() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, bottom: 10),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: List.generate(3, (index) {
//                 return TweenAnimationBuilder<double>(
//                   tween: Tween(begin: 0, end: 1),
//                   duration: const Duration(milliseconds: 600),
//                   builder: (context, value, child) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 2),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 300 + (index * 100)),
//                         width: 8,
//                         height: 8 + (4 * (index == (DateTime.now().millisecond ~/ 200) % 3 ? 1.0 : 0.0)),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4A9DEC).withOpacity(0.6 + (0.4 * value)),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(width: 8),
//           const Text(
//             'LearnMate is typing...',
//             style: TextStyle(
//               fontSize: 12,
//               color: Color(0xFF6B7280),
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             _AnimatedIconButton(
//               icon: Icons.add,
//               onPressed: () {},
//               tooltip: 'Add attachment',
//             ),
//             // Mic button
//             _AnimatedIconButton(
//               icon: Icons.mic_outlined,
//               onPressed: () {},
//               tooltip: 'Voice input',
//             ),
//             Expanded(
//               child: TextField(
//                 controller: _messageController,
//                 decoration: const InputDecoration(
//                   hintText: 'Ask Anything...',
//                   hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                 ),
//                 onSubmitted: (_) => _sendMessage(),
//            onChanged: (_) => setState(() {}),
//
//       maxLines: null,
//               ),
//             ),
//             AnimatedBuilder(
//               animation: _fabController,
//               builder: (context, child) {
//                 final hasText = _messageController.text.isNotEmpty;
//                 return GestureDetector(
//                   onTap: _sendMessage,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: hasText
//                             ? [const Color(0xFF4A9DEC), const Color(0xFF1E3A5F)]
//                             : [const Color(0xFFE5E7EB), const Color(0xFFD1D5DB)],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: hasText
//                           ? [
//                         BoxShadow(
//                           color: const Color(0xFF4A9DEC).withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ]
//                           : null,
//                     ),
//                     child: Icon(
//                       Icons.send_rounded,
//                       color: hasText ? Colors.white : const Color(0xFF9CA3AF),
//                       size: 22,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _AnimatedLogo extends StatefulWidget {
//   @override
//   State<_AnimatedLogo> createState() => _AnimatedLogoState();
// }
//
// class _AnimatedLogoState extends State<_AnimatedLogo>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E3A5F),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF4A9DEC).withOpacity(0.3 + (_controller.value * 0.3)),
//                 blurRadius: 10 + (_controller.value * 10),
//                 spreadRadius: _controller.value * 2,
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.smart_toy_outlined,
//             color: Color(0xFF4FC3F7),
//             size: 24,
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _AnimatedIconButton extends StatefulWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final String tooltip;
//
//   const _AnimatedIconButton({
//     required this.icon,
//     required this.onPressed,
//     required this.tooltip,
//   });
//
//   @override
//   State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
// }
//
// class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: Tooltip(
//         message: widget.tooltip,
//         child: GestureDetector(
//           onTap: widget.onPressed,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: _isHovered
//                   ? const Color(0xFF4A9DEC).withOpacity(0.1)
//                   : Colors.transparent,
//               shape: BoxShape.circle,
//             ),
//             child: AnimatedScale(
//               scale: _isHovered ? 1.1 : 1.0,
//               duration: const Duration(milliseconds: 200),
//               child: Icon(
//                 widget.icon,
//                 color: _isHovered
//                     ? const Color(0xFF4A9DEC)
//                     : const Color(0xFF6B7280),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final int index;
//
//   const _MessageBubble({required this.message, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Opacity(
//               opacity: value.clamp(0.0, 1.0),
//
//           child: Transform.translate(
//             offset: Offset(
//               message.isUser ? 30 * (1 - value) : -30 * (1 - value),
//               0,
//             ),
//             child: child,
//           ),
//         );
//       },
//       child: Align(
//         alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.5,
//           ),
//           decoration: BoxDecoration(
//             gradient: message.isUser
//                 ? const LinearGradient(
//               colors: [Color(0xFF4A9DEC), Color(0xFF1E3A5F)],
//             )
//                 : null,
//             color: message.isUser ? null : Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(20),
//               topRight: const Radius.circular(20),
//               bottomLeft: Radius.circular(message.isUser ? 20 : 4),
//               bottomRight: Radius.circular(message.isUser ? 4 : 20),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: message.isUser
//                     ? const Color(0xFF4A9DEC).withOpacity(0.3)
//                     : Colors.black.withOpacity(0.08),
//                 blurRadius: 15,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.text,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: message.isUser ? Colors.white : const Color(0xFF1E3A5F),
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 _formatTime(message.timestamp),
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: message.isUser
//                       ? Colors.white.withOpacity(0.7)
//                       : const Color(0xFF9CA3AF),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
// }
//
// class ChatMessage {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//
//   ChatMessage({
//     required this.text,
//     required this.isUser,
//     required this.timestamp,
//   });
// }
//
// class ChatHistory {
//   final String title;
//   final DateTime timestamp;
//
//   ChatHistory(this.title, this.timestamp);
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/draft/test_cubit.dart';
import 'package:lms/features/draft/test_models.dart';
import 'package:lms/features/draft/test_states.dart';
import 'package:lms/features/screens/get_department/get_All_departments/state_managments/cubit.dart';
import 'package:lms/features/screens/get_department/get_All_departments/state_managments/states.dart';

import 'all_model/model.dart';

class UpdateDepartmentScreen extends StatefulWidget {
  final GetAllDepartmentModel department;

  const UpdateDepartmentScreen({super.key, required this.department});

  @override
  State<UpdateDepartmentScreen> createState() => _UpdateDepartmentScreenState();
}

class _UpdateDepartmentScreenState extends State<UpdateDepartmentScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController headCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.department.name);
    descCtrl = TextEditingController(text: widget.department.description);
    headCtrl =
        TextEditingController(text: widget.department.headId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Department")),
      body: BlocConsumer<DepartmentsCubit, DepartmentsState>(
        listener: (context, state) {
          if (state is UpdateDepartmentSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          }
          if (state is UpdateDepartmentError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: headCtrl,
                  decoration: const InputDecoration(labelText: "Head ID"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                state is UpdateDepartmentLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    context.read<DepartmentsCubit>().updateDepartment(
                      id: widget.department.id,
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      headId: int.parse(headCtrl.text),
                    );
                  },
                  child: const Text("Update"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
