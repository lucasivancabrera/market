import 'package:equatable/equatable.dart';

// Uso de Equatable para que ( nuestro bloque) pueda comparar instancias del Product
class ModelProduct extends Equatable{

  // informacion perfil
  late final String id;
  late final String name;
  late final String urlimage;
  late final int price;
  late  int accountant;
  late bool select;

  ModelProduct({  this.id="",this.name="", this.urlimage="",this.price=0,this.accountant=0,this.select=false});

  // Lo creamos para factorizar documentos de Firestore
  factory ModelProduct.fromSnapshot(Map data) {
    return ModelProduct(
      id: data['id']??"",
      name: data['name']??"",
      urlimage: data['urlimage']??"",
      price: data['price']??0,
      accountant:0,
      select:false,
    );
  }

  @override
  List<Object?> get props => [id,name,urlimage,price,accountant,select];

}