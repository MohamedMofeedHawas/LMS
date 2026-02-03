import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../get_all squadrons/state_managment/cubit.dart';
import '../get_all squadrons/state_managment/states.dart';

class EditSquadronScreen extends StatefulWidget {
  final int squadronId;

  const EditSquadronScreen({super.key, required this.squadronId});

  @override
  State<EditSquadronScreen> createState() => _EditSquadronScreenState();
}

class _EditSquadronScreenState extends State<EditSquadronScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();

    context.read<AllSquadronCubit>()
        .fetchSquadronById(widget.squadronId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Squadron")),
      body: BlocConsumer<AllSquadronCubit, AllSquadronState>(
        listener: (context, state) {
          if (state is UpdateSquadronSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is GetSquadronByIdLoading ||
              state is UpdateSquadronLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetSquadronByIdLoaded) {
            final squadron = state.squadron;

            nameController.text = squadron.name;
            descriptionController.text = squadron.description;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                      const InputDecoration(labelText: "Description"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updated = squadron.copyWith(
                            name: nameController.text,
                            description: descriptionController.text,
                          );

                          context
                              .read<AllSquadronCubit>()
                              .updateSquadron(updated);
                        }
                      },
                      child: const Text("Save Changes"),
                    )
                  ],
                ),
              ),
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
