import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking/data/api/api_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: PaymentScreen()));

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: ${response.paymentId}");
    // ✅ Optionally notify backend to credit wallet
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: ${response.walletName}");
  }

  void _showAddMoneyBottomSheet(BuildContext context) {
    TextEditingController amountController = TextEditingController(text: "50");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Add Money", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  "Park In Wallet can only be used to pay for parking lot and rental parks",
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixText: "₹",
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [100, 200, 500].map((amount) {
                    return ElevatedButton(
                      onPressed: () {
                        amountController.text = amount.toString();
                      },
                      child: Text("₹$amount"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String enteredAmount = amountController.text;
                      Navigator.pop(context);
                      int amount = int.tryParse(enteredAmount) ?? 50;

                      // 🔗 Replace with your backend order creation API
                      final response = await http.post(
                        Uri.parse(payment_create),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({"amount": amount}),
                      );

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);

                        var options = {
                          'key': 'rzp_test_TXha1iNsfNWYWy',
                          'amount': amount * 100,
                          'order_id': data['id'],
                          'name': 'Park In Wallet',
                          'description': 'Wallet Recharge',
                          'prefill': {
                            'contact': '9940367541',
                            'email': 'prasanawhitedevil007@gmail.com',
                          }
                        };

                        _razorpay.open(options);
                      } else {
                        print("Order creation failed: ${response.body}");
                      }
                    },
                    child: Text("Add Money"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget walletCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(Icons.account_balance_wallet_rounded, color: Colors.black),
            SizedBox(width: 10),
            Text("ParkIn Wallet", style: GoogleFonts.poppins(fontSize: 16)),
            Spacer(),
            Text("Low Balance: ₹0.0", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _showAddMoneyBottomSheet(context),
          icon: Icon(Icons.add),
          label: Text("Add Money"),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ]),
    );
  }

  Widget linkedWalletCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(Icons.payment, color: Colors.black),
            SizedBox(width: 10),
            Text("AmazonPay", style: GoogleFonts.poppins(fontSize: 16)),
            Spacer(),
            Text("LINK", style: TextStyle(color: Colors.blue)),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Cashback behind scratch card upto ₹25, assured ₹5 | min order ₹39 | once/month",
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ]),
    );
  }

  Widget upiCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.send_to_mobile, color: Colors.black),
          SizedBox(width: 10),
          Text("GPay", style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }

  Widget cashCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.money, color: Colors.black),
          SizedBox(width: 10),
          Text("Cash", style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text('Payments', style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Wallets'),
            walletCard(context),
            SizedBox(height: 16),
            sectionTitle('Linked Wallets'),
            linkedWalletCard(),
            SizedBox(height: 24),
            sectionTitle('Pay by any UPI app'),
            upiCard(),
            SizedBox(height: 24),
            sectionTitle('Others'),
            cashCard(),
          ],
        ),
      ),
    );
  }
}
