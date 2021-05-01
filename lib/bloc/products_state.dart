part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  
  @override
  List<Object> get props => [];
}

class DataStateLoading extends ProductsState {}

class DataStateEmpty extends ProductsState {}

class DataStateLoadSuccess extends ProductsState {
  final List<ModelProduct> products;
  final bool hasMoreData;
  
  const DataStateLoadSuccess({required this.products,required this.hasMoreData});
  
  @override
  List<Object> get props => [products];
}
