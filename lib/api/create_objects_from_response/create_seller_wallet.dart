import 'package:klnakhadem/api/create_objects_from_response/create_wallet_history.dart';
import 'package:klnakhadem/model/seller_wallet_model.dart';
import 'package:klnakhadem/model/wallet_history_model.dart';

SellerWallet createSellerWallet(Map<String, dynamic> json) {
  final double amount = json['amount']*1.0;
  final double transfered = json['transfered']*1.0;
  final double wait = json['wait']*1.0;
  final int point = json['point'];
  final List<WalletHistory> history = createWalletHistory(json['history']);

  return SellerWallet(amount, point, transfered, wait, history);
}
