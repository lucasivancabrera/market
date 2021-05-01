
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/bloc/products_bloc.dart';
import 'package:market_app/cubit/cartShopping_cubit.dart';
import 'package:market_app/ui/SuccessfulPurchaseSplash.dart';
import 'package:market_app/ui/principal.dart';
import 'package:market_app/ui/shopping_cart.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [  
        BlocProvider(create: (_) => new CartShoppingBloc()), 
        BlocProvider(create: (_) => new ProductsBloc()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue,),
        initialRoute: "/",
        routes: {
          '/': (context) => PagePrincipal(),
          'page_shopping_cast': (context) => PageSoppingCart(),
          'splash_SuccessFullPurchase': (context) => SuccessfulPurchaseSplash(),
        },
      ),
    );
  }
}
