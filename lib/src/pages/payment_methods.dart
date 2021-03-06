import 'package:flutter/material.dart';
import 'package:markets/src/controllers/profile_controller.dart';
import 'package:markets/src/pages/wallet_checkout.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  PaymentMethodsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends StateMVC<PaymentMethodsWidget> {
  PaymentMethodList list;
  ProfileController _con;

  _PaymentMethodsWidgetState() : super(ProfileController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    if (!setting.value.payPalEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "paypal";
      });
    if (!setting.value.razorPayEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "razorpay";
      });
    if (!setting.value.stripeEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "visacard" || element.id == "mastercard";
      });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).payment_mode,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'wallet',
//                  S.of(context).p/ayment_options,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle:
                    Text(S.of(context).select_your_preferred_payment_mode),
              ),
            ),
            InkWell(
              splashColor: Theme.of(context).accentColor,
              focusColor: Theme.of(context).accentColor,
              highlightColor: Theme.of(context).primaryColor,
              onTap: () {
                _con.isLoading?null:
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WalletCheckout(balance: _con.passBookDetails.data['ewallet_amount'])));
//            Navigator.of(context).pushNamed(this.paymentMethod.route);
//            print(widget.routeArgument.id);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
//                    image: DecorationImage(image: AssetImage(paymentMethod.logo), fit: BoxFit.fill),
                      ),
                      child: Icon(Icons.account_balance_wallet),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Wallet',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  'Click to pay with your Wallet',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          _con.isLoading
                              ? Text('Loading...')
                              : Text(
                                  '${_con.passBookDetails.data['ewallet_amount']}'.substring(0,5),
                                  style: TextStyle(fontSize: 20),
                                ),
//                      Icon(
//                        Icons.keyboard_arrow_right,
//                        color: Theme.of(context).focusColor,
//                      ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            list.paymentsList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.payment,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).payment_options,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                          S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.paymentsList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                    paymentMethod: list.paymentsList.elementAt(index));
              },
            ),
            list.cashList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).cash_on_delivery,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                          S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.cashList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                    paymentMethod: list.cashList.elementAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
