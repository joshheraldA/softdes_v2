import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get index => _selectedIndex;

  dynamic _box = [];
  List<dynamic> _activitiesParticipating = [];
  List<dynamic> get activitiesParticipating => _activitiesParticipating;
  dynamic get boxes => _box;

  void updatePage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> getActivities(List<dynamic> uids) async {
    try {
      final url = "http://127.0.0.1:8000/api/v1/get-ces/";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          List<dynamic> incomingData = responseData['data'];

          _box = incomingData.where((activity) {
            return !uids.contains(activity['uid']); 
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching activities: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> joinActivity(String uid, String cesUid, List<dynamic> uids) async {
    final String url = "http://127.0.0.1:8000/api/v1/add-participant/";
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "uid": uid,
          "ces_uid": cesUid 
        })
      );

      if (response.statusCode == 200) {
        debugPrint("Join successful, refreshing list...");
        // This 'await' now works because getActivities returns a Future
        await getActivities(uids); 

        if (!uids.contains(cesUid)) {
          uids.add(cesUid);
        }


        
        await joinedActivities(uids);
      } else {
        debugPrint("Join failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error joining: $e");
    }
  }

  Future<void> joinedActivities(List<dynamic> uids) async {
    try {
      _activitiesParticipating = [];
      final requests = uids.map((uid) {
        final url = Uri.parse("http://127.0.0.1:8000/api/v1/find-activity/?uid=$uid");
        return http.get(url);     
      }).toList();

      final responses = await Future.wait(requests);

      for (var response in responses) { 
         if(response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if(data['status'] == true) {
              _activitiesParticipating.add(data['data']);
            }
         }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

  Future<void> leaveActivity(String uid, String cesUid, List<dynamic> uids) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/leave-activity/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": uid,
          "ces_uid": cesUid,
        }),
      );

      if (response.statusCode == 200) {
        await getActivities(uids);

        uids.remove(cesUid); // opposite of uids.add(cesUid) in joinActivity

        await joinedActivities(uids);
      }
    } catch (e) {
      print(e);
    }
  }
}
