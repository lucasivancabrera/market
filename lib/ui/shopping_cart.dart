
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/cubit/cartShopping_cubit.dart';
import 'package:market_app/models/model_producto.dart';


class PageSoppingCart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context: context),
      body: body(context: context),
    );
  }
  /*VIEWS*/
  AppBar appbar({required BuildContext context}){
    return AppBar(
      title: textPrice(),
      actions: [
        IconButton(onPressed: (){ context.read<CartShoppingBloc>().cleanCartShopping(); }, icon: Icon(Icons.delete_sweep))
      ],
    );
  }
  Widget body({required BuildContext context}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: ListProductCartShopping()),
        ElevatedButton(
            onPressed: (){ 
              Navigator.pushReplacementNamed(context, "splash_SuccessFullPurchase"); 
              context.read<CartShoppingBloc>().cleanCartShopping();
              },
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(30.0)),backgroundColor:MaterialStateProperty.all(Colors.green)),
            child: Text("Comprar",style:TextStyle(fontSize: 24.0,color: Colors.white))),
      ],
    );
  }
  Widget textPrice(){
     return BlocBuilder<CartShoppingBloc, CartShoppingState>(
      builder: ( _ , state) {
        switch ( state.runtimeType ) {
          case CartShoppingList:
            return Text("Total: \$"+(state as CartShoppingList).pricetotal.toString());
          default:
            return Text('');
        }
    });
  }

}

class ListProductCartShopping extends StatelessWidget {

  // Creamos cubit con un swich y los diferentes estados

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartShoppingBloc, CartShoppingState>(
      builder: ( _ , state) {
        switch ( state.runtimeType ) {
          case EmptyShoppingCart:
            return Center(child: Text('No hay ningun producto seleccionado'));
          case CartShoppingList:
            List<ModelProduct> products = (state as CartShoppingList).list;
            return products.length!=0?ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTileItemProduct(products: products[index]);
              },
            ):Center(child: Text("Sin Productos"),);
          default:
            return Center( child: Text('Estado no reconocido '));
        }
    });
  }
}

class ListTileItemProduct extends StatelessWidget {
  const ListTileItemProduct({
    Key? key,
    required this.products,
  }) : super(key: key);

  final ModelProduct products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(products.name),
              leading: CircleAvatar(radius: 13.0,
              child: Text(products.accountant.toString(),style:TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red),
              ),
            ),
          IconButton(onPressed: (){ context.read<CartShoppingBloc>().subtractCount(products);  }, icon: Text("-",style: TextStyle(fontSize: 20.0))),
          IconButton(onPressed: (){ context.read<CartShoppingBloc>().addCount(products);  }, icon: Text("+",style: TextStyle(fontSize: 20.0))),
          IconButton(onPressed: (){ context.read<CartShoppingBloc>().deleteProduct(products);  }, icon:Icon(Icons.delete)),
        ],
      ),
    );
  }
}
