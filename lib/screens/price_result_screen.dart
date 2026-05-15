import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../logic/decision_engine.dart';

class PriceResultScreen extends StatelessWidget {
  final String cropName;
  final List<CropPrice> prices;

  const PriceResultScreen({
    super.key,
    required this.cropName,
    required this.prices,
  });
  // Price unit state
bool showPerKg = false;

  @override
  Widget build(BuildContext context) {
    // 🔥 Decision Engine
final decision = DecisionEngine.analyze(prices);
final advice = decision['advice'] as String;
final bestMandi = decision['bestMandi'] as CropPrice?;
final reasons = decision['reasons'] as List<String>;
final mandiCount = decision['mandiCount'] as int;
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          cropName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Best Mandi Recommendation",
              style: TextStyle(
                color: Color(0xFF52B788),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 📍 Best Mandi Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2744),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "📍 ${bestMandi.market}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "💰 ₹${bestMandi.price} / क्विंटल",
                    style: const TextStyle(color: Color(0xFF52B788)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "🚚 दूरी: ${distance.toStringAsFixed(1)} km",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "📈 अनुमानित लाभ: ₹${profit.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                ],
              ),
            ),
Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text(
        '₹${_getPrice(bestMandi.modalPrice).toStringAsFixed(_showPerKg ? 1 : 0)}',
        style: const TextStyle(
            color: Color(0xFF52B788),
            fontSize: 24,
            fontWeight: FontWeight.w900)),
    // Toggle right here — visible!
    GestureDetector(
      onTap: () => setState(() => _showPerKg = !_showPerKg),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF52B788).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF52B788).withOpacity(0.4)),
        ),
        child: Text(
          _showPerKg
              ? (widget.isHindi ? '₹/किलो में' : 'per kg ↕')
              : (widget.isHindi ? '₹/क्विंटल में' : 'per quintal ↕'),
          style: const TextStyle(
              color: Color(0xFF52B788),
              fontSize: 10,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ],
),
            const SizedBox(height: 30),

            const Text(
              "All Mandi Prices",
              style: TextStyle(
                color: Color(0xFF52B788),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          // Price toggle
Row(
  children: [
    GestureDetector(
      onTap: () => setState(() => showPerKg = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: !showPerKg ? const Color(0xFF52B788) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isHindi ? 'क्विंटल' : '/quintal',
          style: TextStyle(
              fontSize: 11,
              color: !showPerKg ? Colors.black : Colors.white),
        ),
      ),
    ),
    const SizedBox(width: 6),
    GestureDetector(
      onTap: () => setState(() => showPerKg = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: showPerKg ? const Color(0xFF52B788) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isHindi ? 'किलो' : '/kg',
          style: TextStyle(
              fontSize: 11,
              color: showPerKg ? Colors.black : Colors.white),
        ),
      ),
    ),
  ],
),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: prices.length,
                itemBuilder: (context, index) {
                  final mandi = prices[index];

                  return Card(
                    color: const Color(0xFF1A2744),
                    child: ListTile(
                      title: Text(
                        mandi.market,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "₹${mandi.modalPrice}",
                        style: const TextStyle(color: Color(0xFF52B788)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}