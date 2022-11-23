import 'package:adda_assessment/controller/booking_controller.dart';
import 'package:adda_assessment/model/facility_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Testing bookings are working fine',
    () {
      test(
        "Testing if the booked slots are added to the list or not",
        () {
          //Arrange
          Facility facility = Facility(
            name: 'Clubhouse',
            price: 100,
            date: '23.11.22',
            startingTime: '11.00',
            endingTime: '12.00',
          );

          int expectingCount = 1;

          //Act
          BookingController().bookingsList.add(facility);

          //Assert
          expect(BookingController().bookingsList.length, expectingCount);
        },
      );
    },
  );
}
