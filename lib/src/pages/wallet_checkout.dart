import 'package:flutter/material.dart';
import 'package:markets/src/repository/passbook_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class WalletCheckout extends StatefulWidget {
  final  balance;
  WalletCheckout({this.balance});
//  RouteArgument routeArgument;
//  WalletCheckout({Key key, this.routeArgument}) : super(key: key);
  @override
  _WalletCheckoutState createState() => _WalletCheckoutState();
}

class _WalletCheckoutState extends StateMVC<WalletCheckout> {
  CheckoutController _con;

  _WalletCheckoutState() : super(CheckoutController()) {
    _con = controller;
  }
  bool _isPaying;
  @override
  void initState() {
    _con.listenForCarts();
    _isPaying = false;
    super.initState();
  }

  bool checkPayable() {
    if (widget.balance > _con.total) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wallet',
//          S.of(context).checkout,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: _con.carts.isEmpty
          ? CircularLoadingWidget(height: 400)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 255),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.payment,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S.of(context).select_your_preferred_payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
//                  new CreditCardsWidget(
//                      creditCard: _con.creditCard,
//                      onChanged: (creditCard) {
//                        _con.updateCreditCard(creditCard);
//                      }),
                        Center(
                            child: Text(
                          'Available Balance',
                          style: Theme.of(context).textTheme.headline4,
                        )),
                        SizedBox(height: 40),
                        Text(
                          '${widget.balance}'.substring(0,5),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 50),
                        ),
                        SizedBox(height: 20),
                        checkPayable()
                            ? SizedBox()
                            : Center(
                                child: Text(
                                'Low Balance. Add ${_con.total - widget.balance} to continue checkout',
                                style: Theme.of(context).textTheme.headline6,
                              )),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 320,
                          child: FlatButton(
                              onPressed: () {
//                        Navigator.of(context).pushReplacementNamed('/PayPal');
                              },
                              padding: EdgeInsets.symmetric(vertical: 12),
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.2),
                              shape: StadiumBorder(),
                              child: Text(
                                'Add Money',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 255,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: Offset(0, -2),
                              blurRadius: 5.0)
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).subtotal,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.subTotal, context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(
                                  _con.carts[0].product.market.deliveryFee,
                                  context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.taxAmount, context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          Divider(height: 30),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).total,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              Helper.getPrice(_con.total, context,
                                  style: Theme.of(context).textTheme.headline6)
                            ],
                          ),
                          SizedBox(height: 20),
                          widget.balance > _con.total
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPaying = !_isPaying;
                                      });
                                      var result =
                                          useMoney(_con.total).then((result) {
                                        if (result.status) {
                                          Navigator.of(context).pushNamed(
                                              '/OrderSuccess',
                                              arguments: new RouteArgument(
                                                  param:
                                                      'Payed through Wallet'));
                                        } else {
                                          setState(() {
                                            _isPaying = !_isPaying;
                                          });
                                          showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                elevation: 9,
                                                title: Text('ERROR'),
                                                content: Text('${result.msg}'),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok'))
                                                ],
                                              ));
                                        }
                                      });
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    color: Theme.of(context).accentColor,
                                    shape: StadiumBorder(),
                                    child: Text(
                                      S.of(context).confirm_payment,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: FlatButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    color: Colors.grey,
                                    shape: StadiumBorder(),
                                    child: Text(
                                      S.of(context).confirm_payment,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                _isPaying
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox()
              ],
            ),
    );
  }
}
