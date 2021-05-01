import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:market_app/models/model_producto.dart';
import 'package:market_app/repositry/products_repository.dart';

part 'products_state.dart';
part 'products_event.dart';

class ProductsBloc extends Bloc<ProductosDataEvent, ProductsState> {
  ProductsBloc() : super(DataStateLoading());
  
  final List<StreamSubscription> subscriptions = [];
  final List<List<ModelProduct>> products = [];
  bool hasMoreData = true;
  DocumentSnapshot ?lastDoc;

  // Usamos esta función para manejar eventos de nuestras transmisiones
  handleStreamEvent(int index, QuerySnapshot snap) {
    //Solicitamos 15 documentos a la vez
    if (snap.docs.length < 15) {
      hasMoreData = false;
    }
    
    //Si la instantánea está vacía, no hay nada que podamos hacer
    if (snap.docs.isEmpty) return;
    
    if (index == products.length) {
      // Establecer el último documento que extrajimos para usarlo como cursor
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Convierta QuerySnapshot en una lista de publicaciones
    List<ModelProduct> newList = [];
    snap.docs.forEach((doc) {
      // Este es un buen lugar para filtrar sus datos si no puede
      // para redactar la consulta que desee.
      newList.add(ModelProduct.fromSnapshot(doc.data()));
    });
    // Actualizar la lista de publicaciones
    if (products.length <= index) {
      products.add(newList);
    } else {
      products[index].clear();
      products[index] = newList;
    }
    add(DataEventLoad(products));
  }
  
  @override
  Stream<ProductsState> mapEventToState(ProductosDataEvent event) async* {


    if (event is DataEventStart) {
      // Limpia nuestras variables
      hasMoreData = true;
      lastDoc = null;
      subscriptions.forEach((sub) {sub.cancel();});
      products.clear();
      subscriptions.clear();
      subscriptions.add(  ProductsRepository.instance.getProducts().listen((event) { handleStreamEvent(0, event);  })   );
      add(DataEventLoad(products));
    }
    
    if (event is DataEventLoad) {
      // Aplanar la lista de publicaciones
      final elements = event.data.expand((i) => i).toList();
      
      if (elements.isEmpty) {
        yield DataStateEmpty();
      } else {
        yield DataStateLoadSuccess(products: elements, hasMoreData: hasMoreData);
      }
    }
    
    if (event is DataEventFetchMore) {
      if (lastDoc == null) {
        throw Exception("El último documento no está configurado");
      }
      final index = products.length;
      subscriptions.add(
        ProductsRepository.instance.getProductosPage(lastDoc!).listen((event) {
          handleStreamEvent(index, event);
        })
      );
    }
  }

  @override
  onChange(change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() async {
    subscriptions.forEach((s) => s.cancel());
    super.close();
  }
}