import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Notification_SettingS.dart';

final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});

class ReminderState {
  final String selectedUnit;
  final int reminderValue;
  final String repeatOption;
  final int customInterval;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Reminder', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showReminderBottomSheet(context, ref),
          child: Text('Set Reminder', style: GoogleFonts.poppins()),
        ),
      ),
    );
  }

  void showReminderBottomSheet(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderProvider);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Set Custom Reminder', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(reminderProvider.notifier).updateValue(int.tryParse(value) ?? 10);
                },
                decoration: InputDecoration(
                  labelText: 'Reminder Time',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                value: reminderState.selectedUnit,
                items: ['Seconds', 'Minutes', 'Hours', 'Days']
                    .map((unit) => DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: GoogleFonts.poppins()),
                ))
                    .toList(),
                onChanged: (value) {
                  ref.read(reminderProvider.notifier).updateUnit(value ?? 'Minutes');
                },
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                value: reminderState.repeatOption,
                items: ['None', 'Daily', 'Weekly', 'Monthly', 'Custom']
                    .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option, style: GoogleFonts.poppins()),
                ))
                    .toList(),
                onChanged: (value) {
                  ref.read(reminderProvider.notifier).updateRepeatOption(value ?? 'None');
                },
              ),
              if (reminderState.repeatOption == 'Custom')
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    ref.read(reminderProvider.notifier).updateRepeatOption(
                        'Custom', interval: int.tryParse(value) ?? 1);
                  },
                  decoration: InputDecoration(labelText: 'Custom Interval (Days)'),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LocalNotification.scheduleNotification(
                    payload: "Event Reminder Payload",
                    title: "Event Reminder",
                    body: "You have an event in your calendar!",
                    reminderValue: reminderState.reminderValue,
                    selectedUnit: reminderState.selectedUnit,
                    repeatOption: reminderState.repeatOption,
                    customInterval: reminderState.customInterval,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reminder Set!', style: GoogleFonts.poppins())),
                  );
                },
                child: Text('Confirm Reminder', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  runApp(ProviderScope(child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomReminderScreen(),
  )));
}
