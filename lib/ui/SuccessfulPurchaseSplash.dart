
import 'package:flutter/material.dart';

class SuccessfulPurchaseSplash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Compra exitosa!",style: TextStyle(color:Colors.white,fontSize: 28.0)),
            ),
            MaterialButton(color: Colors.green[800],
            onPressed: (){Navigator.pop(context);},
            child: Text("OK",style: TextStyle(color:Colors.white,fontSize: 20.0)),),
          ],
        ),
      ),
    );
  }
}