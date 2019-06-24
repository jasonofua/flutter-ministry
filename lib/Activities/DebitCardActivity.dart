import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salvation_ministries_library/Tasbs/Profile.dart';


class CreditCardExample extends StatefulWidget {

  @override
  _CreditCardExampleState createState() => _CreditCardExampleState();
}

class _CreditCardExampleState extends State<CreditCardExample> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';


  void saveCard(String cardNm,String expireDt,String cardName,String cvv)async{
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('cNum', cardNm);
    prefs.setString('expire', expireDt);
    prefs.setString('cName', cardName);
    prefs.setString('cvv', cvv);

    Fluttertoast.showToast(
        msg: "Saving Card.. please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);

  }

  final MaskedTextController _cardNumberController =
  MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
  MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  bool isCvvFocused = false;

  void textFieldFocusDidChange() {
    setState(() {
      isCvvFocused = cvvFocusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text('Add a debit card'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: TextFormField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card number',
                            hintText: 'xxxx xxxx xxxx xxxx',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expired Date',
                              hintText: 'MM/YY'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Holder',
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextField(
                          focusNode: cvvFocusNode,
                          controller: _cvvCodeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'XXXX',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) {
                            setState(() {
                              cvvCode = text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0,bottom: 10.0),
                child: ButtonTheme(
                  minWidth: 280.0,
                  height: 40.0,

                  child :  RaisedButton(
                      onPressed: () {
                        saveCard(cardNumber, expiryDate, cardHolderName, cvvCode);
                      },
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      child: const Text('Save Card'),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

