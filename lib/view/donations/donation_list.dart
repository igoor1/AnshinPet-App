import 'package:anshinpet/res/components/donation_card.dart';
import 'package:anshinpet/res/utils/dialog_utils.dart';
import 'package:anshinpet/view/donations/edit_donation_page.dart';
import 'package:anshinpet/view_model/donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationList extends StatelessWidget {
  final String type;
  const DonationList({super.key, required this.type});

   @override
  Widget build(BuildContext context) {
    final donationVM = Provider.of<DonationViewModel>(context);

    if (donationVM.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donationVM.donations.isEmpty) {
      return const Center(child: Text('Nenhuma doação encontrada!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: donationVM.donations.length,
      itemBuilder: (context, index) {
        final item = donationVM.donations[index];
        return DonationCard(
          tipo: item.tipo ?? type,
          valor: (item.valor ?? 0.0).toString(),
          quantidade: (item.quantidade ?? 0).toString(),
          descricao: item.descricao ?? '',
          onEdit: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditDonationPage(donation: item),
              )
            ).then((updated) {
              if (updated == true) {
                final donationVM = Provider.of<DonationViewModel>(context, listen: false);
                donationVM.fetchDonations(item.tipo!);
              }
            });
          },
          onDelete: () async {
            final confirmed = await DialogUtils.showConfirmationDialog(
              context,
              content: "Deseja realmente deletar esta doação?",
            );
            if (confirmed && item.id != null){
              await donationVM.deleteDonation(item.id!);
            }
          },
        );
      },
    );
  }
}