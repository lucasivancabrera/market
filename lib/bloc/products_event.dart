part of 'products_bloc.dart';

abstract class ProductosDataEvent extends Equatable {
  const ProductosDataEvent();
    
  @override
  List<Object> get props => [];
}

class DataEventStart extends ProductosDataEvent {}

class DataEventLoad extends ProductosDataEvent {
  final List<List<ModelProduct>> data;
  
  const DataEventLoad(this.data);
  
  @override
  List<Object> get props => [data];
}

class DataEventFetchMore extends ProductosDataEvent {}