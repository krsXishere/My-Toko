import 'package:flutter/material.dart';

class DatePickerProvider with ChangeNotifier {
  DateTime _starDate = DateTime.now();
  DateTime get starDate => _starDate;
  DateTime _endDate = DateTime.now();
  DateTime get endDate => _endDate;

  Future<void> setSelectedDate(DateTime starDate, DateTime endDate) async {
    _starDate = starDate;
    _endDate = endDate;
    notifyListeners();
  }
}