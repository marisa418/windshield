class Stat {
  double? netWorth;
  double? netCashFlow;
  double? survivalRatio;
  double? wealthRatio;
  double? basicLiquidRatio;
  double? debtServiceRatio;
  double? savingRatio;
  double? investRatio;
  double? financialHealth;

  Stat({
    required this.netWorth,
    required this.netCashFlow,
    required this.survivalRatio,
    required this.wealthRatio,
    required this.basicLiquidRatio,
    required this.debtServiceRatio,
    required this.savingRatio,
    required this.investRatio,
    required this.financialHealth,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        netWorth: json['Net Worth'],
        netCashFlow: json['Net Cashflow'],
        survivalRatio: json['Survival Ratio'],
        wealthRatio: json['Wealth Ratio'],
        basicLiquidRatio: json['Basic Liquidity Ratio'],
        debtServiceRatio: json['Debt Service Ratio'],
        savingRatio: json['Saving Ratio'],
        investRatio: json['Investment Ratio'],
        financialHealth: json['Financial Health'],
      );
}
