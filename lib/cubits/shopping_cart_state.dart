part of 'shopping_cart_cubit.dart';

@immutable
abstract class ShoppingCartState {}

class ShoppingCartInitial extends ShoppingCartState {}

class DeleteItem extends ShoppingCartState {}
class Refresh extends ShoppingCartState {}
class Loading extends ShoppingCartState {}
class StopLoading extends ShoppingCartState {}