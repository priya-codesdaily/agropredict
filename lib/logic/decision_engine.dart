import '../models/crop_model.dart';

class DecisionEngine {
  static Map<String, dynamic> analyze(List<CropPrice> prices) {
    if (prices.isEmpty) {
      return {
        'advice': 'NEUTRAL',
        'bestMandi': null,
        'avgPrice': 0.0,
        'percentAboveAvg': 0.0,
        'reasons': ['No data available'],
        'mandiCount': 0,
        'smartLine': 'No data available',
        'smartLineHindi': 'कोई डेटा उपलब्ध नहीं',
      };
    }

    double avgPrice = prices.map((p) => p.modalPrice).reduce((a, b) => a + b) / prices.length;
    CropPrice bestMandi = prices.reduce((a, b) => a.modalPrice > b.modalPrice ? a : b);
    double percentAboveAvg = ((bestMandi.modalPrice - avgPrice) / avgPrice) * 100;

    String advice;
    if (percentAboveAvg > 20) {
      advice = 'SELL';
    } else if (avgPrice > 2500 && percentAboveAvg < 10) {
      advice = 'SELL';
    } else if (avgPrice < 1500) {
      advice = 'WAIT';
    } else if (percentAboveAvg > 10) {
      advice = 'WAIT';
    } else {
      advice = 'NEUTRAL';
    }

    List<String> reasons = [];
    if (advice == 'SELL') {
      reasons.add('Price is ${percentAboveAvg.toStringAsFixed(0)}% higher than nearby markets');
      reasons.add('Best rate found in ${bestMandi.market}');
      reasons.add('Good time to sell — prices are stable');
    } else if (advice == 'WAIT') {
      reasons.add('Average price is currently low');
      reasons.add('Prices may improve in 5-7 days');
      reasons.add('Better opportunities expected soon');
    } else {
      reasons.add('Prices are similar across all mandis');
      reasons.add('Monitor for 2-3 more days');
    }

    String smartLine;
    String smartLineHindi;
    if (advice == 'SELL') {
      if (percentAboveAvg > 30) {
        smartLine = 'Unusually high price — sell immediately before it drops';
        smartLineHindi = 'असामान्य रूप से ऊँचा दाम — तुरंत बेचें, घट सकता है';
      } else if (percentAboveAvg > 20) {
        smartLine = 'Strong demand detected — good time to sell';
        smartLineHindi = 'ज़्यादा माँग है — अभी बेचना फायदेमंद है';
      } else {
        smartLine = 'Stable price — sell now to avoid future risk';
        smartLineHindi = 'दाम स्थिर है — अभी बेचो, जोखिम से बचो';
      }
    } else if (advice == 'WAIT') {
      smartLine = 'Prices rising — waiting 3-5 days may get better rates';
      smartLineHindi = 'दाम बढ़ रहे हैं — 3-5 दिन रुकने पर बेहतर भाव मिल सकता है';
    } else {
      smartLine = 'Monitor daily — prices could move either way';
      smartLineHindi = 'रोज़ देखते रहें — दाम किसी भी तरफ जा सकते हैं';
    }

    return {
      'advice': advice,
      'bestMandi': bestMandi,
      'avgPrice': avgPrice,
      'percentAboveAvg': percentAboveAvg,
      'reasons': reasons,
      'mandiCount': prices.length,
      'smartLine': smartLine,
      'smartLineHindi': smartLineHindi,
    };
  }

  static Map<String, dynamic> calculateProfit({
    required double price,
    required double quantity,
    required double distance,
    double costPerKm = 10.0,
  }) {
    double totalRevenue = price * quantity;
    double transportCost = distance * costPerKm;
    double netProfit = totalRevenue - transportCost;
    double profitPerQuintal = netProfit / quantity;
    bool worthIt = netProfit > (totalRevenue * 0.7);
    return {
      'totalRevenue': totalRevenue,
      'transportCost': transportCost,
      'netProfit': netProfit,
      'profitPerQuintal': profitPerQuintal,
      'worthIt': worthIt,
    };
  }
}
