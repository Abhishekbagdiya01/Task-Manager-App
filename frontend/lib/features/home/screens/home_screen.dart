import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/date.selecter.dart';
import 'package:frontend/features/home/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
          elevation: 5,
        ),
        body: Center(
          child: Column(
            children: [
              DateSelecter(),
              const Row(
                children: [
                  Expanded(
                    child: TaskCard(
                        title: "This is title",
                        description:
                            "haha! there is a task i have to do. geez! so much work, ig i have no other choice but to do",
                        time: "10:00 AM",
                        color: Color.fromARGB(255, 254, 217, 142)),
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "12:00 PM",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
