import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

final TextEditingController _cardNumber = TextEditingController();
final TextEditingController _cvv = TextEditingController();
final TextEditingController _expireDate = TextEditingController();
final TextEditingController _nameOnCard = TextEditingController();

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF00BF8F),
                Color(0xFF001510),
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Card Number',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //textField are for card number
                Container(
                  height: 47.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.0),
                        right: Radius.circular(20.0)),
                  ),
                  child: TextFormField(
                    controller: _cardNumber,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0000 0000 0000 0000',
                      hintStyle: TextStyle(),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Expire Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'CVV',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 15.0),
                    ],
                  ),
                ),

                //textfield area for expire date and CVV
                Row(
                  children: <Widget>[
                    //expire date
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 47.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20.0),
                              right: Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          controller: _expireDate,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'mm/yy',
                            hintStyle: TextStyle(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),

                    //cvv
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 47.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20.0),
                              right: Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          controller: _cvv,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '875',
                            hintStyle: TextStyle(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //textfield for name on card
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Name on Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 47.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.0),
                        right: Radius.circular(20.0)),
                  ),
                  child: TextFormField(
                    controller: _nameOnCard,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Biki Deka',
                      hintStyle: TextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                FlatButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20)),
                        color: Colors.deepOrange,
                      ),
                      child: Center(
                        child: Text(
                          'Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
