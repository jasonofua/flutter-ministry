import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebViewRedirect extends StatefulWidget {

  String value;

  WebViewRedirect({Key key, this.value}) : super(key: key);

  @override
  _WebViewRedirectState createState() => _WebViewRedirectState();
}

class _WebViewRedirectState extends State<WebViewRedirect> {



  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text('Salvation Ministries Digital Library'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      url: widget.value,
      withZoom: true,
    );
  }
}

