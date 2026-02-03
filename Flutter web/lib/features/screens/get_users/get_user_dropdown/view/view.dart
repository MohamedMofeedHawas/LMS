import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state_managment/get_users_cubit.dart';

import '../state_managment/cubit.dart';
import '../state_managment/states.dart';

class AssignDepartmentHeadPage extends StatelessWidget {
  const AssignDepartmentHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssignDepartmentHeadScreen();
  }
}

class AssignDepartmentHeadScreen extends StatefulWidget {
  const AssignDepartmentHeadScreen({super.key});

  @override
  State<AssignDepartmentHeadScreen> createState() => _AssignDepartmentHeadScreenState();
}

class _AssignDepartmentHeadScreenState extends State<AssignDepartmentHeadScreen> {
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Department Head"),
        backgroundColor: const Color(0xFF1849A9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Admin / Instructor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<UsersCubitDrop, UsersStateDrop>(
              builder: (context, state) {
                if (state is UsersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersErrorState) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                } else if (state is UsersLoadedState) {
                  final users = state.users;
                  if (users.isEmpty) {
                    return const Center(child: Text("No admins or instructors found"));
                  }
                  return DropdownButtonFormField<String>(
                    value: selectedUserId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: const Text("Select a user"),
                    items: users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user.id.toString(),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: user.imageUrl != null
                                  ? NetworkImage(user.imageUrl!)
                                  : null,
                              backgroundColor: Colors.grey.shade200,
                              child: user.imageUrl == null ? const Icon(Icons.person, size: 18) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text("${user.fullName} (${user.role})",
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedUserId = val;
                      });
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedUserId == null
                  ? null
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected user id: $selectedUserId")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1849A9),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  "Assign Head",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
