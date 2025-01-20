import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
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
    final reminderState = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text('Set Custom Reminder', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Reminder Time:', style: GoogleFonts.poppins(fontSize: 18)),
              SizedBox(height: 12,),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(reminderProvider.notifier).updateValue(int.tryParse(value) ?? 10);
                },
                decoration: InputDecoration(
                  hintText: 'Enter value',
                  hintStyle: GoogleFonts.poppins(),
                  labelStyle: GoogleFonts.poppins(),
                  labelText: 'Enter value',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                    gapPadding: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('Unit:', style: GoogleFonts.poppins(fontSize: 12)),
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
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(height: 5),
                      Text('Repeat Option:', style: GoogleFonts.poppins(fontSize: 12)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
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
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              if (reminderState.repeatOption == 'Custom')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Custom Interval (Days):', style: GoogleFonts.poppins(fontSize: 18)),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        ref.read(reminderProvider.notifier).updateRepeatOption(
                            'Custom', interval: int.tryParse(value) ?? 1);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter custom interval',
                        hintStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 40),
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Reminder Set!', style: GoogleFonts.poppins()),
                  ));
                },
                child: Text('Set Reminder', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  runApp(ProviderScope(child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomReminderScreen())));
}
