part of 'buyer_layout_cubit.dart';

@immutable
abstract class BuyerLayoutState {}

class BuyerLayoutInitial extends BuyerLayoutState {}

class StartFetching extends BuyerLayoutState {}
class EndFetching extends BuyerLayoutState {}
