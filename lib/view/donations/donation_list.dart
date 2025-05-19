import 'package:anshinpet/res/components/donation_card.dart';
import 'package:anshinpet/view_model/donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationList extends StatelessWidget {
  final String type;
  const DonationList({super.key, required this.type});

   @override
  Widget build(BuildContext context) {
    final donateVM = Provider.of<DonationViewModel>(context);

    if (donateVM.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donateVM.donations.isEmpty) {
      return const Center(child: Text('Nenhuma doação encontrada!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: donateVM.donations.length,
      itemBuilder: (context, index) {
        final item = donateVM.donations[index];
        return DonationCard(
          tipo: item.tipo ?? type,
          valor: (item.valor ?? 0.0).toString(),
          quantidade: (item.quantidade ?? 0).toString(),
          descricao: item.descricao ?? '',
          onEdit: (){},
          onDelete: (){},
        );
      },
    );
  }
}