import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// this entity class will hold email and password for EmailSignup and EmailLogin UseCase
class EmailAuthParams extends Equatable {
  /// email to use for login
  final String email;

  /// password to use for login
  final String password;

  /// first name to use for login
  final String fName;

  /// last name to use for login
  final String lName;

  EmailAuthParams(
      {required this.email,
      required this.password,
      required this.fName,
      required this.lName});

  @override
  List<Object> get props => [email, password, fName, lName];
}
