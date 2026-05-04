import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/crop_model.dart';
import '../services/mandi_service.dart';

class PriceResultScreen extends StatelessWidget {
  final String cropName;
  final List<CropPrice> prices;

  const PriceResultScreen({
    super.key,
    required this.cropName,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    final advice = MandiService.getSellAdvice(prices);
    final bestMandi = MandiService.getBestMandi(prices);

    Color adviceColor = advice == 'SELL'
        ? Colors.redAccent
        : advice == 'WAIT'
            ? const Color(0xFF52B788)
            : Colors.orangeAccent;

    String adviceEmoji = advice == 'SELL' ? '📉' : advice == 'WAIT' ? '📈' : '➡️';

    String bestMandiName = bestMandi != null ? bestMandi.market : 'nearby mandi';

    String adviceText = advice == 'SELL'
        ? 'Best price available at $bestMandiName.\nSell your crop there now.'
        : advice == 'WAIT'
            ? 'Prices are rising!\nWait 5-7 more days.'
            : 'Prices are neutral.\nMonitor for 2-3 days.';

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          cropName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: adviceColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: adviceColor.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(adviceEmoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    advice == 'SELL' ? 'SELL NOW' : advice == 'WAIT' ? 'WAIT — PRICES RISING' : 'MONITOR PRICES',
                    style: TextStyle(
                      color: adviceColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    adviceText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: adviceColor.withOpacity(0.8), fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (bestMandi != null) ...[
              const Text('BEST MANDI TO SELL',
                  style: TextStyle(color: Color(0xFF52B788), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2744),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF52B788).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF52B788).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.store, color: Color(0xFF52B788), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bestMandi.market,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('${bestMandi.district}, ${bestMandi.state}',
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rs.${bestMandi.modalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFF52B788), fontSize: 22, fontWeight: FontWeight.w900)),
                        const Text('per quintal', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text('MANDI PRICE COMPARISON',
                style: TextStyle(color: Color(0xFF52B788), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2744),
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text('Rs.${value.toInt()}',
                            style: const TextStyle(color: Colors.white38, fontSize: 9)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < prices.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                prices[value.toInt()].market.split(' ').first,
                                style: const TextStyle(color: Colors.white38, fontSize: 9),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: prices.asMap().entries.map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.modalPrice,
                        color: e.value == bestMandi ? const Color(0xFF52B788) : const Color(0xFF52B788).withOpacity(0.4),
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('ALL MANDIS',
                style: TextStyle(color: Color(0xFF52B788), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            ...prices.map((price) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2744),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: price == bestMandi ? const Color(0xFF52B788).withOpacity(0.5) : Colors.white.withOpacity(0.05),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(price.market,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            if (price == bestMandi) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF52B788).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('BEST',
                                    style: TextStyle(color: Color(0xFF52B788), fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                        Text(price.district,
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Rs.${price.modalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Min: Rs.${price.minPrice.toStringAsFixed(0)} | Max: Rs.${price.maxPrice.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                    ],
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            Center(
              child: Text('Data: AGMARKNET • Ministry of Agriculture, India',
                  style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}


