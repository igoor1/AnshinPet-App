import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/bottom_navigation_bar_custom.dart';
import 'package:anshinpet/res/components/drawer_custom.dart';
import 'package:anshinpet/view/donations/donation_list.dart';
import 'package:anshinpet/view/donations/donation_type_selector.dart';
import 'package:anshinpet/view/donations/new_donation_page.dart';

import 'package:anshinpet/view_model/donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String _selectedType = 'D';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData([String? type]) {
    final fetchType = type ?? _selectedType;
    context.read<DonationViewModel>().fetchDonations(fetchType);
  }

  void _changeType(String type) {
    if (_selectedType != type) {
      setState(() => _selectedType = type);
      _fetchData();
    }
  }

  final newDonationPage = NewDonationPage();

  void _openAddExpensiveOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context, 
      builder: (ctx) => NewDonationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarCustom(),
      drawer: DrawerCustom(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Doações",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.primary
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: DonationTypeSelector(
              selectedType: _selectedType, 
              onChanged: _changeType
            ),
          ),
          const Divider(),
          const SizedBox(height: 10,),
          Expanded(
            child: DonationList(
              type: _selectedType,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarCustom(valueIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpensiveOverlay, 
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      )
    );
  }
}