import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:frontend/features/home/screens/add_task_screen.dart';
import 'package:frontend/features/home/widgets/date_selecter.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskCubit>().loadTasks();
    Connectivity().onConnectivityChanged.listen(
      (event) async {
        if (event.contains(ConnectivityResult.wifi)) {
          // ignore: use_build_context_synchronously
          await context.read<TaskCubit>().syncTasks();
        }
      },
    );
  }

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()));
                },
                icon: const Icon(Icons.add))
          ],
          elevation: 5,
        ),
        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            log("State on home page + $state");
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is TaskLoaded) {
              final tasks = state.allTasks
                  .where(
                    (element) =>
                        DateFormat('d').format(element.dueAt) ==
                            DateFormat('d').format(selectedDate) &&
                        selectedDate.month == element.dueAt.month &&
                        selectedDate.year == element.dueAt.year,
                  )
                  .toList();
              return Center(
                child: Column(
                  children: [
                    DateSelecter(
                      selectedDate: selectedDate,
                      onTap: (date) {
                        log(selectedDate.toString());
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            TaskModel task = tasks[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: TaskCard(
                                      title: task.title,
                                      description: task.description,
                                      time: task.createdAt
                                          .toString()
                                          .substring(0, 10),
                                      color: hexToRgb(task.hexColor)),
                                ),
                                Icon(
                                  Icons.circle,
                                  color: hexToRgb(task.hexColor),
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    DateFormat.jm().format(task.dueAt),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              );
            }
            return const Center(child: Text("Something went wrong"));
          },
        ));
  }
}
