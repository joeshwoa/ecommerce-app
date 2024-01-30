import 'package:klnakhadem/model/wallet_history_model.dart';

class SellerWallet {
  SellerWallet(this.amount,this.point,this.transfered,this.wait,this.history);
  double amount;
  double wait;
  double transfered;
  int point;
  List<WalletHistory> history;
}