import 'dart:developer';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:intl/intl.dart';

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
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                ),
                BlocListener<TaskCubit, TaskState>(
                  listener: (context, state) {
                    log(state.toString());
                    if (state is TaskAdded) {
                      snackbarMessenger(
                          context: context, text: "Task added successfully!");
                      Navigator.pop(context);
                      log(state.toString());
                    } else if (state is TaskError) {
                      snackbarMessenger(
                          context: context,
                          text: state.errorMessage,
                          isError: true);
                    }
                  },
                  child: OutlinedButton(
                    onPressed: () => addNewTask(TaskModel(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        hexColor: rgbToHex(selectedColor),
                        dueAt: selectedDate,
                        createdAt: null,
                        updatedAt: null)),
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
