import 'package:flutter/material.dart';
import 'select_cleaner.dart';

class AboutYourOrder extends StatefulWidget {
  final String address;
  final DateTime dateTime;

  const AboutYourOrder({super.key, required this.address, required this.dateTime});

  @override
  _AboutYourOrderState createState() => _AboutYourOrderState();
}

class _AboutYourOrderState extends State<AboutYourOrder> {
  int _rooms = 0;
  int _bathrooms = 0;
  int _windows = 0;
  bool _kitchen = false;
  bool _insideCabinets = false;
  bool _insideFridge = false;
  bool _insideOven = false;
  bool _laundry = false;

  // Pricing constants
  static const double pricePerRoom = 600.0;
  static const double pricePerBathroom = 1000.0;
  static const double pricePerWindow = 200.0;
  static const double pricePerAdditionalService = 800.0;

  // Calculate total price based on selections
  double getTotalPrice() {
    double total = 0.0;
    total += _rooms * pricePerRoom;
    total += _bathrooms * pricePerBathroom;
    total += _windows * pricePerWindow;
    total += (_kitchen ? pricePerAdditionalService : 0.0);
    total += (_insideCabinets ? pricePerAdditionalService : 0.0);
    total += (_insideFridge ? pricePerAdditionalService : 0.0);
    total += (_insideOven ? pricePerAdditionalService : 0.0);
    total += (_laundry ? pricePerAdditionalService : 0.0);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("About your order"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rooms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rooms",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_rooms > 0) {
                          setState(() {
                            _rooms--;
                          });
                        }
                      },
                    ),
                    Text(
                      _rooms.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _rooms++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bathrooms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bath rooms",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_bathrooms > 0) {
                          setState(() {
                            _bathrooms--;
                          });
                        }
                      },
                    ),
                    Text(
                      _bathrooms.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _bathrooms++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Windows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Windows",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_windows > 0) {
                          setState(() {
                            _windows--;
                          });
                        }
                      },
                    ),
                    Text(
                      _windows.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _windows++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Additional Services
            CheckboxListTile(
              title: const Text("Kitchen"),
              value: _kitchen,
              onChanged: (bool? value) {
                setState(() {
                  _kitchen = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Inside cabinets"),
              value: _insideCabinets,
              onChanged: (bool? value) {
                setState(() {
                  _insideCabinets = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Inside fridge"),
              value: _insideFridge,
              onChanged: (bool? value) {
                setState(() {
                  _insideFridge = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Inside oven"),
              value: _insideOven,
              onChanged: (bool? value) {
                setState(() {
                  _insideOven = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Laundry wash & dry"),
              value: _laundry,
              onChanged: (bool? value) {
                setState(() {
                  _laundry = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 32),

            // Display Total Price
            Text(
              "Total Price: LKR ${getTotalPrice().toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Continue Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to SelectCleaner screen with address, dateTime, and calculated amount
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCleaner(
                        address: widget.address,
                        dateTime: widget.dateTime,
                        amount: getTotalPrice(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

