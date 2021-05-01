import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:market_app/models/model_producto.dart';

part 'cartShopping_state.dart';

class CartShoppingBloc extends Cubit<CartShoppingState> {
  
  CartShoppingBloc() : super( EmptyShoppingCart() );

  int _getPriceTotal({required List<ModelProduct> list}){
    int priceTotal = 0 ;
    // Sumamos el precio total
    list.forEach( (element) =>  priceTotal+=element.price* element.accountant);
    return priceTotal;
  }
  int _getAccountant({required List<ModelProduct> list}){
    int accountant = 0 ;
    // Hacemos la suma de del total de productos que hay en el carrito
    list.forEach( (element) =>  accountant+=element.accountant );
      
    return accountant;
  }
  
  void deleteProduct( ModelProduct product ){
    final currentState = state;
    if ( currentState is CartShoppingList ) {

      // Actualizamos los contadores de la cantidad de veces que el producto de selecciono
      for (var i = 0; i < currentState.list.length; i++){
        if(currentState.list[i].id==product.id){
          currentState.list[i].accountant=0;
          currentState.list.removeAt(i);
        }
      }

      emit(CartShoppingList(list:currentState.list,accountant: _getAccountant(list: currentState.list),pricetotal:_getPriceTotal(list: currentState.list) ));

    }
  }
  void addCount( ModelProduct product ){
    final currentState = state;
    if ( currentState is CartShoppingList ) {


      // Actualizamos los contadores de la cantidad de veces que el producto de selecciono
      for (var i = 0; i < currentState.list.length; i++){
        if(currentState.list[i].id==product.id){
          currentState.list[i].accountant++;
        }
      }
    
      emit(CartShoppingList(list:currentState.list,accountant: _getAccountant(list: currentState.list),pricetotal: _getPriceTotal(list: currentState.list) ));

    }
  }
  void subtractCount( ModelProduct product ){
    final currentState = state;
    if ( currentState is CartShoppingList ) {


      // Actualizamos los contadores de la cantidad de veces que el producto de selecciono
      for (var i = 0; i < currentState.list.length; i++){
        if(currentState.list[i].id==product.id){
          if(currentState.list[i].accountant>1) currentState.list[i].accountant--;
        }
      }

      emit(CartShoppingList(list:currentState.list,accountant: _getAccountant(list: currentState.list),pricetotal: _getPriceTotal(list: currentState.list) ));

    }
  }
  //  * Metodo para agregar un nuevo producto al carrito de compras 
  //  * emite la lista de productos seleccionados y el numero total del arreglo con la lista de productos seleccionados
  void addProductoToCartShopping( ModelProduct product ){
    final currentState = state;
    if ( currentState is CartShoppingList ) {
      // Actualizamos la lista con el nuevo producto
      final list=[
        product,
        ...currentState.list,
      ];
      // Creamos una nueva lista y eliminados los objetos duplicados
      var listProductsCartFilterRepeat=list.toSet().toList();
      // Actualizamos los contadores de la cantidad de veces que el producto de selecciono
      for (var i = 0; i < listProductsCartFilterRepeat.length; i++){
        if(listProductsCartFilterRepeat[i].id==product.id){
          listProductsCartFilterRepeat[i].accountant++;
        }
      }
    
      emit(CartShoppingList(list:listProductsCartFilterRepeat,accountant: _getAccountant(list: currentState.list),pricetotal:_getPriceTotal(list: currentState.list) ));

    }else{
      // Actualizamos el estado y inicializamos el arreglo con el primero objeto
      product.accountant=1; /* inicializamos a 1 poruqe sino */
      emit(CartShoppingList(list: [product],accountant: product.accountant,pricetotal:product.price ));
    }
  }
  //  * metodo para limpiar la lista del carrito de compras
  void cleanCartShopping() => emit(EmptyShoppingCart()) ;

}
