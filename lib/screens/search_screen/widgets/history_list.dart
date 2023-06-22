import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/styles.dart';
import '../bloc/history_case.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final historyData = SearchHistoryCase().load().toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: historyData.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            color: AppColors.layer1,
            elevation: 0,
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                historyData[index],
                style: AppStyles.textBody,
              ),
            ));
      },
    );
  }
}
