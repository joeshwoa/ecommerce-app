import 'package:klnakhadem/model/wallet_history_model.dart';

List<WalletHistory> createWalletHistory(List<dynamic> json) {
  final List<WalletHistory> history = [];
  for(int i=0;i<json.length;i++) {
    history.add(WalletHistory(json[i]['amount']*1.0, DateTime.parse(json[i]['createdAt'])));
  }

  return history;
}