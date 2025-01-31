import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);

  DateTime selectedDate = DateTime.now();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  validator: (value) {
                    if (value!.trim() == "") {
                      return "Title cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: descController,
                    maxLines: 5,
                    decoration: const InputDecoration(hintText: "Description"),
                    validator: (value) {
                      if (value!.trim() == "") {
                        return "Title cannot be empty";
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text("Due Date : "),
                    TextButton(
                      onPressed: () async {
                        final _selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 90)));

                        if (_selectedDate != null) {
                          selectedDate = _selectedDate;
                          setState(() {});
                        }
                      },
                      child: Text(
                        DateFormat("d-MM-y").format(selectedDate),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                ColorPicker(
                  heading: const Text('Select color'),
                  subheading: const Text('Select a different shade'),
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                  color: selectedColor,
                  pickersEnabled: const {
                    ColorPickerType.wheel: true,
                  },
                ),
                BlocListener<TaskCubit, TaskState>(
                  listener: (context, state) async {
                    log(state.toString());
                    if (state is TaskAdded) {
                      snackbarMessenger(
                          context: context, text: "Task added successfully!");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (_) => false,
                      );
                    } else if (state is TaskError) {
                      snackbarMessenger(
                        context: context,
                        text:
                            "You are not connected to internet, Task update locally ",
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (_) => false,
                      );
                    }
                    log("state on add task screen: $state");
                  },
                  child: OutlinedButton(
                    onPressed: () async {
                      final user = await AuthLocalRepository().getUser();
                      addNewTask(
                        TaskModel(
                            id: Uuid().v6(),
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            uid: user!.id,
                            hexColor: rgbToHex(selectedColor),
                            dueAt: selectedDate,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            isSynced: 0),
                      );
                    },
                    child: const Text("Upload Task"),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  addNewTask(TaskModel taskModel) {
    if (formKey.currentState!.validate()) {
      context.read<TaskCubit>().addTask(taskModel);
    }
  }
}
