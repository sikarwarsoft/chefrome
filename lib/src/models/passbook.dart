class PassBookDetails {
  PassBookDetails({
    this.status,
    this.msg,
    this.data,
  });

  bool status;
  String msg;
  Map<String, dynamic> data;

  PassBookDetails.fromJson(Map<String,dynamic> jsonMap){
    status = jsonMap['status'] !=null ? jsonMap['status']:'';
    msg = jsonMap['msg'] != null ? jsonMap['msg']:'';
    data = jsonMap['data'] !=null ? jsonMap['data']:'';

  }
}

//class Data {
//  Data({
//    this.ewalletPassbookId,
//    this.transactionId,
//    this.message,
//    this.transactionType,
//    this.name,
//    this.email,
//    this.ewalletAmount,
//  });
//
//  final int ewalletPassbookId;
//  final String transactionId;
//  final String message;
//  final String transactionType;
//  final String name;
//  final String email;
//  final double ewalletAmount;
//}