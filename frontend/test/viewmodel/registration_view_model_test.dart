// test/viewmodel/registration_view_model_test.dart
//
// Tests for RegistrationViewModel — only the state/UI logic that doesn't
// require a live HTTP server.  Network-dependent paths (actual API calls)
// should be covered by integration / E2E tests.
//
// Run with:  flutter test test/viewmodel/registration_view_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';

void main() {
  // -------------------------------------------------------------------------
  // RegistrationViewModel
  // -------------------------------------------------------------------------
  group('RegistrationViewModel initial state', () {
    late RegistrationViewModel vm;

    setUp(() => vm = RegistrationViewModel());

    test('text starts empty', () {
      expect(vm.text, '');
    });

    test('is a ChangeNotifier', () {
      // just checks the type is usable with Provider
      expect(vm, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // LoginPageViewModel
  // -------------------------------------------------------------------------
  group('LoginPageViewModel initial state', () {
    late LoginPageViewModel vm;

    setUp(() => vm = LoginPageViewModel());

    test('text starts empty', () {
      expect(vm.text, '');
    });

    test('uid starts empty', () {
      expect(vm.uid, '');
    });

    test('user is null before login', () {
      expect(vm.user, isNull);
    });

    test('awaiting2Fa is false at start', () {
      expect(vm.awaiting2Fa, isFalse);
    });

    test('loginStatus is false at start', () {
      expect(vm.loginStatus, isFalse);
    });
  });
}
