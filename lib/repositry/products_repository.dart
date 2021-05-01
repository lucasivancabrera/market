import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsRepository {
  // Singleton boilerplate
  ProductsRepository._();
  
  static ProductsRepository _instance = ProductsRepository._();
  static ProductsRepository get instance => _instance;
  
  // Instance
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection('/products');
  
  Stream<QuerySnapshot> getProducts() {
    return _postCollection
      .limit(15)
      .snapshots();
  }
  
  Stream<QuerySnapshot> getProductosPage(DocumentSnapshot lastDoc) {
    return _postCollection
        .startAfterDocument(lastDoc)
        .limit(15)
        .snapshots();
  }
}