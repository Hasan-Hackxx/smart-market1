import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/Pages/DeleviryPage.dart';
import 'package:smartmarket1/components/mybutton.dart';

class PaymentPage extends StatefulWidget {
  final String otheruserEmail;
  final String otheruserId;
  const PaymentPage({
    super.key,
    required this.otheruserEmail,
    required this.otheruserId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvfocesed = false;

  void userTapped() {
    if (formkey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Payment..!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Card Number : $cardNumber'),
                Text('Expire Date : $expiryDate'),
                Text('Card Holder name  : $cardHolderName'),
                Text('Cvv : $cvvCode'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Delevirypage(
                      otheruserEmail: widget.otheruserEmail,
                      otheruserId: widget.otheruserId,
                    ),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: Text('Check out')),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          CreditCardForm(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            onCreditCardModelChange: (data) {
              setState(() {
                cardNumber = data.cardNumber;
                expiryDate = data.expiryDate;
                cardHolderName = data.cardHolderName;
                cvvCode = data.cvvCode;
              });
            },
            formKey: formkey,
          ),

          Spacer(),
          Mybutton(text: 'pay Now', onPressed: userTapped),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
