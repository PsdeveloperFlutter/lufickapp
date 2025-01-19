import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';// Import your LocalNotification class
import 'Notification_SettingS.dart';
// State provider to hold the reminder state
final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});

class ReminderState {
  final String selectedUnit; // e.g., 'Minutes', 'Hours', 'Seconds'
  final int reminderValue; // Reminder time
  final String repeatOption; // e.g., 'None', 'Daily', 'Weekly', 'Monthly', 'Custom'
  final int customInterval; // Custom repeat interval (e.g., every X days)

  ReminderState({
    required this.selectedUnit,
    required this.reminderValue,
    required this.repeatOption,
    this.customInterval = 1,
  });
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier()
      : super(ReminderState(
    selectedUnit: 'Minutes',
    reminderValue: 10,
    repeatOption: 'None',
    customInterval: 1,
  ));

  void updateUnit(String unit) {
    state = ReminderState(
      selectedUnit: unit,
      reminderValue: state.reminderValue,
      repeatOption: state.repeatOption,
      customInterval: state.customInterval,
    );
  }

  void updateValue(int value) {
    state = ReminderState(
      selectedUnit: state.selectedUnit,
      reminderValue: value,
      repeatOption: state.repeatOption,
      customInterval: state.customInterval,
    );
  }

  void updateRepeatOption(String option, {int interval = 1}) {
    state = ReminderState(
      selectedUnit: state.selectedUnit,
      reminderValue: state.reminderValue,
      repeatOption: option,
      customInterval: option == 'Custom' ? interval : 1,
    );
  }
}

class CustomReminderScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Set Custom Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reminder Time:', style: TextStyle(fontSize: 18)),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(reminderProvider.notifier).updateValue(int.tryParse(value) ?? 10);
              },
              decoration: InputDecoration(hintText: 'Enter value'),
            ),
            SizedBox(height: 20),
            Text('Unit:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: reminderState.selectedUnit,
              items: ['Seconds', 'Minutes', 'Hours', 'Days']
                  .map((unit) => DropdownMenuItem<String>(
                value: unit,
                child: Text(unit),
              ))
                  .toList(),
              onChanged: (value) {
                ref.read(reminderProvider.notifier).updateUnit(value ?? 'Minutes');
              },
            ),
            SizedBox(height: 20),
            Text('Repeat Option:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: reminderState.repeatOption,
              items: ['None', 'Daily', 'Weekly', 'Monthly', 'Custom']
                  .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
                  .toList(),
              onChanged: (value) {
                ref.read(reminderProvider.notifier).updateRepeatOption(value ?? 'None');
              },
            ),
            SizedBox(height: 20),
            if (reminderState.repeatOption == 'Custom')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Custom Interval (Days):', style: TextStyle(fontSize: 18)),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      ref.read(reminderProvider.notifier).updateRepeatOption(
                          'Custom', interval: int.tryParse(value) ?? 1);
                    },
                    decoration: InputDecoration(hintText: 'Enter custom interval'),
                  ),
                ],
              ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Ensure LocalNotification.init()
                LocalNotification.scheduleNotification(
                  payload: "Event Reminder Payload",
                  title: "Event Reminder",
                  body: "You have an event in your calendar!",
                  reminderValue: reminderState.reminderValue,
                  selectedUnit: reminderState.selectedUnit,
                  repeatOption: reminderState.repeatOption,
                  customInterval: reminderState.customInterval,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Reminder Set!'),
                ));
              },
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

//Main entry point and main function
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notifications
  await LocalNotification.init();
  runApp(ProviderScope(child: MaterialApp(home: CustomReminderScreen())));
}