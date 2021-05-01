
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/cubit/cartShopping_cubit.dart';
import 'package:market_app/bloc/products_bloc.dart';
import 'package:market_app/models/model_producto.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PagePrincipal extends StatefulWidget {

  @override
  _PagePrincipalState createState() => _PagePrincipalState();
}

class _PagePrincipalState extends State<PagePrincipal> {

  ProductsBloc _productsBloc = ProductsBloc();

  @override
  initState() {
    super.initState();
    _productsBloc.add(DataEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: body(),
    );
  }

  /* VIEWS */
  PreferredSizeWidget appbar(){
    return AppBar(title: Text("Market"),actions: [ButtonCast()]);
  }
  Widget body(){
    return  BlocBuilder<ProductsBloc, ProductsState>(
        bloc: _productsBloc,
        builder: ( context,  state) {
          // Creaemos un swich con los diferentes estados
          switch (state.runtimeType) {
            case DataStateLoading:
              return Center(child: CircularProgressIndicator());
            case DataStateEmpty:
              return Center(child: Text('No hay ningun producto', style: Theme.of(context).textTheme.bodyText1));
            case DataStateLoadSuccess:
              return customScrollView(list: (state as DataStateLoadSuccess).products );
            default:
              return Center(child: Text("Estado no reconido :("),);
          }
        }
    );
  }

  /* VIEWS */
  CustomScrollView customScrollView({required List<ModelProduct> list}){
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>  ProductoItem(product: list[index]),childCount:list.length),
        ),
      ],
    );
  } 
}

/* Class Compnents */
class ButtonCast extends StatelessWidget {
  
  // Creamos un IconButton con un contador de productos agregados a carrito de compras en forma de insignea

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        alignment: Alignment.topRight,
            children: [
              IconButton(onPressed: (){Navigator.pushNamed(context,"page_shopping_cast");}, icon: Icon(Icons.shopping_cart)),
              BlocBuilder<CartShoppingBloc, CartShoppingState>(
                builder: ( _ , state) {
                  if( state is CartShoppingList && state.accountant != 0 ) { 
                    return CircleAvatar(radius: 10.0,child:Text(state.accountant.toString(),style:TextStyle(fontSize: 10.0,color: Colors.white,fontWeight: FontWeight.bold)),backgroundColor: Colors.red);
                  }else{return Container();}
                })
            ],
      ),
    );
  }
}

class ProductoItem extends StatefulWidget {
  
  final ModelProduct product;
  final double width;
  const ProductoItem({ required this.product, this.width = double.infinity});

  @override
  _ProductoItemState createState() => _ProductoItemState();
}

class _ProductoItemState extends State<ProductoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Card(
        elevation: 1,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {  
            context.read<CartShoppingBloc>().addProductoToCartShopping(widget.product); 
            },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  imagenProducto(product: widget.product),
                  contentInfo(context: context,product: widget.product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imagenProducto({ required ModelProduct product }) {
    return AspectRatio(
      aspectRatio: 100 / 100,
      child: CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              imageUrl: product.urlimage,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(color: Colors.grey,child: Center(child: Icon(Icons.broken_image))),
            ),
    );
  }

  Widget contentInfo({ required BuildContext context,required ModelProduct product }) {

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13), topRight: Radius.circular(13)),
      child: Container(
        color: product.select==false?Colors.black45:Theme.of(context).primaryColorDark.withOpacity(0.70),//Colors.black54,
        child: ClipRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      product.name != "" && product.name != "default"
                          ? Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),overflow: TextOverflow.fade,softWrap: false)
                          : Container(),
                      product.price != 0
                          ? Text("\$ ${product.price }",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.white),overflow: TextOverflow.fade,softWrap: false)
                          : Container(),
                    ],
                  ),
                ),
              ),
              // Text(topic.description)
            ],
          ),
        ),
      ),
    );
  }
}

