import 'dart:convert';
import 'package:demo/key_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishable_key;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stripe Payment Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await makePayment();
          },
          child: const Text("Pay Now"),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(
        '100',
        'INR',
      ); // Amount in rupees
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Evento',
        ),
      );
      displayPaymentSheet();
    } catch (e, s) {
      debugPrint('Exception: $e\n$s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Success"),
              content: const Text("Payment completed successfully!"),
            ),
      );
    } on StripeException catch (e) {
      debugPrint("Error from Stripe: ${e.error.localizedMessage}");
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text("Payment Failed"),
              content: Text("Payment was cancelled or failed."),
            ),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(), // convert to paisa
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secret_key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (err) {
      throw Exception('Error creating payment intent: $err');
    }
  }
}
