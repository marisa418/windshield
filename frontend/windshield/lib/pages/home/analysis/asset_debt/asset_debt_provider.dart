import 'package:flutter/material.dart';

import 'asset_debt_model.dart';

class AssetDebtProvider extends ChangeNotifier {
  List<AssetDebtGraph> _graph = [];
  List<AssetDebtGraph> get graph => _graph;

  AssetDebt _assetDebt = AssetDebt(
      maxAsset: 0,
      maxDebt: 0,
      maxBalance: 0,
      minAsset: 0,
      minDebt: 0,
      minBalance: 0,
      avgAsset: 0,
      avgDebt: 0,
      avgBalance: 0);
  AssetDebt get assetDebt => _assetDebt;

  void setGraph(List<AssetDebtGraph> value) {
    _graph = value;
  }

  void setAssetDebt(AssetDebt value) {
    _assetDebt = value;
  }
}
