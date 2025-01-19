import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// StateNotifier to manage reminder data
class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier()
      : super(ReminderState(
    selectedUnit: 'Minutes',
    reminderValue: 10,
    repeatOption: 'None',
    customInterval: 1,
  ));

  // Update unit of time
  void updateUnit(String unit) {
    state = ReminderState(
      selectedUnit: unit,
      reminderValue: state.reminderValue,
      repeatOption: state.repeatOption,
      customInterval: state.customInterval,
    );
  }

  // Update reminder value (e.g., 10 minutes)
  void updateValue(int value) {
    state = ReminderState(
      selectedUnit: state.selectedUnit,
      reminderValue: value,
      repeatOption: state.repeatOption,
      customInterval: state.customInterval,
    );
  }

  // Update repeat option and interval for custom repeats
  void updateRepeatOption(String option, {int interval = 1}) {
    state = ReminderState(
      selectedUnit: state.selectedUnit,
      reminderValue: state.reminderValue,
      repeatOption: option,
      customInterval: option == 'Custom' ? interval : 1,
    );
  }
}

// Create a provider for the ReminderNotifier
final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});
