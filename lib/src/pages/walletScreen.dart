import 'package:flutter/material.dart';
import '../elements/PermissionDeniedWidget.dart';
import 'Rezorpay_gateway.dart';
import '../repository/user_repository.dart';
import '../controllers/profile_controller.dart';
import '../elements/TransactionItemWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends StateMVC<WalletScreen> {
  ProfileController _con;
  _WalletScreenState() : super(ProfileController()) {
    _con = controller;
  }
  bool _isDebit;
  @override
  void initState() {
    // TODO: implement initState
    _isDebit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Wallet Info',
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>payment()));
        },
        label: Text("Add Money",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0, color: Colors.transparent),
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _con.isLoading
                                ? Text(currentUser.value.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white))
                                : Text(
                                    '${_con.passBookDetails.data['name']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .merge(TextStyle(
                                            letterSpacing: 1.3,
                                            color: Colors.white)),
                                  ),
                            _con.isLoading
                                ? Text(currentUser.value.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white))
                                : Text(
                                    '${_con.passBookDetails.data['email']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .merge(TextStyle(
                                            letterSpacing: 1.3,
                                            color: Colors.white)),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Available Balance:     ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .merge(TextStyle(
                                          letterSpacing: 1.3,
                                          color: Colors.white)),
                                ),
                                _con.isLoading
                                    ? Text('0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: Colors.white))
                                    : Text(
                                        '₹ ${_con.passBookDetails.data['ewallet_amount']}'
                                            .substring(0, 7),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 30))
                              ],
                            ),
                          ],
                        ),
                      )),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.transfer_within_a_station_sharp,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'Transaction',
//              S.of(context).about,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDebit = true;
                            });
                          },
                          child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.1),
                                  color: _isDebit
                                      ? Theme.of(context).accentColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text('DEBITED',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            color: _isDebit
                                                ? Colors.white
                                                : null)),
                              )),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDebit = false;
                            });
                          },
                          child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.1),
                                  color: !_isDebit
                                      ? Theme.of(context).accentColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text('CREDITED',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            color: !_isDebit
                                                ? Colors.white
                                                : null)),
                              )),
                        ),
                      ],
                    ),
                  ),
                  _con.transaction.isEmpty
                      ? EmptyTransactionWidget()
                      : _isDebit
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.transaction.length,
                              itemBuilder: (context, index) {
                                var _data = _con.transaction.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TransactionItemWidget(
                                    data: _data,
                                  ),
                                );
                                TransactionTile(_data);
                              },
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.transactionCredit.length,
                              itemBuilder: (context, index) {
                                var _data =
                                    _con.transactionCredit.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TransactionItemWidget(
                                    data: _data,
                                  ),
                                );
                                TransactionTile(_data);
                              },
                            ),
                  SizedBox(height: 60,)
                ],
              ),
            ),
    );
  }
  Widget EmptyTransactionWidget() {
    return Column(
      children: [
        SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Stack(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Theme.of(context).focusColor.withOpacity(0.7),
                        Theme.of(context).focusColor.withOpacity(0.05),
                      ])),
              child: Icon(
                Icons.transfer_within_a_station,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 70,
              ),
            ),
            Positioned(
              right: -30,
              bottom: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Positioned(
              left: -20,
              top: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        Opacity(
          opacity: 0.4,
          child: Text(
            "You don't have any transactions",
//            S.of(context).youDontHaveAnyOrder,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline3
                .merge(TextStyle(fontWeight: FontWeight.w300)),
          ),
        ),
      ],
    );
  }
  Widget TransactionTile(Map<String, dynamic> data) {
    return Container(
      child: Column(
        children: [
          Text('${data['ewallet_passbook_id']}'),
          Text(data['message']),
          Text('${data["transaction_type"]}'),
          Text('${data["transaction_amount"]}')
        ],
      ),
    );
  }
}
