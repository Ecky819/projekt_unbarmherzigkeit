// File: timeline_entry_widget.dart
import 'package:flutter/material.dart';
import '../theme/app_textstyles.dart';
import '../theme/app_colors.dart';

class TimelineEntry extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final VoidCallback onPressed;
  final bool isFirst;
  final bool isLast;

  const TimelineEntry({
    super.key,
    required this.date,
    required this.title,
    required this.description,
    required this.onPressed,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    const double dotSize = 18.0;
    const double lineThickness = 3.0;
    const double indicatorColumnWidth = 40.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: indicatorColumnWidth,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: lineThickness,
                    color: AppColors.timeline,
                  ),
                ),
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: const BoxDecoration(
                    color: AppColors.timeline,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: lineThickness,
                    color: AppColors.timeline,
                  ),
                ),
                if (isLast)
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.timeline,
                    size: 36.0,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Card(
              color: const Color.fromRGBO(243, 239, 231, 1.0),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            date,
                            style: AppTextStyles.heading.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            description,
                            style: AppTextStyles.card.copyWith(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/more_info_right.png',
                          width: 36,
                          height: 55,
                        ),
                        onPressed: onPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
