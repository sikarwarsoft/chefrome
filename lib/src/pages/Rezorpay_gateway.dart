import 'package:markets/src/repository/passbook_repository.dart';

import '../repository/user_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class payment extends StatefulWidget {
  @override
  _paymentState createState() => _paymentState();
}

class _paymentState extends State<payment> {
  Razorpay _razorpay;
  bool payment_done;
  String amount;
  GlobalKey<FormState> loginFormKey = GlobalKey();
  void payment_success() {}
  void initState() {
    payment_done = false;
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_8POfYuGvNGzZH9',
      'amount': int.parse(amount) * 100,
      'name': 'Chefrome',
      'description': 'Wallet',
      'prefill': {
        'contact': '${currentUser.value.phone}',
        'email': '${currentUser.value.email}'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      payment_done = true;
    });
    addMoney(int.parse(amount), 'RazorPay').then((value) {
      Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Payment',
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
          )),
      body: Stack(
        children: <Widget>[
          payment_done
              ? Center(child: Text('Payment Success'))
              : Center(
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Enter Amount You Want to Add.',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .merge(TextStyle(
                                letterSpacing: 1.3,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (input) => amount = input,
                            validator: (input) => input.length < 0
                                ? 'Amount should be more than 0'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Amount', //S.of(context).email,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '1000',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        InkWell(
                          onTap: () {
                            if (loginFormKey.currentState.validate()) {
                              loginFormKey.currentState.save();
                              openCheckout();
                            }
                          },
                          child: Container(
                            height: 40,
                            width: size.width * .50,
                            child: Center(
                              child: Text(
                                'Make Payment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.white10,
                              ),
                              // color: Colors.black26,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.2, 1],
                                colors: [
                                  Theme.of(context).accentColor,
                                  Theme.of(context).buttonColor
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
