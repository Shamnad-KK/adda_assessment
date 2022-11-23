import 'package:adda_assessment/controller/booking_controller.dart';
import 'package:adda_assessment/model/facility_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController =
        Provider.of<BookingController>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book your slot"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Consumer<BookingController>(
                  builder:
                      (BuildContext context, bookingConsumer, Widget? child) {
                    return DropdownButtonFormField(
                      value: bookingConsumer.dropdownValue,
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose a facility';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: 'Choose a Facility'),
                      items: bookingConsumer.facilityList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (newValue) {
                        bookingConsumer.changeFacility(newValue);
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                Consumer<BookingController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return TextFormField(
                      controller: bookingController.dateController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Date',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await value.pickDate(context);
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                      readOnly: true,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<BookingController>(
                        builder: (BuildContext context, bookingConsumer,
                            Widget? child) {
                          return DropdownButtonFormField(
                            value: bookingConsumer.startingDropdown,
                            validator: (value) {
                              if (value == null) {
                                return "Please select a starting time";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Starting time',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            items: bookingConsumer.startingTimeDropdownList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              bookingConsumer.changeStartingtime(newValue);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Consumer<BookingController>(
                        builder: (BuildContext context, bookingConsumer,
                            Widget? child) {
                          return DropdownButtonFormField(
                            value: bookingConsumer.endingDropdown,
                            validator: (value) {
                              if (value == null) {
                                return "Please select an ending time";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Ending time',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            items: bookingConsumer.endingTimeDropdownList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              bookingConsumer.changeEndingtime(newValue);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<BookingController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Text('${value.price.round()} rs');
                  },
                ),
                const SizedBox(height: 10),
                Consumer<BookingController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Facility facility = Facility(
                              name: value.dropdownValue!,
                              price: value.price,
                              date: value.dateController.text,
                              startingTime: value.startingDropdown!,
                              endingTime: value.endingDropdown!);
                          bookingController.bookSlots(facility);
                        }
                      },
                      child: const Text('Book'),
                    );
                  },
                ),
                Expanded(
                  child: Consumer<BookingController>(
                    builder: (context, value, child) {
                      return value.bookingsList.isEmpty
                          ? const Center(
                              child: Text('No bookings'),
                            )
                          : ListView.builder(
                              itemCount: value.bookingsList.length,
                              itemBuilder: (context, index) {
                                final booking = value.bookingsList[index];
                                return ListTile(
                                  title: Text(booking.name),
                                  subtitle: Text(
                                      "${booking.date}   ${booking.startingTime} - ${booking.endingTime}"),
                                  trailing: Text("Rs ${booking.price}"),
                                );
                              },
                            );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
