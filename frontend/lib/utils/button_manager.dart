import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';

abstract class ButtonClass { 
  abstract Color color;
  abstract String text;

  // We pass the active ViewModel here to ensure the UI updates
  void clicked(DashboardViewModel vm, String uid, String activityUid, List<dynamic> userActivities);
}

class JoinButton extends ButtonClass {
  @override
  Color color = const Color.fromARGB(255, 171, 220, 175);
  @override
  String text = "Join";

  @override
  void clicked(DashboardViewModel vm, String uid, String activityUid, List<dynamic> userActivities) {
    vm.joinActivity(uid, activityUid, userActivities);
  }
}

class LeaveButton extends ButtonClass {
  @override
  Color color = const Color.fromARGB(255, 214, 173, 170);
  @override
  String text = "Leave";
  
  @override
  void clicked(DashboardViewModel vm, String uid, String activityUid, List<dynamic> userActivities) {
    vm.leaveActivity(uid, activityUid, userActivities);
  }
}

class DefaultButton extends ButtonClass {
  @override
  Color color = const Color.fromARGB(255, 220, 220, 220);
  @override
  String text = "Button";

  @override
  void clicked(DashboardViewModel vm, String uid, String activityUid, List<dynamic> userActivities) {
    vm.getActivities(userActivities);
  }
}

class ButtonManager { 
  static ButtonClass checkButton(String type) {
    switch (type) {
      case "Join": return JoinButton();
      case "Leave": return LeaveButton();
      default: return DefaultButton();
    }
  }
}