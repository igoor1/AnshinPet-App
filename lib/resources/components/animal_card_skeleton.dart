import 'package:flutter/material.dart';

class AnimalCardSkeleton extends StatelessWidget {
  const AnimalCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const loadingColor = Color(0xFFE0E0E0); 

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: loadingColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 18,
                  decoration: BoxDecoration(
                    color: loadingColor,
                    borderRadius: BorderRadius.circular(4)
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: loadingColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: loadingColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}