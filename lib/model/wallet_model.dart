import 'package:klnakhadem/model/wallet_history_model.dart';

class Wallet {
  Wallet(this.amount,this.history);
  double amount;
  List<WalletHistory> history;
}