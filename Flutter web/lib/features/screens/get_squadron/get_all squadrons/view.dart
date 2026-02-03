import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/screens/get_squadron/get_all%20squadrons/state_managment/cubit.dart';
import 'package:lms/features/screens/get_squadron/get_all%20squadrons/state_managment/states.dart';

import '../update_squadrons/view.dart';

class GetSquadronPage extends StatelessWidget {
  const GetSquadronPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create: (context) => AllSquadronCubit(
        )..fetchSquadrons(),
        child: const SquadronListScreen(),
      );
  }
}

class SquadronListScreen extends StatelessWidget {
  const SquadronListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Squadrons')),
      body: BlocBuilder<AllSquadronCubit, AllSquadronState>(
        builder: (context, state) {
          if (state is AllSquadronLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AllSquadronLoaded) {
            return ListView.builder(
              itemCount: state.squadrons.length,
              itemBuilder: (context, index) {
                final squadron = state.squadrons[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(squadron.name),
                    subtitle: Text(
                      'Students Count: ${squadron.studentCount}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AllSquadronCubit>(),
                                  child: EditSquadronScreen(
                                    squadronId: squadron.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<AllSquadronCubit>()
                                .deleteSquadron(squadron.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is AllSquadronError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
