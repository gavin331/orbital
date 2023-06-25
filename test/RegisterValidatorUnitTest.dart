// Unit test for validators used in the Register screen.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Username Validator Testing', () {
    String? usernameValidator (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

    test('Empty username', () {
      String? result = usernameValidator('');
      expect(result, 'Please enter a username');
    });

    test('Null username', () {
      String? result = usernameValidator(null);
      expect(result, 'Please enter a username');
    });

    test('Valid username', () {
      String? result = usernameValidator('Michael');
      expect(result, null);
    });
  });

  group('Email Validator Testing', () {
    //Email format is correct when there is @ and a domain(<anything>.com).
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

    test('Invalid email format 1', () {
      String? result = emailValidator('Michael');
      expect(result, 'Please enter a valid email');
    });

    test('Invalid email format 2', () {
      String? result = emailValidator('123');
      expect(result, 'Please enter a valid email');
    });

    test('Valid email format 1', () {
      String? result = emailValidator('Michael@gmail.com');
      expect(result, null);
    });

    test('Valid email format 2', () {
      String? result = emailValidator('Michael@g.com');
      expect(result, null);
    });
  });

  group('Password validator testing', () {
    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      } else if (value.length < 6) {
        return 'Password length must be at least 6 characters';
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

    test('Password with 5 characters', () {
      String? result = passwordValidator('12345');
      expect(result, 'Password length must be at least 6 characters');
    });

    test('Password with 1 characters', () {
      String? result = passwordValidator('1');
      expect(result, 'Password length must be at least 6 characters');
    });

    test('Password with 6 numbers', () {
      String? result = passwordValidator('123456');
      expect(result, null);
    });

    test('Password with 6 characters', () {
      String? result = passwordValidator('gggggg');
      expect(result, null);
    });

    test('Password with 6 special characters', () {
      String? result = passwordValidator('!@#*%^');
      expect(result, null);
    });
  });

  group('Confirm password validator testing', () {
    //_password is a dummy variable to simulate the test.
    TextEditingController _password = TextEditingController(text: '  helloWorld  ');
    String? confirmPasswordValidator (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      } else if (value != _password.text){
        return 'Password do not match!';
      } else {
        return null;
      }
    }

    test('Null confirm password', () {
      String? result = confirmPasswordValidator(null);
      expect(result, 'Please confirm your password');
    });

    test('Empty confirm password', () {
      String? result = confirmPasswordValidator('');
      expect(result, 'Please confirm your password');
    });

    test('Non-matching confirm password', () {
      String? result = confirmPasswordValidator('hello');
      expect(result, 'Password do not match!');
    });

    test('Non-matching case sensitive confirm password', () {
      String? result = confirmPasswordValidator('helloworld');
      expect(result, 'Password do not match!');
    });

    test('Matching confirm password with whitespace', () {
      String? result = confirmPasswordValidator('  helloWorld  ');
      expect(result, null);
    });

    test('Matching confirm password without whitespace', () {
      String? result = confirmPasswordValidator('helloWorld');
      expect(result, 'Password do not match!');
    });
  });
}