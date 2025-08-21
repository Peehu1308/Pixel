import 'package:flutter/material.dart';
import 'package:pixel/Components/slotcard.dart';

import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 31, 94),
      extendBody: true,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "June",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check if you want to hide details from others.\nThis time slot will be visible as “busy”.",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),


              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TableCalendar(
                          focusedDay: focusedDay,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          selectedDayPredicate: (day) =>
                              isSameDay(selectedDay, day),
                          onDaySelected: (selected, focused) {
                            setState(() {
                              selectedDay = selected;
                              focusedDay = focused;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                                color: Colors.cyan.shade100,
                                shape: BoxShape.circle),
                            selectedDecoration: BoxDecoration(
                                color: Colors.cyan.shade600,
                                shape: BoxShape.circle),
                            weekendTextStyle:
                                const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        const SizedBox(height: 20),


                        SizedBox(
                          height: 600,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(10, (index) {
                                  int hour = 9 + index;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 8),
                                    child: Text(
                                      "$hour:00",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),


                              Expanded(
                                child: Stack(
                                  children: [
                                    // Time grid lines
                                    Column(
                                      children: List.generate(10, (index) {
                                        return Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey.shade200),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),

                                    // ⏱ Brandon Thompson (10:00)
                                    Positioned(
                                      top: 60, // 1 slot down (10:00)
                                      left: 0,
                                      child: buildSlotCard(
                                        name: "Brandon Thompson",
                                        location: "Hubraum",
                                        color: Colors.blue,
                                        avatars: ["AK", "DM", "+3"],
                                      ),
                                    ),

                                    // ⏱ Barbara Moore (10:30)
                                    Positioned(
                                      top: 90, // 1.5 slot down
                                      left: 130,
                                      child: buildSlotCard(
                                        name: "Barbara Moore",
                                        location: "Justin Hall",
                                        color: Colors.pink,
                                        avatars: [],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🔍 Floating Search Button
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.cyan.shade700),
            ),
          ),
        ],
      ),

      // 🔻 Bottom Nav
      // bottomNavigationBar: Navbar(currentIndex: 3, onTap: (index) {}, email: '',),
    );
  }

  // 🧱 Schedule Slot Card Builder
  
}
