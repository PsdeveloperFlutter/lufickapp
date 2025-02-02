import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(home: CalendarApp()));
}

class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();

  // Sample events data
  Map<DateTime, List<String>> _events = {
    DateTime(2025, 2, 5): ['Meeting with Team'],
    DateTime(2025, 2, 12): ['Doctor Appointment'],
    DateTime(2025, 2, 18): ['Project Deadline'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar & Events'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Calendar View'),
            Tab(text: 'List View'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarView(),
          _buildEventListView(),
        ],
      ),
    );
  }

  /// Build Monthly Calendar with Event Marking
  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2024, 1, 1),
          lastDay: DateTime(2030, 12, 31),
          focusedDay: _selectedDate,
          calendarFormat: _calendarFormat,
          eventLoader: (day) => _events[day] ?? [],
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
                color: Colors.blue, shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(
                color: Colors.orange, shape: BoxShape.circle),
          ),
        ),
        SizedBox(height: 20),
        Expanded(child: _buildSelectedDateEvents()),
      ],
    );
  }

  /// Show Events for Selected Date
  Widget _buildSelectedDateEvents() {
    List<String> events = _events[_selectedDate] ?? [];
    return events.isEmpty
        ? Center(child: Text("No Events"))
        : ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index]),
          leading: Icon(Icons.event, color: Colors.blue),
        );
      },
    );
  }

  /// Build List View for All Events
  Widget _buildEventListView() {
    List<Map<String, dynamic>> eventList = _events.entries
        .map((e) => {'date': e.key, 'events': e.value})
        .toList();

    // Sort events by date
    eventList.sort((a, b) => a['date'].compareTo(b['date']));

    return ListView.builder(
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        DateTime eventDate = eventList[index]['date'];
        List<String> events = eventList[index]['events'];
        String formattedDate = DateFormat.yMMMd().format(eventDate);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: ListTile(
            title: Text(events.join(", ")),
            subtitle: Text(formattedDate),
            leading: Icon(Icons.calendar_today, color: Colors.green),
          ),
        );
      },
    );
  }
}
