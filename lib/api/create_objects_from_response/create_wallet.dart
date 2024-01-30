import 'package:klnakhadem/api/create_objects_from_response/create_wallet_history.dart';
import 'package:klnakhadem/model/wallet_history_model.dart';
import 'package:klnakhadem/model/wallet_model.dart';

Wallet createWallet(Map<String, dynamic> json) {
  final double amount = json['ammount']*1.0;
  final List<WalletHistory> history = createWalletHistory(json['history']);

  return Wallet(amount, history);
}
