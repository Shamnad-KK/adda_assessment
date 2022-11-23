import 'dart:developer';

import 'package:adda_assessment/utils/app_popups.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/facility_model.dart';

class BookingController extends ChangeNotifier {
  TextEditingController dateController = TextEditingController();

  List<String> facilityList = [
    'Clubhouse',
    'Tennis Court',
  ];

  String? dropdownValue;

  double price = 0;
  int totalHoursPlayed = 0;
  double temp = 0;

  void changeFacility(String? newValue) {
    dropdownValue = newValue!;
    notifyListeners();
  }

  DateTime? dateTime;

  Future<DateTime?> pickDate(BuildContext context) async {
    DateTime? result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2023));
    if (result != null) {
      dateTime = result;
      dateController.text = DateFormat('dd.MM.yy').format(dateTime!);
      notifyListeners();
      return dateTime;
    }
    return null;
  }

  List<Facility> bookingsList = [];

  void bookSlots(Facility facility) async {
    double startTime = double.parse(startingDropdown!);
    double endTime = double.parse(endingDropdown!);
    int end = endTime.floor();
    int start = startTime.floor();
    if (end <= start) {
      AppPopups.showToast(msg: 'Invalid entry');
      price = 0;
      notifyListeners();
      return;
    }
    calculateTime();
    notifyListeners();

    if (!validate()) {
      return;
    }

    bookingsList.add(facility);
    price = 0;

    totalHoursPlayed = 0;
    temp = 0;
    dropdownValue = null;
    startingDropdown = null;
    endingDropdown = null;
    dateTime = null;
    dateController.clear();
    notifyListeners();
  }

  bool validate() {
    final start = double.parse(startingDropdown!);
    final end = double.parse(endingDropdown!);
    List<double> clubHouseStartingTimeList = bookingsList
        .map((e) => e.name == 'Clubhouse' ? double.parse(e.startingTime) : 0.0)
        .toList();
    List<double> clubHouseEndingTimeList = bookingsList
        .map((e) => e.name == 'Clubhouse' ? double.parse(e.endingTime) : 0.0)
        .toList();

    List<double> tennisCourtStartingTimeList = bookingsList
        .map((e) =>
            e.name == 'Tennis Court' ? double.parse(e.startingTime) : 0.0)
        .toList();
    List<double> tennisCourtEndingTimeList = bookingsList
        .map((e) => e.name == 'Tennis Court' ? double.parse(e.endingTime) : 0.0)
        .toList();

    List<String> dateList = bookingsList.map((e) => e.date).toList();
    log(dateList.toString());
    if (bookingsList.isNotEmpty) {
      if (dropdownValue == 'Clubhouse') {
        if (((clubHouseStartingTimeList
                .every((element) => start < element && end <= element) ||
            clubHouseEndingTimeList
                .every((element) => start >= element && end >= element)))) {
          return true;
        } else if (dateList.every(
            (element) => DateFormat('dd.MM.yy').format(dateTime!) != element)) {
          return true;
        } else {
          AppPopups.showToast(msg: 'Already booked');
          return false;
        }
      } else if (dropdownValue == 'Tennis Court') {
        if (((tennisCourtStartingTimeList
                .every((element) => start < element && end <= element) ||
            tennisCourtEndingTimeList
                .every((element) => start >= element && end >= element)))) {
          return true;
        } else if (dateList.every(
            (element) => DateFormat('dd.MM.yy').format(dateTime!) != element)) {
          return true;
        } else {
          AppPopups.showToast(msg: 'Already booked');
          return false;
        }
      }
    }
    return true;
  }

  String? startingDropdown;

  List<String> startingTimeDropdownList = [
    '10.00',
    '11.00',
    '12.00',
    '13.00',
    '14.00',
    '15.00',
    '16.00',
    '17.00',
    '18.00',
    '19.00',
    '20.00',
    '21.00',
    '22.00',
  ];

  void changeStartingtime(String? newValue) {
    startingDropdown = newValue!;
    if (endingDropdown != null) {
      calculateTime();
    }

    notifyListeners();
  }

  String? endingDropdown;

  List<String> endingTimeDropdownList = [
    '10.00',
    '11.00',
    '12.00',
    '13.00',
    '14.00',
    '15.00',
    '16.00',
    '17.00',
    '18.00',
    '19.00',
    '20.00',
    '21.00',
    '22.00',
  ];

  void changeEndingtime(String? newValue) {
    endingDropdown = newValue!;
    if (startingDropdown != null) {
      calculateTime();
    }
    notifyListeners();
  }

  void calculateTime() {
    double startTime = double.parse(startingDropdown!);
    double endTime = double.parse(endingDropdown!);

    int end = endTime.floor();
    int start = startTime.floor();

    if (end < start) {
      AppPopups.showToast(msg: 'Invalid entry');
      return;
    }

    totalHoursPlayed = end - start;
    int differenceAfter4 = 0;
    int differenceBefore4 = 0;
    if (dropdownValue == "Clubhouse") {
      if (start < 16 && end > 16) {
        differenceAfter4 = end - 16;
        differenceBefore4 = totalHoursPlayed - differenceAfter4;
        double t = (differenceBefore4 * 100) + (differenceAfter4 * 500);

        price = t;
      } else {
        price = start > 16 ? totalHoursPlayed * 500 : totalHoursPlayed * 100;
      }
    } else {
      price = totalHoursPlayed * 50;
    }

    notifyListeners();
  }
}
