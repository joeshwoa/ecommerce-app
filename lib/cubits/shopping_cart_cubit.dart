import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klnakhadem/model/product_model.dart';

part 'shopping_cart_state.dart';

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  ShoppingCartCubit() : super(ShoppingCartInitial());

  static ShoppingCartCubit get(context) => BlocProvider.of(context);

  bool isLoading = false;// Flag to track if an API call is in progress

  Map<String ,List<Product>> products = {};
  Map<String ,List<String>> recordId = {};
  Map<String ,List<int>> quantities = {};
  Set<String> markets = {};
  Map<String, String> sellerId = {};
  Map<String ,int> totalProductsPrice = {};
  Map<String ,List<int>> deliveryPrice = {};
  String selectedMarket = "";

  void deleteItem (String market,int index) {
    if(products[market]!.length > 1) {
      int price = products[market]![index].price;
      products[market]!.removeAt(index);
      deliveryPrice[market]!.removeAt(index);
      recordId[market]!.removeAt(index);
      int quantity = quantities[market]![index];
      quantities[market]!.removeAt(index);
      int totalPrice = totalProductsPrice[market] ?? 0;
      totalPrice -= price*quantity;
      totalProductsPrice[market] = totalPrice;
    } else {
      products.remove(market);
      recordId.remove(market);
      quantities.remove(market);
      markets.remove(market);
      sellerId.remove(market);
      deliveryPrice.remove(market);
      totalProductsPrice.remove(market);
      if(selectedMarket == market) selectedMarket='';
    }
    emit(DeleteItem());
    emit(Refresh());
  }

  void startFetching () {
    isLoading = true;
    emit(Loading());
  }

  int getDeliveryPrice (String market) {
    int price = 0;
    for(int index = 0; index < deliveryPrice[market]!.length; index++) {
      if(price < deliveryPrice[market]![index]) {
        price = deliveryPrice[market]![index];
      }
    }
    return price;
  }

  void stopFetching () {
    isLoading = false;
    emit(Loading());
  }

}
