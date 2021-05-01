part of 'cartShopping_cubit.dart';

@immutable
abstract class CartShoppingState {}

class EmptyShoppingCart extends CartShoppingState {
  final list = [];
}

class CartShoppingList extends CartShoppingState {
  final List<ModelProduct> list;
  final int accountant;
  final int pricetotal;
  CartShoppingList({required this.list,required this.accountant,required this.pricetotal});
}

