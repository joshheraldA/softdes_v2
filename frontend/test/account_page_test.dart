import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/view/account_page.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  late User testUser;
  late DashboardViewModel dashboardViewModel;

  setUp(() {
    testUser = User(
      username: 'James',
      department: 'Computer Engineering',
      role: 'Student',
      cesPoints: 10,
      cesParticipating: [],
      email: 'james@test.com',
      uid: '123',
    );

    dashboardViewModel = DashboardViewModel();
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
      value: dashboardViewModel,
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(child: AccountPage(user: testUser)),
        ),
      ),
    );
  }

  testWidgets('displays user information correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('James'), findsOneWidget);
    expect(find.text('james@test.com'), findsOneWidget);
    expect(find.text('Student'), findsOneWidget);
    expect(find.text('Computer Engineering'), findsOneWidget);
  });

  testWidgets('shows logout button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Log out'), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('shows empty activity state when no activities exist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Attended Activities'), findsOneWidget);
    expect(find.text('No activities joined yet'), findsOneWidget);
    expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
  });

  testWidgets('shows activities when activitiesParticipating is not empty', (
    WidgetTester tester,
  ) async {
    dashboardViewModel.activitiesParticipating.addAll([
      {
        'title': 'Tree Planting Activity',
        'type': 'Community',
        'date': {'month': 'May', 'day': 20, 'year': 2026},
      },
      {
        'title': 'Programming Seminar',
        'type': 'Seminar',
        'date': {'month': 'June', 'day': 5, 'year': 2026},
      },
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Tree Planting Activity'), findsOneWidget);
    expect(find.text('Programming Seminar'), findsOneWidget);

    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Seminar'), findsOneWidget);

    expect(find.text('May 20, 2026'), findsOneWidget);
    expect(find.text('June 5, 2026'), findsOneWidget);
  });

  testWidgets('renders activity list correctly', (WidgetTester tester) async {
    dashboardViewModel.activitiesParticipating.add({
      'title': 'Hackathon',
      'type': 'Competition',
      'date': {'month': 'July', 'day': 10, 'year': 2026},
    });

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Hackathon'), findsOneWidget);
    expect(find.text('Competition'), findsOneWidget);
    expect(find.text('July 10, 2026'), findsOneWidget);
  });

  testWidgets('profile avatar is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person_rounded), findsOneWidget);
  });

  testWidgets('activity tile displays fallback date when missing', (
    WidgetTester tester,
  ) async {
    dashboardViewModel.activitiesParticipating.add({
      'title': 'Missing Date Activity',
      'type': 'General',
    });

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Missing Date Activity'), findsOneWidget);
    expect(find.text('—'), findsWidgets);
  });
}
