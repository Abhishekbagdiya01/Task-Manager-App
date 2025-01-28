import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:intl/intl.dart';

class DateSelecter extends StatefulWidget {
  DateSelecter({Key? key}) : super(key: key);

  @override
  _DateSelecterState createState() => _DateSelecterState();
}

class _DateSelecterState extends State<DateSelecter> {
  DateTime selectedDate = DateTime.now();
  int weekOffSet = 0;
  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffSet);
    final String monthName = DateFormat("MMMM").format(weekDates.first);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    weekOffSet--;
                  });
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                )),
            Text(
              monthName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    weekOffSet++;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                )),
          ],
        ),
        SizedBox(
          height: 85,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              DateTime date = weekDates[index];
              bool isSelected = DateFormat('d').format(selectedDate) ==
                      DateFormat('d').format(date) &&
                  selectedDate.month == date.month &&
                  selectedDate.year == date.year;
              return InkWell(
                onTap: () {
                  selectedDate = date;
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  width: 75,
                  decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        weekDates[index].day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat("E").format(weekDates[index]),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
