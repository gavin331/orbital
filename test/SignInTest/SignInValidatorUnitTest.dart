// Unit test for validators used in the Sign In screen.
import 'package:flutter_test/flutter_test.dart';

void main(){
  //Test for email and password validators in the sign in screen.
  group('Email Validator Testing', () {
    String? emailValidator (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',)
          .hasMatch(value)){
        return 'Please enter a valid email';
      }
      return null;
    }

    test('Empty email', () {
      String? result = emailValidator('');
      expect(result, 'Please enter an email');
    });

    test('Null email', () {
      String? result = emailValidator(null);
      expect(result, 'Please enter an email');
    });

    test('Invalid email format', () {
      String? result = emailValidator('gavin');
      expect(result, 'Please enter a valid email');
    });

    test('Valid email format', () {
      String? result = emailValidator('gg@gmail.com');
      expect(result, null);
    });

    test('Valid email format', () {
      String? result = emailValidator('gg@yahoo.com');
      expect(result, null);
    });

    test('Valid email format', () {
      String? result = emailValidator('gg@yy.com');
      expect(result, null);
    });
  });

  group('Password validator test', () {
    String? passwordValidator (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      } else {
        return null;
      }
    }

    test('Null password', () {
      String? result = passwordValidator(null);
      expect(result, 'Please enter a password');
    });

    test('Empty password', () {
      String? result = passwordValidator('');
      expect(result, 'Please enter a password');
    });


    test('Valid password 1', () {
      String? result = passwordValidator('asdasd');
      expect(result, null);
    });

    test('Valid password 2', () {
      String? result = passwordValidator('1234567');
      expect(result, null);
    });
  });
}

