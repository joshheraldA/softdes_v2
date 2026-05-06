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

  // FIXED: Changed from 'void' to 'Future<void>'
  Future<void> getActivities() async {
    try {
      final url = "http://127.0.0.1:8000/api/v1/get-ces/";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          _box = responseData['data'];
        }
      }
    } catch (e) {
      print("Error fetching activities: $e");
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
        print("Join successful, refreshing list...");
        // This 'await' now works because getActivities returns a Future
        await getActivities(); 

        if (!uids.contains(cesUid)) {
          uids.add(cesUid);
        }


        
        await joinedActivities(uids);
      } else {
        print("Join failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error joining: $e");
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
}