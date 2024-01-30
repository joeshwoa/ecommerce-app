import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buyer_layout_state.dart';

class BuyerLayoutCubit extends Cubit<BuyerLayoutState> {
  BuyerLayoutCubit() : super(BuyerLayoutInitial());

  static BuyerLayoutCubit getCubit(context) => BlocProvider.of(context);

  static int cartNumber = 0;

  bool b = true;

  void fetchCartNumber () {
    if(b) {
      b = !b;
      emit(StartFetching());
    } else {
      b = !b;
      emit(EndFetching());
    }
  }

  void endFetchCartNumber () {
    emit(EndFetching());
  }
  
}
