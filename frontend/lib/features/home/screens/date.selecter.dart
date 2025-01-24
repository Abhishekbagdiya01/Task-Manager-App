import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:intl/intl.dart';

class DateSelecter extends StatefulWidget {
  DateSelecter({Key? key}) : super(key: key);

  @override
  _DateSelecterState createState() => _DateSelecterState();
}

class _DateSelecterState extends State<DateSelecter> {
  int weekOffSet = 0;
  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffSet);
    String monthName = DateFormat("MMMM").format(weekDates.first);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                )),
            Text(
              monthName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                )),
          ],
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  weekDates[index].day.toString(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
